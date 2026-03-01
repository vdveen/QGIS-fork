/***************************************************************************
  main.cpp — QGIS Modern UI Proof-of-Concept
  --------------------------------------------
  Demonstrates that the full QGIS rendering engine (qgis_core) can drive
  a modern Qt Quick / QML user interface, completely bypassing the legacy
  Qt Widgets layer (qgis_gui).

  Architecture:
    qgis_core  →  qgis_quick  →  QML UI  (this app)
                                   ↑
                              No qgis_gui dependency
 ***************************************************************************/

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QIcon>

#include "qgsapplication.h"
#include "qgsproject.h"
#include "qgslayerlistmodel.h"
#include "qgsmodernuiapplication.h"

// QgsQuick types — registered by the qgis_quick plugin, but we also
// register our own bridge types here.
#include "qgsquickmapcanvasmap.h"
#include "qgsquickmapsettings.h"
#include "qgsquickutils.h"

int main( int argc, char *argv[] )
{
  // ── 1. Initialize QGIS core ──────────────────────────────────────────────
  // QgsApplication inherits QGuiApplication, so it works with Qt Quick
  // without pulling in QtWidgets.
  QgsApplication app( argc, argv, false /* no GUI */ );

  // Point to QGIS resources (projections, SVG symbols, etc.)
  // Users should set QGIS_PREFIX_PATH env var or pass --prefixpath
  QString prefixPath = qgetenv( "QGIS_PREFIX_PATH" );
  if ( prefixPath.isEmpty() )
    prefixPath = QStringLiteral( "/usr" );
  QgsApplication::setPrefixPath( prefixPath, true );
  QgsApplication::initQgis();

  // ── 2. Set up the modern style ────────────────────────────────────────────
  QQuickStyle::setStyle( QStringLiteral( "Basic" ) );
  app.setApplicationName( QStringLiteral( "QGIS Modern UI" ) );
  app.setOrganizationName( QStringLiteral( "QGIS" ) );

  // ── 3. Create the application bridge ──────────────────────────────────────
  QgsModernUiApplication appBridge;

  // ── 4. Set up QML engine ──────────────────────────────────────────────────
  QQmlApplicationEngine engine;

  // Register QgsQuick QML types (MapCanvasMap, MapSettings, etc.)
  qmlRegisterType<QgsQuickMapCanvasMap>( "QgsQuick", 0, 1, "MapCanvasMap" );
  qmlRegisterUncreatableType<QgsQuickMapSettings>(
    "QgsQuick", 0, 1, "MapSettings",
    QStringLiteral( "MapSettings is obtained from MapCanvasMap" ) );
  qmlRegisterSingletonType<QgsQuickUtils>(
    "QgsQuick", 0, 1, "Utils",
    []( QQmlEngine *, QJSEngine * ) -> QObject * { return new QgsQuickUtils(); } );

  // Expose the application bridge and project to QML
  engine.rootContext()->setContextProperty( QStringLiteral( "appBridge" ), &appBridge );
  engine.rootContext()->setContextProperty( QStringLiteral( "qgisProject" ), QgsProject::instance() );

  // ── 5. Load the main QML ──────────────────────────────────────────────────
  const QUrl mainQml( QStringLiteral( "qrc:/qml/main.qml" ) );
  QObject::connect(
    &engine, &QQmlApplicationEngine::objectCreationFailed,
    &app, []() { QCoreApplication::exit( 1 ); },
    Qt::QueuedConnection );

  engine.load( mainQml );

  // ── 6. Run ────────────────────────────────────────────────────────────────
  int ret = app.exec();
  QgsApplication::exitQgis();
  return ret;
}
