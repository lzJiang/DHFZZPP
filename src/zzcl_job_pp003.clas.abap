CLASS zzcl_job_pp003 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .
    INTERFACES if_oo_adt_classrun.
    CLASS-METHODS senwms
      IMPORTING plant  TYPE werks_d
                aufnr  TYPE aufnr
                status TYPE string
      EXPORTING req    TYPE string
                res    TYPE string
                flag   TYPE bapi_mtype
                msg    TYPE bapi_msg.

    DATA:rt_aufnr TYPE RANGE OF aufnr,
         rs_aufnr LIKE LINE OF rt_aufnr.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zzcl_job_pp003 IMPLEMENTATION.


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
    DATA:lv_count  TYPE i,
         lv_text   TYPE char200,
         lv_status TYPE string,
         lv_flag   TYPE bapi_mtype,
         lv_msg    TYPE bapi_msg,
         lv_req    TYPE string,
         lv_res    TYPE string,
         lv_aufnr  TYPE aufnr.


    LOOP AT it_parameters INTO DATA(l_parameter).
      CASE l_parameter-selname.
        WHEN 'AUFNR'.
          lv_aufnr = l_parameter-low.
          lv_aufnr = |{ lv_aufnr ALPHA = IN }|.
          APPEND VALUE #( sign   = l_parameter-sign
                          option = l_parameter-option
                          low    = lv_aufnr ) TO rt_aufnr.
      ENDCASE.
    ENDLOOP.

    TRY.
        DATA(l_log) = cl_bali_log=>create_with_header(
                        header = cl_bali_header_setter=>create( object = 'ZZAL_PP_0001'
                                                                subobject = 'ZZAL_PP_0001_SUB1' ) ).
        "1.检查
        IF rt_aufnr[] IS INITIAL.
          l_log->add_item( item = cl_bali_free_text_setter=>create( severity = if_bali_constants=>c_severity_error
                                                          text = '屏幕【生产订单】必输！' ) ).
          cl_bali_log_db=>get_instance( )->save_log_2nd_db_connection( log = l_log
                                                             assign_to_current_appl_job = abap_true ).
          RETURN.
        ENDIF.
        "2.获取生产订单状态
        SELECT *
          FROM i_mfgorderwithstatus WITH PRIVILEGED ACCESS
         WHERE manufacturingorder IN @rt_aufnr
          INTO TABLE @DATA(lt_mfgorderwithstatus).
        IF sy-subrc NE 0.
          l_log->add_item( item = cl_bali_free_text_setter=>create( severity = if_bali_constants=>c_severity_error
                                                          text = '未获取到生产订单数据！' ) ).
          cl_bali_log_db=>get_instance( )->save_log_2nd_db_connection( log = l_log
                                                             assign_to_current_appl_job = abap_true ).
          RETURN.
        ENDIF.
        "2.推送WMS
        LOOP AT lt_mfgorderwithstatus INTO DATA(ls_mfgorderwithstatus).
          CLEAR:lv_text,lv_flag,lv_msg,lv_text,lv_req,lv_res.
          lv_count = sy-tabix.
          IF ls_mfgorderwithstatus-orderistechnicallycompleted = 'X'
          OR ls_mfgorderwithstatus-orderisclosed = 'X'
          OR ls_mfgorderwithstatus-orderisdeleted = 'X'.
            lv_status = '关闭'.
          ELSE.
            lv_status = '下达'.
          ENDIF.
          lv_text = |{ lv_count }.开始推送生产订单【{ ls_mfgorderwithstatus-manufacturingorder }】-状态【{ lv_status }】|.
          l_log->add_item( item = cl_bali_free_text_setter=>create( severity = if_bali_constants=>c_severity_information
                                                text = lv_text ) ).
          senwms( EXPORTING plant = ls_mfgorderwithstatus-productionplant
                            aufnr = ls_mfgorderwithstatus-manufacturingorder
                            status = lv_status
                  IMPORTING req  = lv_req
                            res  = lv_res
                            flag = lv_flag
                            msg  = lv_msg ).
          IF lv_flag = 'E'.
            lv_text = |{ lv_count }.推送失败【{ lv_msg }】|.
            l_log->add_item( item = cl_bali_free_text_setter=>create( severity = if_bali_constants=>c_severity_error
                                                  text = lv_text ) ).
          ELSE.
            lv_text = |{ lv_count }.推送成功|.
            l_log->add_item( item = cl_bali_free_text_setter=>create( severity = if_bali_constants=>c_severity_status
                                                  text = lv_text ) ).
          ENDIF.
          lv_text = |{ lv_count }.推送报文【{ lv_req }】|.
          l_log->add_item( item = cl_bali_free_text_setter=>create( severity = if_bali_constants=>c_severity_information
                                                text = lv_text ) ).
          lv_text = |{ lv_count }.返回报文【{ lv_res }】|.
          l_log->add_item( item = cl_bali_free_text_setter=>create( severity = if_bali_constants=>c_severity_information
                                                text = lv_text ) ).
          lv_text = |{ lv_count }.结束推送生产订单【{ ls_mfgorderwithstatus-manufacturingorder }】-状态【{ lv_status }】|.
          l_log->add_item( item = cl_bali_free_text_setter=>create( severity = if_bali_constants=>c_severity_information
                                                text = lv_text ) ).
        ENDLOOP.

        cl_bali_log_db=>get_instance( )->save_log_2nd_db_connection( log = l_log
                                                                     assign_to_current_appl_job = abap_true ).
      CATCH cx_bali_runtime INTO DATA(l_runtime_exception).
        " some error handling
    ENDTRY.
  ENDMETHOD.

  METHOD senwms.
    TYPES BEGIN OF ty_send.
    TYPES:productionplant    TYPE string,
          manufacturingorder TYPE string,
          yy1_orderstatus    TYPE string.
    TYPES END OF ty_send.

    DATA:ls_send TYPE ty_send.
    DATA:lt_mapping TYPE /ui2/cl_json=>name_mappings.
    DATA:lv_oref TYPE zzefname,
         lt_ptab TYPE abap_parmbind_tab.
    DATA:lv_numb TYPE zzenumb VALUE 'PP004'.
    DATA:lv_data TYPE string.
    DATA:lv_msgty TYPE bapi_mtype,
         lv_msgtx TYPE bapi_msg,
         lv_resp  TYPE string.

    ls_send-productionplant = plant.
    ls_send-manufacturingorder = aufnr.
    ls_send-manufacturingorder = |{ ls_send-manufacturingorder ALPHA = OUT }|.
    ls_send-yy1_orderstatus = status.

    lt_mapping = VALUE #(
               ( abap = 'ProductionPlant'                              json = 'productionPlant'          )
               ( abap = 'ManufacturingOrder'                           json = 'manufacturingOrder'       )
               ( abap = 'YY1_orderstatus'                              json = 'yY1_orderstatus'          )
               ).

    "获取调用类
    SELECT SINGLE zzcname
      FROM zr_vt_rest_conf
     WHERE zznumb = @lv_numb
      INTO @lv_oref.
    IF lv_oref IS INITIAL.
      flag = 'E'.
      msg = |推送WMS失败，未配置接口PP004|.
      RETURN.
    ENDIF.

    "传入数据转JSON
    lv_data = /ui2/cl_json=>serialize(
          data          = ls_send
          compress      = abap_true
          pretty_name   = /ui2/cl_json=>pretty_mode-camel_case
          name_mappings = lt_mapping ).
