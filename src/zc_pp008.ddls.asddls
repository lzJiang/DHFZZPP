@AbapCatalog.sqlViewName: 'ZV_C_PP008'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '领料单保存CDS视图'
@Metadata.ignorePropagatedAnnotations: true
define view ZC_PP008
  as select from zzt_pp_002_head as a
    inner join   zzt_pp_002_itemd as b on a.zllno = b.zllno

{
  key b.zllno,
  key b.zllitemno,
  key b.reservation,
  key b.reservationitem,
      a.zlllx,
      a.zllzt,
      a.productionplant,
      a.zcreate_date,
      a.zcreate_time,
      a.zcreate_user,
      a.zupdate_date,
      a.zupdate_time,
      a.zupdate_user,
      b.cp,
      b.cpname,
      b.zj,
      b.zjname,
      b.requestedqty,
      b.withdrawnqty1,
      b.requestedqtyunit,
      b.storagelocation,
      b.zcj,
      b.zcjtext,
      b.storagelocationto,
      b.reqworkshop,
      b.batch,
      b.manufacturingorder,
      b.yy1_mfgbatch_ord,
      b.zcy,
      b.zasflag,
      b.purchaseorder,
      b.purchaseorderitem,
      b.subcontractor,
      cast( '' as abap.char( 1 ))   as yy1_flag,
      cast( '' as abap.char( 220 )) as yy1_msg
}
