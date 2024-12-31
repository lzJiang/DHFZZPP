@EndUserText.label: '生产计划表'
@ObjectModel.query.implementedBy: 'ABAP:ZZCL_PP004'
@UI: {
        headerInfo: { typeName: '生产计划表', typeNamePlural: '生产计划表',
                      title: { value: 'Plant' },
                      description: { value: 'Product' }
                    }
}
@Search.searchable: true
define custom entity ZC_RPP004
{

      @UI.facet                      : [ { id            :'Basis',
                                           purpose       :#STANDARD,
                                           type          :#IDENTIFICATION_REFERENCE,
                                           label         :'基本信息',
                                           position      : 10 },
                                         {
                                            id:              'SalesPln',
                                            targetQualifier: 'SalesPln_FG',
                                            purpose:         #STANDARD,
                                            type:            #FIELDGROUP_REFERENCE,
                                            label:           '销售计划',
                                            position:        20 },
                                         {
                                            id:              'OrderPln',
                                            targetQualifier: 'OrderPln_FG',
                                            purpose:         #STANDARD,
                                            type:            #FIELDGROUP_REFERENCE,
                                            label:           '生产计划',
                                            position:        30 },

                                         { id:        'MfgOrder',
                                           purpose:    #STANDARD,
                                           type:       #LINEITEM_REFERENCE,
                                           targetElement: '_MfgOrder',
                                           position:        100 ,
                                           label:        '在产品数'},
                                         { id:        'PlnnedOrder',
                                           purpose:    #STANDARD,
                                           type:       #LINEITEM_REFERENCE,
                                           targetElement: '_PlnnedOrder',
                                           position:        110 ,
                                           label:        '计划订单'}                                                                         ]


      @UI.lineItem                   : [ { position: 10,  importance: #HIGH } ]
      @UI.identification             : [ { position: 10 } ]
      @UI.selectionField             : [ { position: 10 } ]
      @Consumption.filter            : { mandatory:true,
                                         selectionType: #RANGE }
      @Consumption.valueHelpDefinition:[ { entity: { name: 'I_PLANT', element: 'Plant' } } ]
      @Search.defaultSearchElement   : true
      @EndUserText.label             : '工厂'
  key Plant                          : werks_d;
      @UI.lineItem                   : [ { position: 20,  importance: #HIGH } ]
      @UI.identification             : [ { position: 20 } ]
      @UI.selectionField             : [ { position: 20 } ]
      @Consumption.valueHelpDefinition:[ { entity: { name: 'I_ProductStdVH', element: 'Product' } } ]
      @ObjectModel.text.element      : [ 'ProductName' ]
      @EndUserText.label             : '物料'
  key Product                        : matnr;
      @UI.selectionField             : [ { position: 60 }]
      @Search.defaultSearchElement   : true
      @EndUserText.label             : '会计年度'
      @Consumption.filter            : { selectionType: #SINGLE , mandatory:true }
      @Consumption.valueHelpDefinition:[ { entity: { name: 'I_CalendarYear', element: 'CalendarYear' } } ]
  key FiscalYear                     : gjahr;
      @UI.selectionField             : [ { position: 70 }]
      @EndUserText.label             : '期间'
      @Consumption.valueHelpDefinition:[ { entity: { name: 'I_CalendarMonthVH', element: 'CalendarMonth' } } ]
      @Consumption.filter            : { mandatory:true ,selectionType: #SINGLE }
  key FiscalPeriod                   : abap.numc( 2 );

      @UI.lineItem                   : [ { position: 30 } ]
      @UI.identification             : [ { position: 30 } ]
      @UI.selectionField             : [ { position: 30 } ]
      @EndUserText.label             : '产品事业部'
      ExternalProductGroup           : abap.char( 20 );
      @UI.lineItem                   : [ { position: 30 } ]
      @UI.identification             : [ { position: 30 } ]
      @ObjectModel.text.element      : [ 'MRPControllerName' ]
      @EndUserText.label             : 'MRP控制者'
      MRPResponsible                 : dispo;
      @UI.hidden                     : true
      MRPControllerName              : abap.char( 20 );
      @UI.lineItem                   : [ { position: 40 } ]
      @UI.identification             : [ { position: 40 } ]
      @EndUserText.label             : 'MRP类型'
      MRPType                        : dismm;
      @UI.lineItem                   : [ { position: 50 } ]
      @UI.identification             : [ { position: 50 } ]
      @EndUserText.label             : '规格'
      SizeOrDimensionText            : abap.char( 20 );
      @UI.lineItem                   : [ { position: 60 } ]
      @UI.identification             : [ { position: 60 } ]
      @EndUserText.label             : '基本单位'
      BaseUnit                       : meins;
      @UI.selectionField             : [ { position: 40 } ]
      ProductName                    : maktx;
      @UI.lineItem                   : [ { position: 65 } ]
      @UI.identification             : [ { position: 65 } ]
      @UI.selectionField             : [ { position: 50 } ]
      @EndUserText.label             : '上次MRP运行时间'
      MaterialLastMRPDateTime        : tzntstmps;

      @UI.lineItem                   : [ { position: 70 } ]
      @UI.identification             : [ { position: 70 } ]
      @EndUserText.label             : '最小批量'
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      MinimumLotSizeQuantity         : menge_d;
      @UI.lineItem                   : [ { position: 80 } ]
      @UI.identification             : [ { position: 80 } ]
      @EndUserText.label             : '最大批量'
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      MaximumLotSizeQuantity         : menge_d;
      @UI.lineItem                   : [ { position: 90 } ]
      @UI.identification             : [ { position: 90 } ]
      @EndUserText.label             : '固定批量'
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      FixedLotSizeQuantity           : menge_d;
      @UI.lineItem                   : [ { position: 100 } ]
      @UI.identification             : [ { position: 100 } ]
      @EndUserText.label             : '生产周期'
      ProdInhProdnDurationInWorkDays : abap.dec(3);
      @UI.lineItem                   : [ { position: 110 } ]
      @UI.identification             : [ { position: 110 } ]
      @EndUserText.label             : '生产批量'
      BOMHeaderQuantityInBaseUnit    : abap.dec(13,3);
      @UI.lineItem                   : [ { position: 120 } ]
      @UI.identification             : [ { position: 120 } ]
      @EndUserText.label             : '非限制库存'
      zzfxz                          : abap.dec(13,3);
      @UI.lineItem                   : [ { position: 130 } ]
      @UI.identification             : [ { position: 130 } ]
      @EndUserText.label             : '待检数量'
      zzdj                           : abap.dec(13,3);
      @UI.lineItem                   : [ { position: 140 } ]
      @UI.identification             : [ { position: 140 } ]
      @EndUserText.label             : '预计月末库存'
      zzyjymkc                       : abap.dec(13,3);
      @UI.lineItem                   : [ { position: 150 } ]
      @UI.identification             : [ { position: 150 } ]
      @EndUserText.label             : '本月销量'
      zzbyxl                         : abap.dec(13,3);
      @UI.lineItem                   : [ { position: 160 } ]
      @UI.identification             : [ { position: 160 } ]
      @EndUserText.label             : '退货量'
      zzth                           : abap.dec(13,3);
      @UI.lineItem                   : [ { position: 165 } ]
      @UI.identification             : [ { position: 165 } ]
      @EndUserText.label             : '在产品数'
      zzzp                           : abap.dec(13,3);
      @UI.lineItem                   : [ { position: 170 } ]
      @UI.fieldGroup                 : [ { position: 170,qualifier: 'SalesPln_FG' } ]
      @EndUserText.label             : '(本月)销售计划'
      PlannedQuantity                : abap.dec(13,3);
      @UI.lineItem                   : [ { position: 180 } ]
      @UI.fieldGroup                 : [ { position: 180,qualifier: 'SalesPln_FG' } ]
      @EndUserText.label             : '(本月+1)销售计划'
      PlannedQuantity1               : abap.dec(13,3);
      @UI.lineItem                   : [ { position: 190 } ]
      @UI.fieldGroup                 : [ { position: 190,qualifier: 'SalesPln_FG' } ]
      @EndUserText.label             : '(本月+2)销售计划'
      PlannedQuantity2               : abap.dec(13,3);
      @UI.lineItem                   : [ { position: 200 } ]
      @UI.fieldGroup                 : [ { position: 200,qualifier: 'SalesPln_FG' } ]
      @EndUserText.label             : '(本月+3)销售计划'
      PlannedQuantity3               : abap.dec(13,3);
      @UI.lineItem                   : [ { position: 210 } ]
      @UI.fieldGroup                 : [ { position: 210,qualifier: 'SalesPln_FG' } ]
      @EndUserText.label             : '(本月+4)销售计划'
      PlannedQuantity4               : abap.dec(13,3);
      @UI.lineItem                   : [ { position: 220 } ]
      @UI.fieldGroup                 : [ { position: 220,qualifier: 'SalesPln_FG' } ]
      @EndUserText.label             : '(本月+5)销售计划'
      PlannedQuantity5               : abap.dec(13,3);
      @UI.lineItem                   : [ { position: 230 } ]
      @UI.identification             : [ { position: 230 } ]
      @EndUserText.label             : '安全库存'
      SafetyStockQuantity            : abap.dec(13,3);
      @UI.lineItem                   : [ { position: 240 } ]
      @UI.fieldGroup                 : [ { position: 240,qualifier: 'OrderPln_FG' }  ]
      @EndUserText.label             : '(本月)计划数量'
      PlannedTotalQty                : abap.dec(13,3);
      @UI.lineItem                   : [ { position: 250 } ]
      @UI.fieldGroup                 : [ { position: 250,qualifier: 'OrderPln_FG' } ]
      @EndUserText.label             : '(本月+1)计划数量'
      PlannedTotalQty1               : abap.dec(13,3);
      @UI.lineItem                   : [ { position: 260 } ]
      @UI.fieldGroup                 : [ { position: 260,qualifier: 'OrderPln_FG' } ]
      @EndUserText.label             : '(本月+2)计划数量'
      PlannedTotalQty2               : abap.dec(13,3);
      @UI.lineItem                   : [ { position: 270 } ]
      @UI.fieldGroup                 : [ { position: 270,qualifier: 'OrderPln_FG' } ]
      @EndUserText.label             : '(本月+3)计划数量'
      PlannedTotalQty3               : abap.dec(13,3);
      @UI.lineItem                   : [ { position: 280 } ]
      @UI.fieldGroup                 : [ { position: 280,qualifier: 'OrderPln_FG' } ]
      @EndUserText.label             : '(本月+4)计划数量'
      PlannedTotalQty4               : abap.dec(13,3);
      @UI.lineItem                   : [ { position: 290 } ]
      @UI.fieldGroup                 : [ { position: 290,qualifier: 'OrderPln_FG' } ]
      @EndUserText.label             : '(本月+5)计划数量'
      PlannedTotalQty5               : abap.dec(13,3);
      @UI.lineItem                   : [ { position: 300 } ]
      @UI.identification             : [ { position: 300 } ]
      @EndUserText.label             : '缺口数量'
      zzqk                           : abap.dec(13,3);
      @UI.lineItem                   : [ { position: 310 } ]
      @UI.identification             : [ { position: 310 } ]
      @EndUserText.label             : '前三个月平均出库数量'
      zzpjch                         : abap.dec(13,3);
      @UI.lineItem                   : [ { position: 320 } ]
      @UI.identification             : [ { position: 320 } ]
      @EndUserText.label             : '本月出库数量'
      zzbych                         : abap.dec(13,3);
      @UI.lineItem                   : [ { position: 330 } ]
      @UI.identification             : [ { position: 330 } ]
      @EndUserText.label             : '完成比'
      finishingrate                  : abap.char(10);

      @ObjectModel.filter.enabled    : false
      _MfgOrder                      : association [0..*] to ZC_RPP004_MfgOrder on  _MfgOrder.Plant   = $projection.Plant
                                                                                and _MfgOrder.Product = $projection.Product;

      @ObjectModel.filter.enabled    : false
      _PlnnedOrder                   : association [0..*] to ZC_RPP004_PlannedOrder on  _PlnnedOrder.Plant   = $projection.Plant
                                                                                    and _PlnnedOrder.Product = $projection.Product;

}
