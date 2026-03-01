/***************************************************************************
  qgsmodernuiapplication.h — Bridge between QGIS core and the QML UI
 ***************************************************************************/

#ifndef QGSMODERNUIAPPLICATION_H
#define QGSMODERNUIAPPLICATION_H

#include <QObject>
#include <QUrl>

#include "qgsproject.h"
#include "qgslayerlistmodel.h"

/**
 * \brief Bridge object exposed to QML as "appBridge".
 *
 * Provides high-level operations (open project, query layers, coordinate
 * display) without exposing any Qt Widgets types to the QML layer.
 */
class QgsModernUiApplication : public QObject
{
    Q_OBJECT

    Q_PROPERTY( QgsLayerListModel *layerModel READ layerModel CONSTANT )
    Q_PROPERTY( QString projectTitle READ projectTitle NOTIFY projectLoaded )
    Q_PROPERTY( QString crsDescription READ crsDescription NOTIFY projectLoaded )
    Q_PROPERTY( bool hasProject READ hasProject NOTIFY projectLoaded )

  public:
    explicit QgsModernUiApplication( QObject *parent = nullptr );

    QgsLayerListModel *layerModel() const { return mLayerModel; }
    QString projectTitle() const;
    QString crsDescription() const;
    bool hasProject() const;

    /**
     * Open a QGIS project file (.qgs / .qgz) from a local path or URL.
     * Returns true on success.
     */
    Q_INVOKABLE bool openProject( const QUrl &path );

    /**
     * Returns a formatted coordinate string for display in the status bar.
     */
    Q_INVOKABLE QString formatCoordinate( double x, double y ) const;

  signals:
    void projectLoaded();
    void projectError( const QString &message );

  private:
    QgsLayerListModel *mLayerModel = nullptr;
};

#endif // QGSMODERNUIAPPLICATION_H
