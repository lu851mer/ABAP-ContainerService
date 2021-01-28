@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Kunde110 Daten'
define root view entity Z_KUNDE123_DATAMODELL

  as select from zkunde123 as Kunde
  
  /* Associations */
  composition [0..*] of Z_Bestellung123_DATAMODELL as _Bestellung

{
  key  kunde_uid as KundeUID,
       kunde_id as KundeID,
       kunde_vorname as Vorname,
       kunde_nachname as Nachname,
       kunde_strasse as Strasse,
       kunde_hausnr as Hausnummer,
       kunde_stadt as Stadt,
       kunde_plz as PLZ,
       kunde_firma as Firma,
       kunde_ansprechpartner as Ansprechpartner,
       
       /*-- Admin data --*/
       @Semantics.systemDateTime.createdAt: true
       kunde_erstelltdatum as Erstellungsdatum,
       @Semantics.systemDateTime.lastChangedAt: true
       kunde_aktualisiertdatum as Aktualisierungsdatum,
       
       /* Public Associations */
      _Bestellung
}
