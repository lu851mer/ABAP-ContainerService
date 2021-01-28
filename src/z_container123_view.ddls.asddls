@EndUserText.label: 'Projection View Container123'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.resultSet.sizeCategory: #XS

@ObjectModel.semanticKey: ['ContainerID']

@UI: {
 headerInfo: { typeName: 'Container', typeNamePlural: 'Container', title: { type: #STANDARD, value: 'ContainerID' } } }

@Search.searchable: true

define root view entity Z_CONTAINER123_VIEW
  as projection on Z_CONTAINER123_DATAMODELL as Container
{
    key ContainerUID,
    Kategorie,
    @Search.defaultSearchElement: true
    @Consumption.valueHelpDefinition: [{ entity : {name: 'Z_ABFALL123_DATAMODELL', element: 'AbfallID'  } }]
    @EndUserText.label: 'Abfall auswählen'
    AbfallID,
    @Search.defaultSearchElement: true
    ContainerID,
    @Consumption.valueHelpDefinition: [{ entity : {name: 'Z_BESTELLUNG123_DATAMODELL', element: 'BestellungID'  } }]
    @Search.defaultSearchElement: true
    @EndUserText.label: 'Bestellung auswählen'
    BestellungID,
    Verfuegbarkeit,
    Gewicht,
    Erstellungsdatum,
    Aktualisierungsdatum,
    
    /* Associations */
    _Abfall,
    _Bestellung
    
}
