@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bestellung110 Daten'
@Search.searchable: true
@ObjectModel.resultSet.sizeCategory: #XS

@ObjectModel.semanticKey: ['BestellungID']
define view entity Z_Bestellung123_DATAMODELL

  as select from zbestellung123 as Bestellung
  
  /* Associations */

 association to parent Z_KUNDE123_DATAMODELL as _Kunde on $projection.KundeUID = _Kunde.KundeUID

{
  key  bestellung_uid as BestellungUID,
       bestellung_id as BestellungID,
       bestellung_kunde_uid as KundeUID,
       bestellung_lieferungsdatum as Lieferungsdatum,
       bestellung_abholungsdatum as Abholungsdatum,
       bestellung_kommentar as Kommentar,
       bestellung_status as Status,
       
       /*-- Admin data --*/
       @Semantics.systemDateTime.createdAt: true
       bestellung_erstelltdatum as Erstellungsdatum,
       @Semantics.systemDateTime.lastChangedAt: true
       bestellung_aktualisiertdatum as Aktualisierungsdatum,
       
        /* Public associations */
        _Kunde
}
