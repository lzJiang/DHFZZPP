@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '生产订单'


@UI: {
        headerInfo: { typeName: '生产订单明细', typeNamePlural: '生产订单明细',
                      title: { value: 'ProductionOrder' },
                      description: { value: 'Product' }
                    }
}
define view entity ZC_RPP004_MfgOrder
  as select from I_MfgOrderWithStatus     as a
    join         I_ManufacturingOrderItem as b on a.ManufacturingOrder = b.ManufacturingOrder

{

      @UI.facet: [ { id       : 'ProductionOrder',
                     purpose  : #STANDARD,
                     type     : #IDENTIFICATION_REFERENCE,
                     label    : '基本信息',
                     position : 10
                  } ]


      @Consumption.semanticObject: 'ProductionOrder'
      @UI.lineItem                   : [ { position: 10,  importance: #HIGH } ]
      @UI.identification             : [ { position: 10 } ]
      @EndUserText.label             : '生产订单号'
  key a.ManufacturingOrder as ProductionOrder,
      a.Product,
      a.PlanningPlant      as Plant,
      a.ProductionUnit,
      @UI.lineItem                   : [ { position: 20,  importance: #HIGH } ]
      @UI.identification             : [ { position: 20 } ]
      @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
      @EndUserText.label             : '数量'
      b.MfgOrderItemOpenYieldQty
}

where
  a.OrderIsTechnicallyCompleted = ''
