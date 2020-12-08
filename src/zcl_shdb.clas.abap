class ZCL_SHDB definition
  public
  final
  create public .

public section.

  data GT_BDCDATA type AMC_BDCDATA_TAB .

  methods SET_DYNPRO
    importing
      !I_PROGRAM type BDCDATA-PROGRAM
      !I_DYNPRO type BDCDATA-DYNPRO .
  methods SET_FIELD
    importing
      !I_FNAM type STRING
      !I_FVAL type STRING .
  methods RESET .
  methods CALL_TRANSACTION
    importing
      !I_TCODE type TCODE
      !I_MODE type CHAR01
      !I_UPDATE type CHAR01
    exporting
      !E_MSG type TAB_BDCMSGCOLL .
protected section.
private section.
ENDCLASS.



CLASS ZCL_SHDB IMPLEMENTATION.


  METHOD call_transaction.
*--------------------------------------------------------------------*
* Modes type
*--------------------------------------------------------------------*
*mode	Effect
*"A"  Processing with screens displayed
*"E"  Screens displayed only if an error occurs
*"N"  Processing without screens displayed. If a breakpoint is reached in one of the called transactions, processing is terminated with sy-subrc equal to 1001. The field sy-msgty contains "S", sy-msgid contains "00", sy-msgno contains "344", sy-msgv1
*     contains "SAPMSSY3", and sy-msgv2 contains "0131".
*"P"  Processing without screens displayed. If a breakpoint is reached in one of the called transactions, the system branches to the ABAP Debugger.
*Others	As for "A".
*--------------------------------------------------------------------*

*--------------------------------------------------------------------*
* Updates type
*--------------------------------------------------------------------*
*upd  Effect
*"A"  Asynchronous update. Updates of called programs are executed in the same way as if the addition AND WAIT were not specified in the statement COMMIT WORK.
*"S"  Synchronous update. Updates of the called programs are executed in the same way as if the addition AND WAIT were specified in the statement COMMIT WORK.
*"L"  Local updates. Updates of the called program are executed in the same way as if the statement SET UPDATE TASK LOCAL were executed in the program.
*Others	As for "A".
*--------------------------------------------------------------------*

    CALL TRANSACTION i_tcode USING gt_bdcdata
                             MODE  i_mode
                             UPDATE i_update
                             MESSAGES INTO e_msg.

  ENDMETHOD.


  method RESET.

    CLEAR gt_bdcdata.

  endmethod.


  METHOD set_dynpro.

    APPEND INITIAL LINE TO gt_bdcdata ASSIGNING FIELD-SYMBOL(<bdcdata>).
    <bdcdata>-program  = i_program.
    <bdcdata>-dynpro   = i_dynpro.
    <bdcdata>-dynbegin = abap_true.

  ENDMETHOD.


  METHOD set_field.

    APPEND INITIAL LINE TO gt_bdcdata ASSIGNING FIELD-SYMBOL(<bdcdata>).
    <bdcdata>-fnam = i_fnam.
    <bdcdata>-fval = i_fval.

  ENDMETHOD.
ENDCLASS.
