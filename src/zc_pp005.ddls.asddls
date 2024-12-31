@AbapCatalog.sqlViewName: 'ZV_C_PP005'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '生产领料查询CDS视图'
@Metadata.ignorePropagatedAnnotations: true
define view ZC_PP005
  as select from    I_ManufacturingOrder         as a
    inner join      I_ManufacturingOrderItem     as b       on a.ManufacturingOrder = b.ManufacturingOrder
    inner join      I_Product                    as cp      on b.Material = cp.Product
    left outer join I_ProductText                as cpt     on  b.Material   = cpt.Product
                                                            and cpt.Language = $session.system_language
    inner join      I_UnitOfMeasure              as cpu     on b.ProductionUnit = cpu.UnitOfMeasure
    inner join      I_MfgOrderOperationComponent as c       on a.ManufacturingOrder = c.ManufacturingOrder
    inner join      I_BillOfMaterialHeaderDEX_2  as bomhead on  a.BillOfMaterialCategory     = bomhead.BillOfMaterialCategory
                                                            and a.BillOfMaterial             = bomhead.BillOfMaterial
                                                            and a.BillOfMaterialVariantUsage = bomhead.BillOfMaterialVariantUsage
                                                            and a.BillOfMaterialVariant      = bomhead.BillOfMaterialVariant
    inner join      I_Product                    as zj      on c.Material = zj.Product
    left outer join I_ProductText                as zjt     on  c.Material   = zjt.Product
                                                            and zjt.Language = $session.system_language
    inner join      I_UnitOfMeasure              as zju     on c.EntryUnit = zju.UnitOfMeasure
    left outer join I_BusinessUserVH             as e       on a.LastChangedByUser = e.UserID
    left outer join zzt_pp_003                   as f       on c.StorageLocation = f.storagelocation
    inner join      I_MfgOrderWithStatus         as g       on a.ManufacturingOrder = g.ManufacturingOrder
    left outer join I_MfgOrderTypeText           as h       on  a.ManufacturingOrderType = h.ManufacturingOrderType
                                                            and h.Language               = $session.system_language
    left outer join I_ProductGroupText_2         as i       on  zj.ProductGroup = i.ProductGroup
                                                            and i.Language      = $session.system_language
    left outer join I_StorageLocationStdVH       as j       on  c.StorageLocation = j.StorageLocation
                                                            and a.ProductionPlant = j.Plant
    left outer join I_MfgOrderComponentLongText  as k       on  c.Reservation    = k.Reservation
                                                            and c.ReservationItem = k.ReservationItem
                                                            and c.RecordType = ''
                                                            and k.LongTextLanguage = $session.system_language

{
  key a.ManufacturingOrder,
  key c.Reservation,
  key c.ReservationItem,
      a.ProductionPlant,
      a.ManufacturingOrderType,
      h.ManufacturingOrderTypeName,
      a.YY1_mfgbatch_ORD,
      b.Material                          as cp,
      cpt.ProductName                     as cpName,
      g.OrderIsReleased,
      a.MfgOrderActualReleaseDate,
      b.MfgOrderPlannedTotalQty           as cpQty,
      cpu.UnitOfMeasure_E                 as cpUnit,
      c.Material                          as zj,
      zj.ProductType                      as zjType,
      zj.ProductGroup                     as zjGroup,
      zjt.ProductName                     as zjName,
      i.ProductGroupName                  as zjGroupName,
      c.GoodsMovementEntryQty             as zjQty,
      c.GoodsMovementEntryQty             as requestedQty,
      zju.UnitOfMeasure                   as requestedQtyUnit,
      zju.UnitOfMeasure_E                 as zjUnit,
      c.StorageLocation,
      j.StorageLocationName,
      f.zcj,
      f.zcjtext,
      bomhead.BOMHeaderQuantityInBaseUnit as zjbsl,
//      c.BOMItemDescription                as zcy,
      k.OrderComponentLongText            as zcy,
      c.MaterialComponentSortText         as zasflag,
      c.UnloadingPointName                as zhlbz,
      cast( '' as abap.char( 1 ))         as yy1_flag,
      cast( '' as abap.char( 220 ))       as yy1_msg,
      cast( 0 as abap.quan( 13,3 ))       as zyslsl
}
where
       a.ManufacturingOrderCategory = '10'
  and  g.OrderIsReleased            = 'X'
  and(
       a.ProductionPlant            = '1100'
    or a.ProductionPlant            = '4100'
  )
