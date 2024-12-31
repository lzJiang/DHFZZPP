CLASS zzcl_pp004 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

    METHODS get_data
      IMPORTING io_request  TYPE REF TO if_rap_query_request
                io_response TYPE REF TO if_rap_query_response
      RAISING   cx_rap_query_prov_not_impl
                cx_rap_query_provider.

    METHODS get_period
      IMPORTING
        iv_yearmonth        TYPE i_calendardate-yearmonth
        iv_sign             TYPE i
      RETURNING
        VALUE(ev_yearmonth) TYPE i_calendardate-yearmonth.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zzcl_pp004 IMPLEMENTATION.
  METHOD get_period.
    DATA:lv_year  TYPE i_calendardate-calendaryear,
         lv_month TYPE i_calendardate-calendarmonth.

    lv_year = iv_yearmonth+0(4).
    lv_month = iv_yearmonth+4(2).
    lv_month = lv_month + iv_sign.
    IF  lv_month > 12.
      lv_year = lv_year + 1.
      lv_month = lv_month - 12.
      ev_yearmonth = lv_year && lv_month.
    ELSE.
      ev_yearmonth = lv_year && lv_month.
    ENDIF.
  ENDMETHOD.

  METHOD get_data.
    DATA: lt_result TYPE TABLE OF zc_rpp004,
          ls_result TYPE zc_rpp004.

    DATA:r_werks TYPE RANGE OF zc_rpp004-plant,
         r_matnr TYPE RANGE OF zc_rpp004-product,
         r_maktx TYPE RANGE OF zc_rpp004-productname,
         r_group TYPE RANGE OF zc_rpp004-externalproductgroup,
         r_mrp   TYPE RANGE OF zc_rpp004-materiallastmrpdatetime.
    DATA:lv_qty TYPE i_salesorderitem-orderquantity.
    DATA:lv_finishingrate TYPE p LENGTH 10 DECIMALS 3.
    DATA:lv_fiscalyear   TYPE zc_rpp004-fiscalyear,
         lv_fiscalperiod TYPE zc_rpp004-fiscalperiod.


    DATA:lv_field(30).
    DATA:lv_period TYPE i_calendardate-yearmonth.
    DATA:lv_period1 TYPE i_calendardate-yearmonth.
    DATA:lv_period2 TYPE i_calendardate-yearmonth.
    DATA:lv_period3 TYPE i_calendardate-yearmonth.
    DATA:lv_period4 TYPE i_calendardate-yearmonth.
    DATA:lv_period5 TYPE i_calendardate-yearmonth.
    DATA:lv_period_1 TYPE i_calendardate-yearmonth.
    DATA:lv_period_2 TYPE i_calendardate-yearmonth.

    TRY.
        DATA(lo_filter) = io_request->get_filter(  ).     "CDS VIEW ENTITY 选择屏幕过滤器
        DATA(lt_filters) = lo_filter->get_as_ranges(  ).  "ABAP range
