@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@ObjectModel.resultSet.sizeCategory: #XS
@EndUserText.label: 'Abfall110 Daten'

@ObjectModel.semanticKey: ['AbfallID']
define root view entity Z_ABFALL123_DATAMODELL

as select from zabfall123 as Abfall

{
    key abfall_uid as AbfallUID,
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
    abfall_id as AbfallID,
    abfall_waehrung as AbfallWaehrung,
    @Semantics.amount.currencyCode : 'AbfallWaehrung'
    abfall_preis as AbfallPreis,
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
    abfall_kategorie as AbfallKategorie,
    
    /*-- Admin data --*/
       @Semantics.systemDateTime.createdAt: true
       abfall_erstelltdatum as AbfallErstelltdatum,
       @Semantics.systemDateTime.lastChangedAt: true
       abfall_aktualisiertdatum as AbfallAktualisiertdatum
}
