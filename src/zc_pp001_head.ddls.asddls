@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '生产订单抬头'
define view entity ZC_PP001_HEAD
  as select from    I_MfgOrderWithStatus as a
    left outer join I_Product            as b on a.Material = b.Product
    left outer join I_ProductText        as c on  c.Product  = a.Material
                                              and c.Language = $session.system_language
    left outer join I_MfgOrderTypeText   as d on  a.ManufacturingOrderType = d.ManufacturingOrderType
                                              and d.Language               = $session.system_language

{
  key a.ManufacturingOrder,
      a.ProductionPlant,
      a.Material,
      c.ProductName,
      a.ManufacturingOrderType,
      d.ManufacturingOrderTypeName,
      a.MfgOrderActualReleaseDate,
      a.MfgOrderPlannedStartDate,
      a.MfgOrderPlannedEndDate,
      a.ProductionUnit,
      @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
      a.MfgOrderPlannedTotalQty,
      a.YY1_plannebatch_ORD,


      case a.LastChangeDate when '00000000'
      then cast (dats_tims_to_tstmp( a.CreationDate,a.CreationTime,'UTC',$session.client,'NULL' )  as timestampl )
      else cast (dats_tims_to_tstmp( a.LastChangeDate,a.LastChangeTime,'UTC',$session.client,'NULL' ) as timestampl )
      end as LastChangeDateTime
}
