CLASS zzcl_mfgorder_check DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_mfgorder_check_before_save .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zzcl_mfgorder_check IMPLEMENTATION.


  METHOD if_mfgorder_check_before_save~check_before_save.
    "生产订单下达
    IF manufacturingorderstatus-orderisreleased = abap_true
      AND manufacturingorderstatus_old-orderisreleased = abap_false.
*      "下达推送给WMS
*      DATA job_template_name TYPE cl_apj_rt_api=>ty_template_name VALUE 'ZZ_JT_PP002'.
*      DATA job_start_info TYPE cl_apj_rt_api=>ty_start_info.
*      DATA job_parameters TYPE cl_apj_rt_api=>tt_job_parameter_value.
*      DATA job_name TYPE cl_apj_rt_api=>ty_jobname.
*      DATA job_count TYPE cl_apj_rt_api=>ty_jobcount.
*
*      job_start_info-start_immediately = abap_true.
*
*      APPEND VALUE #( name = 'P_AUFNR'
*                      t_value = VALUE #( ( sign   = 'I'
*                                           option = 'EQ'
*                                           low    = manufacturingorder-manufacturingorder  ) ) )
*         TO job_parameters.
*
*      TRY.
*          cl_apj_rt_api=>schedule_job(
*                   EXPORTING
*                   iv_job_template_name = job_template_name
*                   iv_job_text = |生产订单{ manufacturingorder-manufacturingorder ALPHA = OUT }推送WMS|
*                   is_start_info = job_start_info
*                   it_job_parameter_value = job_parameters
*                   IMPORTING
*                   ev_jobname  = job_name
*                   ev_jobcount = job_count
*                   ).
*        CATCH cx_apj_rt INTO DATA(job_scheduling_error).
*      ENDTRY.

    ENDIF.
  ENDMETHOD.
ENDCLASS.