*       过滤器
        LOOP AT lt_filters INTO DATA(ls_filter).
          TRANSLATE ls_filter-name TO UPPER CASE.
          CASE ls_filter-name.
            WHEN 'PLANT'.
              r_werks = CORRESPONDING #( ls_filter-range ).
            WHEN 'PRODUCT'.
              r_matnr = CORRESPONDING #( ls_filter-range ).
            WHEN 'PRODUCTNAME'.
              r_maktx = CORRESPONDING #( ls_filter-range ).
            WHEN 'EXTERNALPRODUCTGROUP'.
              r_group = CORRESPONDING #( ls_filter-range ).
            WHEN 'FISCALYEAR'.
              lv_fiscalyear = ls_filter-range[ 1 ]-low.
            WHEN 'FISCALPERIOD'.
              lv_fiscalperiod = ls_filter-range[ 1 ]-low.
            WHEN 'MATERIALLASTMRPDATETIME'.
              r_mrp =  CORRESPONDING #( ls_filter-range ).
          ENDCASE.
        ENDLOOP.

      CATCH cx_rap_query_filter_no_range.
        RETURN.
    ENDTRY.


    DATA:r_by TYPE RANGE OF i_calendardate-calendardate.
    DATA:r_by5 TYPE RANGE OF i_calendardate-calendardate.
    DATA:r_by_2 TYPE RANGE OF i_calendardate-calendardate.

    DATA:lv_day   TYPE i_calendardate-calendardate,
         lv_day5  TYPE i_calendardate-calendardate,
         lv_day_2 TYPE i_calendardate-calendardate.

    lv_period = lv_fiscalyear && lv_fiscalperiod.

    lv_period1 =   get_period( iv_yearmonth = lv_period iv_sign = 1 ).
    lv_period2 =   get_period( iv_yearmonth = lv_period iv_sign = 2 ).
    lv_period3 =   get_period( iv_yearmonth = lv_period iv_sign = 3 ).
    lv_period4 =   get_period( iv_yearmonth = lv_period iv_sign = 4 ).
    lv_period5 =   get_period( iv_yearmonth = lv_period iv_sign = 5 ).

    lv_period_1 =   get_period( iv_yearmonth = lv_period iv_sign = '-1' ).
    lv_period_2 =   get_period( iv_yearmonth = lv_period iv_sign = '-2' ).

    lv_day = lv_period && '01'.
    lv_day5 = lv_period5 && '01'.
    lv_day_2 = lv_period_2 && '01'.

    SELECT *                                  "#EC CI_ALL_FIELDS_NEEDED
      FROM i_calendardate
     WHERE calendardate IN (@lv_day,@lv_day5,@lv_day_2 )
      INTO TABLE @DATA(lt_date).
    "本月
    READ TABLE lt_date INTO DATA(ls_date) WITH KEY yearmonth = lv_period.
    r_by = VALUE #( ( low  = ls_date-firstdayofmonthdate
                      high = ls_date-lastdayofmonthdate
                      sign = 'I'
                      option = 'BT' ) ).

    READ TABLE lt_date INTO DATA(ls_date5) WITH KEY yearmonth = lv_period5.
    "五个月
    r_by5 = VALUE #( ( low  = ls_date-firstdayofmonthdate
                       high = ls_date5-lastdayofmonthdate
                       sign = 'I'
                       option = 'BT' ) ).
    READ TABLE lt_date INTO DATA(ls_date_2) WITH KEY yearmonth = lv_period_2.
    "前两个月
    r_by_2 = VALUE #( ( low  = ls_date_2-firstdayofmonthdate
                        high = ls_date-lastdayofmonthdate
                        sign = 'I'
                        option = 'BT' ) ).

    SELECT a~plant,
           a~product,
           c~productname,
           b~externalproductgroup,
           a~mrpresponsible,
           a~baseunit,
           b~sizeordimensiontext,
           d~mrpcontrollername,
           a~mrptype,
           a~minimumlotsizequantity,
           a~maximumlotsizequantity,
           a~fixedlotsizequantity,
           e~materiallastmrpdatetime

      FROM i_productplantbasic AS a
      JOIN i_product AS b ON a~product = b~product
      JOIN i_producttext AS c ON a~product = c~product
                             AND c~language = @sy-langu
      LEFT JOIN i_mrpcontroller WITH PRIVILEGED ACCESS AS d ON d~plant = a~plant
                                    AND d~mrpcontroller = a~mrpresponsible
      LEFT JOIN i_mrpareaplanningfileentry AS e ON a~plant = e~plant
                                               AND a~product = e~material
     WHERE a~plant IN @r_werks
       AND a~product IN @r_matnr
       AND c~productname IN @r_maktx
       AND b~externalproductgroup IN @r_group
       AND e~materiallastmrpdatetime IN @r_mrp
      INTO TABLE @DATA(lt_data).

    "上次MRP运行时间
