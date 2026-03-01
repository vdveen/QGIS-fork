/***************************************************************************
  qgslayerlistmodel.cpp
 ***************************************************************************/

#include "qgslayerlistmodel.h"

QgsLayerListModel::QgsLayerListModel( QgsProject *project, QObject *parent )
  : QAbstractListModel( parent )
  , mProject( project )
{
  connect( mProject, &QgsProject::layersAdded, this, [this]() { refreshFromProject(); } );
  connect( mProject, &QgsProject::layersRemoved, this, [this]() { refreshFromProject(); } );
}

int QgsLayerListModel::rowCount( const QModelIndex &parent ) const
{
  if ( parent.isValid() )
    return 0;
  return static_cast<int>( mLayers.size() );
}

QVariant QgsLayerListModel::data( const QModelIndex &index, int role ) const
{
  if ( !index.isValid() || index.row() < 0 || index.row() >= mLayers.size() )
    return QVariant();

  QgsMapLayer *layer = mLayers.at( index.row() );
  if ( !layer )
    return QVariant();

  switch ( role )
  {
    case NameRole:
      return layer->name();
    case LayerIdRole:
      return layer->id();
    case LayerTypeRole:
      return layerTypeString( layer->type() );
    case IsVisibleRole:
    {
      QgsLayerTreeLayer *treeLayer = mProject->layerTreeRoot()->findLayer( layer->id() );
      return treeLayer ? treeLayer->isVisible() : true;
    }
    case IconNameRole:
      return layerIconName( layer->type() );
    default:
      return QVariant();
  }
}

QHash<int, QByteArray> QgsLayerListModel::roleNames() const
{
  return {
    { NameRole, "name" },
    { LayerIdRole, "layerId" },
    { LayerTypeRole, "layerType" },
    { IsVisibleRole, "isVisible" },
    { IconNameRole, "iconName" },
  };
}

void QgsLayerListModel::toggleVisibility( int row )
{
  if ( row < 0 || row >= mLayers.size() )
    return;

  QgsMapLayer *layer = mLayers.at( row );
  QgsLayerTreeLayer *treeLayer = mProject->layerTreeRoot()->findLayer( layer->id() );
  if ( treeLayer )
  {
    treeLayer->setItemVisibilityChecked( !treeLayer->isVisible() );
    emit dataChanged( index( row ), index( row ), { IsVisibleRole } );
  }
}

void QgsLayerListModel::refreshFromProject()
{
  beginResetModel();
  mLayers = mProject->mapLayers().values();
  endResetModel();
}

QString QgsLayerListModel::layerTypeString( Qgis::LayerType type )
{
  switch ( type )
  {
    case Qgis::LayerType::Vector:
      return QStringLiteral( "vector" );
    case Qgis::LayerType::Raster:
      return QStringLiteral( "raster" );
    case Qgis::LayerType::Mesh:
      return QStringLiteral( "mesh" );
    case Qgis::LayerType::PointCloud:
      return QStringLiteral( "pointcloud" );
    case Qgis::LayerType::VectorTile:
      return QStringLiteral( "vectortile" );
    default:
      return QStringLiteral( "unknown" );
  }
}

QString QgsLayerListModel::layerIconName( Qgis::LayerType type )
{
  switch ( type )
  {
    case Qgis::LayerType::Vector:
      return QStringLiteral( "layers" );
    case Qgis::LayerType::Raster:
      return QStringLiteral( "image" );
    case Qgis::LayerType::Mesh:
      return QStringLiteral( "grid" );
    case Qgis::LayerType::PointCloud:
      return QStringLiteral( "scatter" );
    default:
      return QStringLiteral( "layers" );
  }
}
