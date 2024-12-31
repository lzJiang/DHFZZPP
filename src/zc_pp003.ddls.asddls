@AbapCatalog.sqlViewName: 'ZV_C_PP003'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '管理生产计划CDS视图'
@Metadata.ignorePropagatedAnnotations: true
define view ZC_PP003
  as select from    I_PlannedOrder           as a
    left outer join I_UnitOfMeasure          as c on a.BaseUnit = c.UnitOfMeasure
    left outer join I_ProductText            as d on a.Material = d.Product
                                                  and d.Language = $session.system_language
    left outer join I_ProductPlantSupplyPlanning      as e on a.Material = e.Product
                                                  and a.ProductionPlant = e.Plant
                                                                                              
{
  key a.PlannedOrder,
      a.ProductionPlant,
      a.Material,
      d.ProductName,
      a.PlannedTotalQtyInBaseUnit as TotalQuantity,
      c.UnitOfMeasure_E as productionunit,
      a.YY1_plannebatch_PLA,
      a.PlndOrderPlannedStartDate,
      a.PlndOrderPlannedEndDate,
      a.MRPController,
      e.MRPGroup,
      a.ProductionVersion,
      a.PlannedOrderIsFirm,
      a.LastChangedByUser,
      a.LastChangeDate,
      cast( '' as abap.char( 1 )) as yy1_flag,
      cast( '' as abap.char( 220 )) as yy1_msg
}
where ( a.ProductionPlant = '1100' or a.ProductionPlant = '4100' )