*    SELECT a~plant,
*           a~material,
*           a~materiallastmrpdatetime
*      FROM i_mrpareaplanningfileentry AS a
*      JOIN @lt_data AS b ON a~plant = b~plant
*                        AND a~material = b~product
*      INTO TABLE @DATA(lt_fileentry).
*    SORT lt_fileentry BY plant material.

    "生产周期
    SELECT a~plant,
           a~product,
           a~prodinhprodndurationinworkdays
      FROM i_productplantsupplyplanning  AS a
      JOIN @lt_data AS b ON  a~plant = b~plant
                         AND a~product = b~product
      INTO TABLE @DATA(lt_supplyplanning).
    SORT lt_supplyplanning BY plant product .

    "生产批量
    SELECT a~plant,
           a~material,
           b~bomheaderquantityinbaseunit
      FROM i_materialbomlink AS a
      JOIN i_billofmaterialwithkeydate( p_keydate = @sy-datum ) AS b ON a~billofmaterial = b~billofmaterial
                                            AND a~billofmaterialvariant = b~billofmaterialvariant
                                            AND a~billofmaterialvariantusage = b~billofmaterialvariantusage
                                             AND a~billofmaterialcategory = b~billofmaterialcategory
      JOIN @lt_data AS c ON  a~plant = c~plant
                        AND a~material = c~product
      INTO TABLE @DATA(lt_bomlink).
    SORT lt_bomlink BY plant material.

    "库存
    SELECT a~plant,
           a~product,
           a~inventorystocktype,
          SUM( a~matlwrhsstkqtyinmatlbaseunit ) AS matlwrhsstkqtyinmatlbaseunit
      FROM i_stockquantitycurrentvalue_2( p_displaycurrency = 'CNY' ) AS a
      JOIN @lt_data AS b ON a~plant   = b~plant
                        AND a~product = b~product
     WHERE a~inventorystocktype IN ('01','02')
       AND a~valuationareatype = '1'
     GROUP BY a~plant, a~product,a~inventorystocktype
      INTO TABLE @DATA(lt_stock).
    SORT lt_stock BY plant product inventorystocktype .

    "本月销量
    SELECT a~plant,
           a~product,
           c~salesordertype,
           SUM(  a~orderquantity )  AS orderquantity
      FROM i_salesorderitem  AS a
      JOIN @lt_data AS b ON a~plant   = b~plant
                        AND a~product = b~product
      JOIN i_salesorder AS c ON a~salesorder = c~salesorder
     WHERE c~salesordertype IN ('OR','CBAR')
       AND c~creationdate IN @r_by
     GROUP BY a~plant,a~product,c~salesordertype
      INTO TABLE @DATA(lt_salesorderitem).
    SORT lt_salesorderitem BY plant product salesordertype.

    "在产品数
    SELECT a~plant,
           a~product,
           SUM( a~mfgorderitemopenyieldqty )  AS mfgorderitemopenyieldqty
      FROM zc_rpp004_mfgorder AS a
      JOIN @lt_data AS b ON a~plant   = b~plant
                         AND a~product = b~product
     GROUP BY a~plant,a~product
    INTO TABLE @DATA(lt_mfgorder).
    SORT lt_mfgorder BY plant product.
    "销售计划
    SELECT a~plant,
           a~product,
           a~yearmonth,
          SUM( a~plannedquantity )  AS plannedquantity
      FROM zc_rpp004_activeplnd AS a
      JOIN @lt_data AS c ON a~plant   = c~plant
                        AND a~product = c~product
     WHERE a~workingdaydate IN @r_by5
     GROUP BY a~plant, a~product, a~yearmonth
      INTO TABLE @DATA(lt_rqmt).
    SORT lt_rqmt BY plant product yearmonth.

    "安全库存
    SELECT a~plant,
           a~product,
           a~safetystockquantity
      FROM i_productplantsupplyplanning   AS a
      JOIN @lt_data AS b ON a~plant   = b~plant
                        AND a~product = b~product
    INTO TABLE @DATA(lt_safetystock).
    SORT lt_safetystock BY plant product.

    "生产计划
    SELECT a~plant,
           a~product,
           a~yearmonth,
          SUM( a~plannedtotalqtyinbaseunit )  AS plannedtotalqty
      FROM zc_rpp004_plannedorder AS a
      JOIN @lt_data AS c ON a~plant   = c~plant
                        AND a~product = c~product
     WHERE a~plndorderplannedstartdate IN @r_by5
     GROUP BY a~plant, a~product, a~yearmonth
      INTO TABLE @DATA(lt_plannedorder).
    SORT lt_plannedorder BY plant product yearmonth.

    "前三个月平均出库数量
    SELECT a~outbounddelivery,
           a~outbounddeliveryitem,
           a~plant,
           a~product,
           substring( c~actualgoodsmovementdate,1,4 ) AS yearmonth,
           a~actualdeliveryquantity
      FROM i_outbounddeliveryitem AS a
      JOIN i_outbounddelivery AS c ON a~outbounddelivery = c~outbounddelivery
      JOIN @lt_data AS b ON a~plant   = b~plant
                        AND a~product = b~product
      WHERE c~overallgoodsmovementstatus = 'C'
        AND c~actualgoodsmovementdate IN @r_by_2
        AND c~deliverydocumenttype = 'LF'
       INTO TABLE @DATA(lt_deliveryitem).

    SELECT a~plant,
           a~product,
           a~yearmonth,
           SUM( actualdeliveryquantity ) AS actualdeliveryquantity
     FROM @lt_deliveryitem AS a
     GROUP BY a~plant, a~product, a~yearmonth
     INTO TABLE @DATA(lt_sum_delivery).
    SORT lt_sum_delivery BY plant product.

    LOOP AT lt_data INTO DATA(ls_data).
      CLEAR:ls_result.
      MOVE-CORRESPONDING ls_data TO ls_result.
      "上次MRP运行时间
