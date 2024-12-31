@AbapCatalog.sqlViewName: 'ZV_C_PP006'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '委外调拨查询CDS视图'
@Metadata.ignorePropagatedAnnotations: true
define view ZC_PP006
  as select from    I_PurchaseOrderAPI01        as a
    inner join      I_PurchaseOrderItemAPI01    as b   on a.PurchaseOrder = b.PurchaseOrder
    inner join      I_Product                   as cp  on b.Material = cp.Product
    left outer join I_ProductText               as cpt on  b.Material   = cpt.Product
                                                       and cpt.Language = $session.system_language
    inner join      I_UnitOfMeasure             as cpu on b.PurchaseOrderQuantityUnit = cpu.UnitOfMeasure
    inner join      I_POSubcontractingCompAPI01 as c   on  b.PurchaseOrder     = c.PurchaseOrder
                                                       and b.PurchaseOrderItem = c.PurchaseOrderItem
    inner join      I_Product                   as zj  on c.Material = zj.Product
    left outer join I_ProductText               as zjt on  c.Material   = zjt.Product
                                                       and zjt.Language = $session.system_language
    inner join      I_UnitOfMeasure             as zju on c.EntryUnit = zju.UnitOfMeasure
    left outer join I_Supplier_VH               as sup on a.Supplier = sup.Supplier
    left outer join I_ProductGroupText_2        as i   on  zj.ProductGroup = i.ProductGroup
                                                       and i.Language      = $session.system_language

{
  key b.PurchaseOrder,
  key b.PurchaseOrderItem,
  key c.Reservation,
  key c.ReservationItem,
      b.Plant                       as productionplant,
      b.Material                    as cp,
      cpt.ProductName               as cpName,
      a.PurchaseOrderDate,
      b.OrderQuantity               as cpQty,
      cpu.UnitOfMeasure_E           as cpUnit,
      c.Material                    as zj,
      zj.ProductGroup               as zjGroup,
      zjt.ProductName               as zjName,
      i.ProductGroupName            as zjGroupName,
      c.QuantityInEntryUnit         as zjQty,
      c.QuantityInEntryUnit         as requestedQty,
      c.EntryUnit                   as requestedqtyunit,
      zju.UnitOfMeasure_E           as zjUnit,
      a.Supplier                    as Subcontractor,
      sup.SupplierName              as Subcontractorname,
      cast( '' as abap.char( 1 ))   as yy1_flag,
      cast( '' as abap.char( 220 )) as yy1_msg
}
