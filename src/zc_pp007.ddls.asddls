@AbapCatalog.sqlViewName: 'ZV_C_PP007'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '领料单查询CDS视图'
@Metadata.ignorePropagatedAnnotations: true
define view ZC_PP007
  as select from    zzt_pp_002_head        as a
    inner join      zzt_pp_002_item        as b  on a.zllno = b.zllno
    left outer join I_UnitOfMeasure        as c  on b.requestedqtyunit = c.UnitOfMeasure
    inner join      I_Product              as zj on b.zj = zj.Product
    left outer join I_ProductGroupText_2   as i  on  zj.ProductGroup = i.ProductGroup
                                                 and i.Language      = $session.system_language
    left outer join I_StorageLocationStdVH as j  on  b.storagelocation = j.StorageLocation
                                                 and a.productionplant = j.Plant
    left outer join I_StorageLocationStdVH as k  on  b.storagelocationto = k.StorageLocation
                                                 and a.productionplant   = k.Plant
{
  key b.zllno,
  key b.zllitemno,
      a.zlllx,
      a.zllzt,
      a.productionplant,
      a.zcreate_date,
      a.zcreate_time,
      a.zcreate_user,
      a.zupdate_date,
      a.zupdate_time,
      a.zupdate_user,
      a.wmsno,
      b.cp,
      b.cpname,
      b.zj,
      b.zjname,
      i.ProductGroupName            as zjGroupName,
      b.requestedqty,
      b.withdrawnqty1,
      b.requestedqtyunit,
      c.UnitOfMeasure_E             as zjUnit,
      b.storagelocation,
      j.StorageLocationName,
      b.zcj,
      b.zcjtext,
      b.storagelocationto,
      k.StorageLocationName as storagelocationtoname,
      b.reqworkshop,
      b.batch,
      b.manufacturingorder,
      b.yy1_mfgbatch_ord,
      b.zcy,
      b.zasflag,
      b.zhlbz,
      b.zbz,
      b.purchaseorder,
      b.purchaseorderitem,
      b.subcontractor,
      cast( '' as abap.char( 1 ))   as yy1_flag,
      cast( '' as abap.char( 220 )) as yy1_msg
}
