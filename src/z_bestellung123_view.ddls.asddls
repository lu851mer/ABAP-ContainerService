@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection view für Bestellung110'
@ObjectModel.resultSet.sizeCategory: #XS

@ObjectModel.semanticKey: ['BestellungID']

@UI: {
 headerInfo: { typeName: 'Bestellung', typeNamePlural: 'Bestellungen', title: { type: #STANDARD, value: 'BestellungID' } } }
define view entity Z_BESTELLUNG123_VIEW
  as projection on Z_Bestellung123_DATAMODELL as Bestellung
{
  key BestellungUID,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'Z_KUNDE123_DATAMODELL', element: 'KundeID'} }]
      @ObjectModel.text.element: ['KundeID']
      @Search.defaultSearchElement: true
      KundeUID,
      _Kunde.KundeID as KundeID,
      _Kunde.Vorname as KundeVorname,
      _Kunde.Nachname as KundeNachname,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      BestellungID,
      Lieferungsdatum,
      Abholungsdatum,
      Kommentar,
      Status,
      Erstellungsdatum,
      Aktualisierungsdatum,
      /* Associations */

      _Kunde : redirected to parent Z_KUNDE123_VIEW
      
}
