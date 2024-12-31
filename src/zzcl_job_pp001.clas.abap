CLASS zzcl_job_pp001 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zzcl_job_pp001 IMPLEMENTATION.

  METHOD if_apj_dt_exec_object~get_parameters.
    et_parameter_def = VALUE #(
       ( selname        = 'AUFNR'
         kind           = if_apj_dt_exec_object=>select_option
         datatype       = 'C'
         length         = 12
         param_text     = '订单号'
         changeable_ind = abap_true )
    ).
  ENDMETHOD.

  METHOD if_apj_rt_exec_object~execute.

*    DATA:s_aufnr  TYPE RANGE OF i_mfgorderwithstatus-manufacturingorder,
*         lv_aufnr TYPE i_mfgorderwithstatus-manufacturingorder.
*
*
*    LOOP AT it_parameters INTO DATA(l_parameter).
*      CASE l_parameter-selname.
*        WHEN 'AUFNR'.
*          APPEND VALUE #( sign   = l_parameter-sign
*                          option = l_parameter-option
*                          low    = |{ l_parameter-low ALPHA = IN }|
*                          high   = |{ l_parameter-high ALPHA = IN }| ) TO s_aufnr.
*
*      ENDCASE.
*    ENDLOOP.
*
*
*    DATA:r_tmstmp  TYPE RANGE OF zzs_comm_log-last_changed_at,
*         lv_bstamp TYPE zzs_comm_log-last_changed_at,
*         lv_estamp TYPE zzs_comm_log-last_changed_at.
*
*
*    IF s_aufnr[] IS INITIAL.
*      "没有参数，默认后台增量推送
*      lv_bstamp =  zzcl_comm_tool=>get_last_execute( 'PP001' ).
*      GET TIME STAMP FIELD lv_estamp.
*      APPEND  VALUE #( option = 'BT'
*                       sign   = 'I'
*                       low    = lv_bstamp
*                       high   = lv_estamp
*                  ) TO r_tmstmp.
*
*      SELECT *
*        FROM zc_pp001_head WITH PRIVILEGED ACCESS AS a
*       WHERE lastchangedatetime IN @r_tmstmp
*        INTO TABLE @DATA(lt_head).
*    ELSE.
*      SELECT *
*         FROM zc_pp001_head WITH PRIVILEGED ACCESS AS a
*        WHERE manufacturingorder IN @s_aufnr
*         INTO TABLE @lt_head.
*    ENDIF.
*
*
*    IF lt_head IS NOT INITIAL.
*      "组件
*      SELECT a~manufacturingorder,
*             a~reservationitem,
*             a~material,
*             d~productname,
*             e~producttype,
*             e~materialtypename,
*             a~goodsmovemententryqty,
*             a~entryunit
*        FROM i_mfgorderoperationcomponent WITH PRIVILEGED ACCESS AS a
*        JOIN @lt_head AS b ON a~manufacturingorder = b~manufacturingorder
*        LEFT JOIN i_product AS c ON a~material = c~product
*        LEFT JOIN i_producttext AS d ON d~product  = c~product
*                                    AND d~language = @sy-langu
*        LEFT JOIN i_producttypetext AS e ON c~product = e~producttype
*                                   AND e~language = @sy-langu
*        INTO TABLE @DATA(lt_component).
*      SORT lt_component BY manufacturingorder reservationitem.
*    ENDIF.
*
*    TRY.
*        DATA(l_log) = cl_bali_log=>create_with_header(
*             header = cl_bali_header_setter=>create( object = 'ZZ_ALO_API'
*                                                     subobject = 'ZZ_ALO_API_SUB' ) ).
*
*        "循环推送数据
*        LOOP AT lt_head INTO DATA(ls_head).
*
*          l_log->add_item( item = cl_bali_free_text_setter=>create(
*            severity = if_bali_constants=>c_severity_status
*            text = CONV #( |订单{ ls_head-manufacturingorder ALPHA = OUT }推送成功！| ) ) ).
*
*        ENDLOOP.
*
*        IF lt_head IS INITIAL.
*          l_log->add_item( item = cl_bali_free_text_setter=>create(
*            severity = if_bali_constants=>c_severity_warning
*            text = CONV #( |没有可推送数据！| ) ) ).
*        ENDIF.
*
*
*        cl_bali_log_db=>get_instance( )->save_log_2nd_db_connection( log = l_log
*                                                                     assign_to_current_appl_job = abap_true ).
*      CATCH cx_bali_runtime INTO DATA(l_runtime_exception).
*        " some error handling
*    ENDTRY.



  ENDMETHOD.
ENDCLASS.