*      READ TABLE lt_fileentry INTO DATA(ls_fileentry) WITH KEY plant    = ls_result-plant
*                                                               material = ls_result-product BINARY SEARCH.
*      IF sy-subrc = 0.
*        ls_result-materiallastmrpdatetime = ls_fileentry-materiallastmrpdatetime.
*      ENDIF.
      "生产周期
      READ TABLE lt_supplyplanning INTO DATA(ls_supplyplanning) WITH KEY plant    = ls_result-plant
                                                                         product = ls_result-product BINARY SEARCH.
      IF sy-subrc = 0.
        ls_result-prodinhprodndurationinworkdays = ls_supplyplanning-prodinhprodndurationinworkdays.
      ENDIF.
      "生产批量
      READ TABLE lt_bomlink INTO DATA(ls_bomlink) WITH KEY plant = ls_result-plant
                                                           material = ls_result-product BINARY SEARCH.
      IF sy-subrc = 0.
        ls_result-bomheaderquantityinbaseunit = ls_bomlink-bomheaderquantityinbaseunit.
      ENDIF.
      "库存
      READ TABLE lt_stock TRANSPORTING NO FIELDS WITH KEY plant = ls_result-plant
                                                          product = ls_result-product BINARY SEARCH.
      IF sy-subrc = 0.
        LOOP AT lt_stock INTO DATA(ls_stock) FROM sy-tabix.
          IF ls_stock-plant = ls_result-plant
          AND ls_stock-product = ls_result-product.
            CASE ls_stock-inventorystocktype.
              WHEN '01'.
                ls_result-zzfxz = ls_stock-matlwrhsstkqtyinmatlbaseunit.
              WHEN '02'.
                ls_result-zzdj = ls_stock-matlwrhsstkqtyinmatlbaseunit.
            ENDCASE.
          ELSE.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.

      "本月销量
      READ TABLE lt_salesorderitem TRANSPORTING NO FIELDS WITH KEY plant = ls_result-plant
                                                                 product = ls_result-product BINARY SEARCH.
      IF sy-subrc = 0.
        LOOP AT lt_salesorderitem INTO DATA(ls_salesorderitem) FROM sy-tabix.
          IF ls_salesorderitem-plant = ls_result-plant
          AND ls_salesorderitem-product = ls_result-product.
            CASE ls_salesorderitem-salesordertype.
              WHEN 'OR'.
                ls_result-zzbyxl = ls_salesorderitem-orderquantity.
              WHEN 'CBAR'.
                ls_result-zzth = ls_salesorderitem-orderquantity.
            ENDCASE.
          ELSE.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.

      "在制品
      READ TABLE lt_mfgorder INTO DATA(ls_mfgorder) WITH KEY plant = ls_result-plant
                                                             product = ls_result-product BINARY SEARCH.
      IF sy-subrc = 0.
        ls_result-zzzp  = ls_mfgorder-mfgorderitemopenyieldqty.
      ENDIF.

      "销售计划
      READ TABLE lt_rqmt TRANSPORTING NO FIELDS WITH KEY plant = ls_result-plant
                                                        product = ls_result-product BINARY SEARCH.
      IF sy-subrc = 0.
        LOOP AT lt_rqmt INTO DATA(ls_rqmt) FROM sy-tabix.
          IF ls_rqmt-plant = ls_result-plant
          AND ls_rqmt-product = ls_result-product.
            CASE ls_rqmt-yearmonth.
              WHEN lv_period.
                ls_result-plannedquantity = ls_rqmt-plannedquantity.
              WHEN lv_period1.
                ls_result-plannedquantity1 = ls_rqmt-plannedquantity.
              WHEN lv_period2.
                ls_result-plannedquantity2 = ls_rqmt-plannedquantity.
              WHEN lv_period3.
                ls_result-plannedquantity3 = ls_rqmt-plannedquantity.
              WHEN lv_period4.
                ls_result-plannedquantity4 = ls_rqmt-plannedquantity.
              WHEN lv_period5.
                ls_result-plannedquantity5 = ls_rqmt-plannedquantity.
            ENDCASE.
          ELSE.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.

      "安全库存
      READ TABLE lt_safetystock INTO DATA(ls_safetystock) WITH KEY plant = ls_result-plant
                                                                   product = ls_result-product BINARY SEARCH.
      IF sy-subrc = 0.
        ls_result-safetystockquantity  = ls_safetystock-safetystockquantity.
      ENDIF.

      "生产计划
      READ TABLE lt_plannedorder TRANSPORTING NO FIELDS WITH KEY plant = ls_result-plant
                                                               product = ls_result-product BINARY SEARCH.
      IF sy-subrc = 0.
        LOOP AT lt_plannedorder INTO DATA(ls_plannedorder) FROM sy-tabix.
          IF ls_plannedorder-plant = ls_result-plant
          AND ls_plannedorder-product = ls_result-product.
            CASE ls_plannedorder-yearmonth.
              WHEN lv_period.
                ls_result-plannedtotalqty = ls_plannedorder-plannedtotalqty.
              WHEN lv_period1.
                ls_result-plannedtotalqty1 = ls_plannedorder-plannedtotalqty.
              WHEN lv_period2.
                ls_result-plannedtotalqty2 = ls_plannedorder-plannedtotalqty.
              WHEN lv_period3.
                ls_result-plannedtotalqty3 = ls_plannedorder-plannedtotalqty.
              WHEN lv_period4.
                ls_result-plannedtotalqty4 = ls_plannedorder-plannedtotalqty.
              WHEN lv_period5.
                ls_result-plannedtotalqty5 = ls_plannedorder-plannedtotalqty.
            ENDCASE.
          ELSE.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.

      "出库量
      CLEAR:lv_qty.
      READ TABLE lt_sum_delivery TRANSPORTING NO FIELDS WITH KEY plant = ls_result-plant
                                                               product = ls_result-product BINARY SEARCH.
      IF sy-subrc = 0.
        LOOP AT lt_sum_delivery INTO DATA(ls_sum_delivery) FROM sy-tabix.
          IF ls_sum_delivery-plant = ls_result-plant
          AND ls_sum_delivery-product = ls_result-product.

            lv_qty = lv_qty + ls_sum_delivery-actualdeliveryquantity.
            CASE ls_sum_delivery-yearmonth.
              WHEN lv_period.
                ls_result-zzbych = ls_sum_delivery-actualdeliveryquantity.
            ENDCASE.
          ELSE.
            EXIT.
          ENDIF.
        ENDLOOP.

        ls_result-zzpjch = lv_qty.
      ENDIF.
      "预计月末库存
      ls_result-zzyjymkc = ls_result-zzfxz + ls_result-zzdj - ( ls_result-plannedquantity - ls_result-zzbyxl ).
      "缺口数
      ls_result-zzqk = ls_result-plannedtotalqty1 + ls_result-plannedtotalqty2 + ls_result-plannedtotalqty3
                       + ls_result-safetystockquantity - ls_result-zzyjymkc - ls_result-zzzp.
      "完成比
      CLEAR:lv_finishingrate.
      IF ls_result-plannedquantity <> 0.
        lv_finishingrate = ls_result-zzbych / ls_result-plannedquantity * 100.
      ELSE.
        lv_finishingrate = 100.
      ENDIF.
      ls_result-finishingrate = |{ lv_finishingrate }%|.
      CONDENSE ls_result-finishingrate  NO-GAPS.



      ls_result-fiscalyear = lv_fiscalyear.
      ls_result-fiscalperiod = lv_fiscalperiod.
      APPEND ls_result TO lt_result.
    ENDLOOP.

