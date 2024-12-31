CLASS zcl_gorder_check_before_save DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_mfgorder_check_before_save .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GORDER_CHECK_BEFORE_SAVE IMPLEMENTATION.


  METHOD if_mfgorder_check_before_save~check_before_save.
    "1.检查是否流程订单
*    CHECK manufacturingorder-manufacturingordercategory = if_mfgorder_check_before_save=>con_processorder.

    "2.检查是新建还是修改
    SELECT SINGLE *
            FROM i_manufacturingorder WITH PRIVILEGED ACCESS
           WHERE manufacturingorder = @manufacturingorder-manufacturingorder
            INTO @DATA(ls_manufacturingorder).
    IF sy-subrc = 0.
      "修改时检查自定义字段计划批次和生产批次是否修改
*      IF manufacturingorder-yy1_mfgbatch_ord NE manufacturingorder_old-yy1_mfgbatch_ord.
*        INSERT VALUE #(
*         messagetype = 'E'
*         messagetext = |自定义字段【生产批次】不允许修改|
*       ) INTO TABLE messages.
*        RETURN.
*      ENDIF.
*      IF manufacturingorder-yy1_plannebatch_ord NE manufacturingorder_old-yy1_plannebatch_ord.
*        INSERT VALUE #(
*         messagetype = 'E'
*         messagetext = |自定义字段【计划批次】不允许修改|
*       ) INTO TABLE messages.
*        RETURN.
*      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
