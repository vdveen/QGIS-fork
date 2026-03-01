/***************************************************************************
  qgsmodernuiapplication.cpp
 ***************************************************************************/

#include "qgsmodernuiapplication.h"
#include "qgscoordinatereferencesystem.h"
#include "qgsmaplayer.h"

#include <QFileInfo>

QgsModernUiApplication::QgsModernUiApplication( QObject *parent )
  : QObject( parent )
  , mLayerModel( new QgsLayerListModel( QgsProject::instance(), this ) )
{
}

QString QgsModernUiApplication::projectTitle() const
{
  const QString title = QgsProject::instance()->title();
  if ( !title.isEmpty() )
    return title;

  const QString fileName = QgsProject::instance()->fileName();
  if ( !fileName.isEmpty() )
    return QFileInfo( fileName ).baseName();

  return QStringLiteral( "No Project" );
}

QString QgsModernUiApplication::crsDescription() const
{
  const QgsCoordinateReferenceSystem crs = QgsProject::instance()->crs();
  if ( crs.isValid() )
    return crs.userFriendlyIdentifier();
  return QStringLiteral( "No CRS" );
}

bool QgsModernUiApplication::hasProject() const
{
  return !QgsProject::instance()->fileName().isEmpty();
}

bool QgsModernUiApplication::openProject( const QUrl &path )
{
  QString filePath = path.toLocalFile();
  if ( filePath.isEmpty() )
    filePath = path.toString();

  const bool ok = QgsProject::instance()->read( filePath );
  if ( ok )
  {
    mLayerModel->refreshFromProject();
    emit projectLoaded();
  }
  else
  {
    emit projectError( QStringLiteral( "Failed to open project: %1" ).arg( filePath ) );
  }
  return ok;
}

QString QgsModernUiApplication::formatCoordinate( double x, double y ) const
{
  return QStringLiteral( "%1, %2" )
    .arg( x, 0, 'f', 6 )
    .arg( y, 0, 'f', 6 );
}
