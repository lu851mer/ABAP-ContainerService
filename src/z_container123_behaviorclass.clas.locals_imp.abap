CLASS lhc_Z_CONTAINER123_DATAMODELL DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF container_verfuegbarkeit,
        true TYPE c LENGTH 128  VALUE 'TRUE',
        false     TYPE c LENGTH 128  VALUE 'FALSE',
      END OF container_verfuegbarkeit.

     METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR Container RESULT result.

    METHODS createContainerID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Container~createContainerID.

    METHODS containerStatusFalse FOR MODIFY
      IMPORTING keys FOR ACTION Container~containerStatusFalse RESULT result.

    METHODS containerStatusTrue FOR MODIFY
      IMPORTING keys FOR ACTION Container~containerStatusTrue RESULT result.

    METHODS abfallid_unknown FOR VALIDATE ON SAVE
      IMPORTING keys FOR Container~abfallid_unknown.

    METHODS bestellungid_unknown FOR VALIDATE ON SAVE
      IMPORTING keys FOR Container~bestellungid_unknown.

ENDCLASS.

CLASS lhc_Z_CONTAINER123_DATAMODELL IMPLEMENTATION.

  METHOD get_features.
  " Read the travel status of the existing travels
    READ ENTITIES OF Z_CONTAINER123_DATAMODELL IN LOCAL MODE
      ENTITY Container
        FIELDS ( Verfuegbarkeit ) WITH CORRESPONDING #( keys )
      RESULT DATA(container2)
      FAILED failed.

    result =
      VALUE #(
        FOR container IN container2
          LET is_true =   COND #( WHEN container-Verfuegbarkeit = container_verfuegbarkeit-true
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled  )
              is_false =   COND #( WHEN container-Verfuegbarkeit = container_verfuegbarkeit-false
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled )
          IN
            ( %tky                 = container-%tky
              %action-containerStatusTrue = is_true
              %action-containerStatusFalse = is_false
             ) ).
  ENDMETHOD.

  METHOD createContainerID.
  READ ENTITIES OF Z_Container123_DATAMODELL IN LOCAL MODE
        ENTITY Container
          FIELDS ( ContainerID )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_container).

    DELETE lt_container WHERE ContainerID IS NOT INITIAL.
    CHECK lt_container IS NOT INITIAL.

    "Get max travelID
    SELECT SINGLE FROM ZCONTAINER123 FIELDS MAX( container_id ) INTO @DATA(lv_max_containerid).

    "update involved instances
    MODIFY ENTITIES OF Z_CONTAINER123_DATAMODELL IN LOCAL MODE
      ENTITY Container
        UPDATE FIELDS ( ContainerID )
        WITH VALUE #( FOR ls_container IN lt_container INDEX INTO i (
                           %key      = ls_container-%key
                           ContainerID  = lv_max_containerid + i ) )
    REPORTED DATA(lt_reported).
  ENDMETHOD.

  METHOD containerStatusFalse.
  " Set the new overall status
    MODIFY ENTITIES OF Z_CONTAINER123_DATAMODELL IN LOCAL MODE
      ENTITY Container
         UPDATE
           FIELDS ( Verfuegbarkeit )
           WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             Verfuegbarkeit = container_verfuegbarkeit-false ) )
      FAILED failed
      REPORTED reported.

    " Fill the response table
    READ ENTITIES OF Z_CONTAINER123_DATAMODELL IN LOCAL MODE
      ENTITY Container
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(container2).

    result = VALUE #( FOR container IN container2
                        ( %tky   = container-%tky
                          %param = container ) ).
  ENDMETHOD.

  METHOD containerStatusTrue.
  " Set the new overall status
    MODIFY ENTITIES OF Z_CONTAINER123_DATAMODELL IN LOCAL MODE
      ENTITY Container
         UPDATE
           FIELDS ( Verfuegbarkeit )
           WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             Verfuegbarkeit = container_verfuegbarkeit-true ) )
      FAILED failed
      REPORTED reported.

    " Fill the response table
    READ ENTITIES OF Z_CONTAINER123_DATAMODELL IN LOCAL MODE
      ENTITY Container
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(container2).

    result = VALUE #( FOR container IN container2
                        ( %tky   = container-%tky
                          %param = container ) ).
  ENDMETHOD.

  METHOD abfallid_unknown.
      " Read relevant travel instance data
    READ ENTITIES OF Z_CONTAINER123_DATAMODELL IN LOCAL MODE
      ENTITY Container
        FIELDS ( AbfallID ) WITH CORRESPONDING #( keys )
      RESULT DATA(container2).

    DATA abfaelle TYPE SORTED TABLE OF ZABFALL123 WITH UNIQUE KEY abfall_id.

    " Optimization of DB select: extract distinct non-initial agency IDs
    abfaelle = CORRESPONDING #( container2 DISCARDING DUPLICATES MAPPING abfall_id = AbfallID EXCEPT * ).
    DELETE abfaelle WHERE abfall_id IS INITIAL.

    IF abfaelle IS NOT INITIAL.
      " Check if agency ID exist
      SELECT FROM ZABFALL123 FIELDS abfall_id
        FOR ALL ENTRIES IN @abfaelle
        WHERE abfall_id = @abfaelle-abfall_id
        INTO TABLE @DATA(abfaelle_db).
    ENDIF.

    " Raise msg for non existing and initial agencyID
    LOOP AT container2 INTO DATA(container).
      " Clear state messages that might exist
      APPEND VALUE #(  %tky               = container-%tky
                       %state_area        = 'VALIDATE_Abfall' )
        TO reported-container.

      IF container-AbfallID IS INITIAL OR NOT line_exists( abfaelle_db[ abfall_id = container-AbfallID ] ).
        APPEND VALUE #( %tky = container-%tky ) TO failed-container.

        APPEND VALUE #( %tky        = container-%tky
                        %state_area = 'VALIDATE_Abfall'
                        %msg        = NEW Z_123_MESSAGE(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = Z_123_MESSAGE=>abfallid_unknown
                                          abfallid = container-AbfallID )
                        %element-AbfallID = if_abap_behv=>mk-on )
          TO reported-container.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD bestellungid_unknown.
    " Read relevant travel instance data
    READ ENTITIES OF Z_CONTAINER123_DATAMODELL IN LOCAL MODE
      ENTITY Container
        FIELDS ( BestellungID ) WITH CORRESPONDING #( keys )
      RESULT DATA(container2).

    DATA bestellungen TYPE SORTED TABLE OF ZBESTELLUNG123 WITH UNIQUE KEY bestellung_id.

    " Optimization of DB select: extract distinct non-initial agency IDs
    bestellungen = CORRESPONDING #( container2 DISCARDING DUPLICATES MAPPING bestellung_id = BestellungID EXCEPT * ).
    DELETE bestellungen WHERE bestellung_id IS INITIAL.

    IF bestellungen IS NOT INITIAL.
      " Check if agency ID exist
      SELECT FROM ZBESTELLUNG123 FIELDS bestellung_id
        FOR ALL ENTRIES IN @bestellungen
        WHERE bestellung_id = @bestellungen-bestellung_id
        INTO TABLE @DATA(abfaelle_db).
    ENDIF.

    " Raise msg for non existing and initial agencyID
    LOOP AT container2 INTO DATA(container).
      " Clear state messages that might exist
      APPEND VALUE #(  %tky               = container-%tky
                       %state_area        = 'VALIDATE_Bestellung' )
        TO reported-container.

      IF container-BestellungID IS INITIAL OR NOT line_exists( abfaelle_db[ bestellung_id = container-BestellungID ] ).
        APPEND VALUE #( %tky = container-%tky ) TO failed-container.

        APPEND VALUE #( %tky        = container-%tky
                        %state_area = 'VALIDATE_Bestellung'
                        %msg        = NEW Z_123_MESSAGE(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = Z_123_MESSAGE=>bestellungid_unknown
                                          bestellungid = container-BestellungID )
                        %element-BestellungID = if_abap_behv=>mk-on )
          TO reported-container.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
