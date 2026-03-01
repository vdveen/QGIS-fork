/***************************************************************************
  qgslayerlistmodel.h — A QML-friendly model of project map layers
 ***************************************************************************/

#ifndef QGSLAYERLISTMODEL_H
#define QGSLAYERLISTMODEL_H

#include <QAbstractListModel>
#include "qgsproject.h"
#include "qgsmaplayer.h"

/**
 * \brief Exposes the project's map layers to QML as a list model.
 *
 * Roles provided:
 *  - name       : Layer display name
 *  - layerId    : Unique layer ID
 *  - layerType  : "vector", "raster", "mesh", etc.
 *  - isVisible  : Whether the layer is visible
 *  - iconName   : Icon hint for the layer type
 */
class QgsLayerListModel : public QAbstractListModel
{
    Q_OBJECT

  public:
    enum Role
    {
      NameRole = Qt::UserRole + 1,
      LayerIdRole,
      LayerTypeRole,
      IsVisibleRole,
      IconNameRole,
    };

    explicit QgsLayerListModel( QgsProject *project, QObject *parent = nullptr );

    int rowCount( const QModelIndex &parent = QModelIndex() ) const override;
    QVariant data( const QModelIndex &index, int role = Qt::DisplayRole ) const override;
    QHash<int, QByteArray> roleNames() const override;

    /**
     * Toggle visibility of the layer at the given row index.
     */
    Q_INVOKABLE void toggleVisibility( int row );

    /**
     * Reload the layer list from the current project.
     */
    void refreshFromProject();

  private:
    static QString layerTypeString( Qgis::LayerType type );
    static QString layerIconName( Qgis::LayerType type );

    QgsProject *mProject = nullptr;
    QList<QgsMapLayer *> mLayers;
};

#endif // QGSLAYERLISTMODEL_H
