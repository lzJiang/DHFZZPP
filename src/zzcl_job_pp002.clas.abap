CLASS zzcl_job_pp002 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zzcl_job_pp002 IMPLEMENTATION.
  METHOD if_apj_dt_exec_object~get_parameters.
    et_parameter_def = VALUE #(
       ( selname        = 'P_AUFNR'
         kind           = if_apj_dt_exec_object=>parameter
         datatype       = 'C'
         length         = 12
         param_text     = '订单号'
         changeable_ind = abap_true
         mandatory_ind  = abap_true
          )
    ).
  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
*    DATA:lv_aufnr TYPE i_mfgorderwithstatus-manufacturingorder.
*
*    LOOP AT it_parameters INTO DATA(l_parameter).
*      CASE l_parameter-selname.
*        WHEN 'P_AUFNR'.
*          lv_aufnr = l_parameter-low.
*          lv_aufnr = |{ lv_aufnr ALPHA = IN }|.
*      ENDCASE.
*    ENDLOOP.
*
*    SELECT SINGLE *
*      FROM i_mfgorderwithstatus WITH PRIVILEGED ACCESS AS a
*      WHERE manufacturingorder = @lv_aufnr
*      INTO @DATA(ls_head).
*
*
*
*    TRY.
*        DATA(l_log) = cl_bali_log=>create_with_header(
*             header = cl_bali_header_setter=>create( object = 'ZZ_ALO_API'
*                                                     subobject = 'ZZ_ALO_API_SUB' ) ).
*
*        "推送数据
*
*
*        l_log->add_item( item = cl_bali_free_text_setter=>create(
*          severity = if_bali_constants=>c_severity_status
*          text = CONV #( |订单{ lv_aufnr ALPHA = OUT }推送成功！| ) ) ).
*
*
*        cl_bali_log_db=>get_instance( )->save_log_2nd_db_connection( log = l_log
*                                                                     assign_to_current_appl_job = abap_true ).
*      CATCH cx_bali_runtime INTO DATA(l_runtime_exception).
*        " some error handling
*    ENDTRY.
  ENDMETHOD.

ENDCLASS.
