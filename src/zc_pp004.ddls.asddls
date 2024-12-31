@AbapCatalog.sqlViewName: 'ZV_C_PP004'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '生产通知单打印CDS视图'
@Metadata.ignorePropagatedAnnotations: true
define view ZC_PP004
  as select from    I_ManufacturingOrder     as a
    inner join      I_ManufacturingOrderItem as b on a.ManufacturingOrder = b.ManufacturingOrder
    inner join      I_Product                as cp on b.Material = cp.Product
    left outer join I_ProductText            as cpt on  b.Material = cpt.Product
                                                  and cpt.Language = $session.system_language
    inner join      I_UnitOfMeasure          as cpu on b.ProductionUnit = cpu.UnitOfMeasure                                               
    inner join      I_MfgOrderOperationComponent as c on a.ManufacturingOrder = c.ManufacturingOrder
    inner join      I_Product                as zj on c.Material = zj.Product
    left outer join I_ProductText            as zjt on  c.Material = zjt.Product
                                                  and zjt.Language = $session.system_language
    inner join      I_UnitOfMeasure          as zju on c.EntryUnit = zju.UnitOfMeasure      
    left outer join I_BusinessUserVH         as e on a.LastChangedByUser = e.UserID
    left outer join zzt_pp_001               as f on a.ManufacturingOrder = f.manufacturingorder
    inner join      I_MfgOrderWithStatus     as g on a.ManufacturingOrder = g.ManufacturingOrder
{
  key a.ManufacturingOrder,
  key c.Reservation,
  key c.ReservationItem,
      cpt.ProductName as cpName,
      g.OrderIsReleased,
      a.YY1_mfgbatch_ORD,
      a.MfgOrderCreationDate,
      a.MfgOrderPlannedStartDate,
      cp.SizeOrDimensionText,
      a.MfgOrderPlannedEndDate,
      b.MfgOrderPlannedTotalQty as cpQty,
      cpu.UnitOfMeasure_E as CpUnit,
      c.Material,
      zj.ProductGroup as zjGroup,   
      zjt.ProductName as zjName,
      c.GoodsMovementEntryQty as zjQty,
      zju.UnitOfMeasure_E as zjUnit,
      e.PersonFullName as zdr,
      f.yy1_approve as pzr,
      f.yy1_check as shr     
}
where
  a.ManufacturingOrderCategory = '10'
  and ( a.ProductionPlant = '1100' or a.ProductionPlant = '4100' )
