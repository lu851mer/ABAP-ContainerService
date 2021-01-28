CLASS lhc_Kunde DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Kunde RESULT result.
    METHODS createKundeID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Kunde~createKundeID.

ENDCLASS.

CLASS lhc_Kunde IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD createKundeID.
  READ ENTITIES OF Z_KUNDE123_DATAMODELL IN LOCAL MODE
        ENTITY Kunde
          FIELDS ( KundeID )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_kunde).

    DELETE lt_kunde WHERE KundeID IS NOT INITIAL.
    CHECK lt_kunde IS NOT INITIAL.

    "Get max travelID
    SELECT SINGLE FROM ZKUNDE123 FIELDS MAX( kunde_id ) INTO @DATA(lv_max_kundeid).

    "update involved instances
    MODIFY ENTITIES OF Z_KUNDE123_DATAMODELL IN LOCAL MODE
      ENTITY Kunde
        UPDATE FIELDS ( KundeID )
        WITH VALUE #( FOR ls_kunde IN lt_kunde INDEX INTO i (
                           %key      = ls_kunde-%key
                           KundeID  = lv_max_kundeid + i ) )
    REPORTED DATA(lt_reported).
  ENDMETHOD.


ENDCLASS.
