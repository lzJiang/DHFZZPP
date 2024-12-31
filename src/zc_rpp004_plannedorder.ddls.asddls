@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '计划数量'
@UI: {
        headerInfo: { typeName: '计划订单明细', typeNamePlural: '计划订单明细',
                      title: { value: 'PlannedOrder' },
                      description: { value: 'Product' }
                    }
}
define view entity ZC_RPP004_PlannedOrder
  as select from I_PlannedOrder
{
      @UI.facet: [ { id       : 'ProductionOrder',
                     purpose  : #STANDARD,
                     type     : #IDENTIFICATION_REFERENCE,
                     label    : '基本信息',
                     position : 10
                  } ]


      @Consumption.semanticObject: 'PlannedOrder'
      @UI.lineItem                   : [ { position: 10,  importance: #HIGH } ]
      @UI.identification             : [ { position: 10 } ]
      @EndUserText.label             : '计划订单号'
  key PlannedOrder,
      Product,
      ProductionPlant                          as Plant,
      BaseUnit,
      @UI.lineItem                   : [ { position: 20,  importance: #HIGH } ]
      @UI.identification             : [ { position: 20 } ]
      @EndUserText.label             : '计划订单日期'
      PlndOrderPlannedStartDate,
      @UI.lineItem                   : [ { position: 25,  importance: #HIGH } ]
      @UI.identification             : [ { position: 25 } ]
      @EndUserText.label             : '计划订单期间'
      substring(PlndOrderPlannedStartDate,1,6) as yearmonth,
      @UI.lineItem                   : [ { position: 30,  importance: #HIGH } ]
      @UI.identification             : [ { position: 30 } ]
      @EndUserText.label             : '数量'
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      PlannedTotalQtyInBaseUnit
}
