@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_ZT_PP_003
  provider contract transactional_query
  as projection on ZR_ZT_PP_003
{
  key Storagelocation,
  Zcj,
  Zcjtext,
  CreatedAt,
  LastChangedBy,
  LastChangedAt
  
}
