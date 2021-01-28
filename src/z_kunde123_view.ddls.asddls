@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection view für KUNDE123'

@ObjectModel.semanticKey: ['KundeID']
define root view entity Z_KUNDE123_VIEW
  as projection on Z_KUNDE123_DATAMODELL as KUNDE
{
    key KundeUID,
      @Search.defaultSearchElement: true
    KundeID,
    Vorname,
    Nachname,
    Strasse,
    Hausnummer,
    Stadt,
    PLZ,
    Firma,
    Ansprechpartner,
    Erstellungsdatum,
    Aktualisierungsdatum,
    /* Associations */
    _Bestellung : redirected to composition child Z_BESTELLUNG123_VIEW
}
