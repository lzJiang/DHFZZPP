FUNCTION zzfm_pp_003.
*"----------------------------------------------------------------------
*"*"本地接口：
*"  IMPORTING
*"     REFERENCE(I_REQ) TYPE  ZZS_PPI003_REQ OPTIONAL
*"  EXPORTING
*"     REFERENCE(O_RESP) TYPE  ZZS_REST_OUT
*"----------------------------------------------------------------------
  .

  DATA:lt_table TYPE TABLE OF zzt_pp_001,
       ls_table TYPE zzt_pp_001.

  DATA(ls_tmp) = i_req-req.

  ls_tmp-manufacturingorder = |{  ls_tmp-manufacturingorder ALPHA = IN  }|.


  SELECT SINGLE a~manufacturingorder
    FROM i_mfgorderwithstatus WITH PRIVILEGED ACCESS AS a
   WHERE a~manufacturingorder = @ls_tmp-manufacturingorder
    INTO @DATA(ls_order).
  IF sy-subrc <> 0.
    o_resp-msgty = 'E'.
    o_resp-msgtx = |订单{ ls_tmp-manufacturingorder ALPHA = OUT  }不存在|.
    RETURN.
  ENDIF.

  SELECT SINGLE a~*
    FROM zzt_pp_001 WITH PRIVILEGED ACCESS AS a
   WHERE a~manufacturingorder = @ls_tmp-manufacturingorder
    INTO @DATA(ls_pp_001).
  CLEAR:ls_table.
  IF sy-subrc = 0.
    "已存在则只更新审批相关字段
    ls_table = CORRESPONDING #( ls_pp_001 ).
  ENDIF.

  ls_table-manufacturingorder = ls_tmp-manufacturingorder .
  ls_table-yy1_approvestatus = ls_tmp-approvestatus .
  ls_table-yy1_approve = ls_tmp-approve .
  ls_table-yy1_approvetime = ls_tmp-approvetime .
  ls_table-yy1_check = ls_tmp-check .
  ls_table-yy1_checktime = ls_tmp-checktime .
  ls_table-yy1_related_num = ls_tmp-related_num .
  ls_table-yy1_bpm_task_id = ls_tmp-bpm_task_id .

  APPEND ls_table TO lt_table.


  MODIFY zzt_pp_001 FROM TABLE @lt_table.
  o_resp-msgty = 'S'.
  o_resp-msgtx = 'success'.



ENDFUNCTION.
