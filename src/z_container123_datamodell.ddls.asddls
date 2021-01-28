@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Container123 Daten'
@ObjectModel.resultSet.sizeCategory: #XS
define root view entity Z_CONTAINER123_DATAMODELL

  as select from zcontainer123 as Container
  
  /* Associations */

    association [1..1] to Z_ABFALL123_DATAMODELL as _Abfall on $projection.AbfallID = _Abfall.AbfallID
    
    association [1..1] to Z_Bestellung123_DATAMODELL as _Bestellung on $projection.BestellungID = _Bestellung.BestellungID

{
  key  container_uid as ContainerUID,
       container_id as ContainerID,
       container_gewicht as Gewicht,
       container_verfuegbar as Verfuegbarkeit,
       @Semantics.text: true
       _Abfall.AbfallKategorie as Kategorie,
       @Semantics.text: true
       container_bestellung_id as BestellungID,
       @Semantics.text: true
       container_abfall_id as AbfallID,       
       
       /*-- Admin data --*/
       @Semantics.systemDateTime.createdAt: true
       container_erstelltdatum as Erstellungsdatum,
       @Semantics.systemDateTime.lastChangedAt: true
       container_aktualisiertdatum as Aktualisierungsdatum,
       
        /* Public associations */
      _Abfall,
      _Bestellung

}
