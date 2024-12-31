@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '销售计划'
define view entity ZC_RPP004_ActivePlnd
  as select from I_ActivePlndIndepRqmt     as a
    join         I_ActivePlndIndepRqmtItem as b on a.PlndIndepRqmtInternalID = b.PlndIndepRqmtInternalID
{
  a.PlndIndepRqmtInternalID,
  a.Plant,
  a.Product,
  b.WorkingDayDate,
  b.PlannedQuantity,
  b.BaseUnit,
  substring(b.WorkingDayDate,1,6) as yearmonth
}
