@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection view für Abfall123'

@ObjectModel.semanticKey: ['AbfallID']

@UI: {
 headerInfo: { typeName: 'Abfall', typeNamePlural: 'Abfälle', title: { type: #STANDARD, value: 'AbfallID' } } }
define root view entity Z_ABFALL123_VIEW
  as projection on Z_ABFALL123_DATAMODELL as Abfall
{
  key AbfallUID,
    AbfallID,
    AbfallWaehrung,
    AbfallPreis,
    AbfallKategorie,
    AbfallErstelltdatum,
    AbfallAktualisiertdatum
}