*&---====================2.数据获取后，select 排序/过滤/分页/返回设置
*&---设置过滤器
    zzcl_query_utils=>filtering( EXPORTING io_filter = io_request->get_filter(  ) CHANGING ct_data = lt_result ).
*&---设置记录总数
    IF io_request->is_total_numb_of_rec_requested(  ) .
      io_response->set_total_number_of_records( lines( lt_result ) ).
    ENDIF.
*&---设置排序
    zzcl_query_utils=>orderby( EXPORTING it_order = io_request->get_sort_elements( )  CHANGING ct_data = lt_result ).
*&---设置按页查询
    zzcl_query_utils=>paging( EXPORTING io_paging = io_request->get_paging(  ) CHANGING ct_data = lt_result ).
*&---返回数据
    io_response->set_data( lt_result ).
  ENDMETHOD.



  METHOD if_rap_query_provider~select.
*       rap 接口查询，选择处理
    TRY.
        CASE io_request->get_entity_id(  ).
          WHEN 'ZC_RPP004'.
            get_data( io_request  = io_request
                      io_response = io_response ).

        ENDCASE.
      CATCH cx_rap_query_provider INTO DATA(lx_query).
        RETURN.
      CATCH cx_sy_no_handler INTO DATA(lx_synohandler).
        RETURN.
      CATCH cx_sy_open_sql_db.
        RETURN.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
