@AbapCatalog.sqlViewName: 'ZV_C_PP002'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '管理生产任务单CDS视图'
@Metadata.ignorePropagatedAnnotations: true
define view ZC_PP002
  as select from    I_ManufacturingOrder     as a
    inner join      I_Plant                  as b on a.ProductionPlant = b.Plant
    inner join      I_ManufacturingOrderItem as c on c.ManufacturingOrder = a.ManufacturingOrder
    inner join      I_MfgOrderTypeText       as d on  a.ManufacturingOrderType = d.ManufacturingOrderType
                                                  and d.Language               = $session.system_language
    inner join      I_MfgOrderWithStatus     as e on a.ManufacturingOrder = e.ManufacturingOrder
    inner join      I_UnitOfMeasure          as i on c.ProductionUnit = i.UnitOfMeasure
    left outer join zzt_pp_001               as f on a.ManufacturingOrder = f.manufacturingorder
    left outer join I_Product                as l on c.Material = l.Product
    left outer join I_ProductText            as g on  c.Material = g.Product
                                                  and g.Language = $session.system_language
    left outer join I_ProductStorage_2       as h on c.Material = h.Product
    left outer join I_BusinessUserVH         as k on a.LastChangedByUser = k.UserID
{
  key a.ManufacturingOrder,
      a.ProductionPlant,
      b.PlantName,
      a.ManufacturingOrderType,
      d.ManufacturingOrderTypeName,
      e.OrderIsCreated,
      e.OrderIsReleased,
      e.OrderIsDelivered,
      e.OrderIsTechnicallyCompleted,
      c.Material,
      g.ProductName,
      l.SizeOrDimensionText,
      c.MfgOrderPlannedTotalQty,
      i.UnitOfMeasure_E  as ProductionUnit,
      a.MfgOrderPlannedStartDate,
      a.MfgOrderPlannedEndDate,
      a.MfgOrderActualReleaseDate,
      k.PersonFullName   as LastChangedByUser,
      a.MfgOrderCreationDate,
      a.MfgOrderCreationTime,
      a.YY1_plannebatch_ORD,
      a.YY1_mfgbatch_ORD as yy1_mfgbatch_ord,
      f.yy1_mfgdate,
      f.yy1_expdate,
      f.yy1_approve,
      f.yy1_approvetime,
      f.yy1_check,
      f.yy1_checktime,
      f.yy1_sendbpm,
      f.yy1_sendwms,
      f.yy1_flag,
      f.yy1_msg,
      f.yy1_approvestatus,
      f.yy1_bpm_task_id,
      f.yy1_related_num,
      h.ShelfLifeExpirationDatePeriod,
      h.TotalShelfLife
}
where
       a.ManufacturingOrderCategory = '10'
  and(
       a.ProductionPlant            = '1100'
    or a.ProductionPlant            = '4100'
  )