*&--调用实例化接口
    DATA:lo_oref TYPE REF TO object.

    lt_ptab = VALUE #( ( name  = 'IV_NUMB' kind  = cl_abap_objectdescr=>exporting value = REF #( lv_numb ) ) ).
    TRY .
        CREATE OBJECT lo_oref TYPE (lv_oref) PARAMETER-TABLE lt_ptab.
        CALL METHOD lo_oref->('OUTBOUND_NO_LOG_SET')
          EXPORTING
            iv_data  = lv_data
          CHANGING
            ev_resp  = lv_resp
            ev_msgty = lv_msgty
            ev_msgtx = lv_msgtx.
      CATCH cx_root INTO DATA(lr_root).
        lv_msgty = 'E'.
        lv_msgtx = lr_root->get_longtext( ).
    ENDTRY.

    IF lv_msgty = 'S'.
      flag = 'S'.
      msg = |推送WMS成功|.
    ELSE.
      flag = 'E'.
      msg = |推送WMS失败:{ lv_msgtx }|.
    ENDIF.
    req = lv_data.
    res = lv_resp.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.

    DATA lv_job_text TYPE cl_apj_rt_api=>ty_job_text VALUE '测试推送生产订单1000006'.
    DATA lv_template_name TYPE cl_apj_rt_api=>ty_template_name VALUE 'ZZ_JT_PP003'.
    DATA ls_start_info TYPE cl_apj_rt_api=>ty_start_info.
    DATA ls_scheduling_info TYPE cl_apj_rt_api=>ty_scheduling_info.
    DATA ls_end_info TYPE cl_apj_rt_api=>ty_end_info.
    DATA lv_jobname TYPE cl_apj_rt_api=>ty_jobname.
    DATA lv_jobcount TYPE cl_apj_rt_api=>ty_jobcount.
    DATA job_start_info TYPE cl_apj_rt_api=>ty_start_info.
    DATA job_parameters TYPE cl_apj_rt_api=>tt_job_parameter_value.
    DATA job_parameter TYPE cl_apj_rt_api=>ty_job_parameter_value.
    DATA range_value TYPE cl_apj_rt_api=>ty_value_range.
    DATA job_name TYPE cl_apj_rt_api=>ty_jobname.
    DATA job_count TYPE cl_apj_rt_api=>ty_jobcount.
    DATA: date          TYPE sy-datum,
          time          TYPE sy-uzeit,
          saptimestamp  TYPE timestamp,
          javatimestamp TYPE string,
          lv_ts         TYPE string.
    DATA:lv_date TYPE sy-datum,   "日期
         lv_time TYPE sy-uzeit.   "时间
********** Set scheduling options *******************
    GET TIME STAMP FIELD saptimestamp .
    ls_start_info-start_immediately = ''.
    ls_start_info-timestamp =  saptimestamp + 60 * 3."3分钟后运行
    ls_scheduling_info-test_mode = abap_false.
    ls_scheduling_info-timezone = 'UTC+8'.

    job_parameter-name = 'AUFNR'.
    range_value-sign = 'I'.
    range_value-option = 'EQ'.
    range_value-low = '1000006'.
    APPEND range_value TO job_parameter-t_value.
    APPEND job_parameter TO job_parameters.
*****************************************************

    TRY.
        cl_apj_rt_api=>schedule_job(
          EXPORTING
            iv_job_template_name = lv_template_name
            iv_job_text          = lv_job_text
            is_start_info        = ls_start_info
            is_scheduling_info   = ls_scheduling_info
            is_end_info          = ls_end_info
            it_job_parameter_value = job_parameters
          IMPORTING
            ev_jobname           = lv_jobname
            ev_jobcount          = lv_jobcount
        ).
      CATCH cx_apj_rt INTO DATA(exc).
        DATA(lv_txt) = exc->get_longtext( ).
        DATA(ls_ret) = exc->get_bapiret2( ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
