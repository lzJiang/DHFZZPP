CLASS zcl_mfgorder_hdr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_cobadicfl_mfgorder_hdr .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_mfgorder_hdr IMPLEMENTATION.


  METHOD if_cobadicfl_mfgorder_hdr~modify_header.
    DATA lv_job_text TYPE cl_apj_rt_api=>ty_job_text.
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
    IF save_phase = 'X'  AND create_mode = ''.
      "修改保存阶段
      SELECT SINGLE *
               FROM i_mfgorderwithstatus WITH PRIVILEGED ACCESS
              WHERE manufacturingorder = @manufacturingorder-manufacturingorder
                INTO @DATA(ls_database).
      IF ls_database-orderistechnicallycompleted NE manufacturingorder-orderistechnicallycompleted
      OR ls_database-orderisclosed NE manufacturingorder-orderisclosed
      OR ls_database-orderisdeleted NE manufacturingorder-orderisdeleted .
        "状态变更,启用后台作业推送WMS
        GET TIME STAMP FIELD saptimestamp .
        ls_start_info-start_immediately = ''.
        ls_start_info-timestamp =  saptimestamp + 60 * 2."2分钟后运行
        ls_scheduling_info-test_mode = abap_false.
        ls_scheduling_info-timezone = 'UTC+8'.
        lv_job_text = |生产订单{ manufacturingorder-manufacturingorder }状态变更推送WMS|.
        job_parameter-name = 'AUFNR'.
        range_value-sign = 'I'.
        range_value-option = 'EQ'.
        range_value-low = manufacturingorder-manufacturingorder.
        APPEND range_value TO job_parameter-t_value.
        APPEND job_parameter TO job_parameters.

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
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
