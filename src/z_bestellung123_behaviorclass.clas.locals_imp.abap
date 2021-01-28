CLASS lhc_bestellung DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF bestellung_status,
        eingegangen     TYPE c LENGTH 128  VALUE 'Eingegangen',
        bearbeitung TYPE c LENGTH 128  VALUE 'In Bearbeitung',
        abgeschlossen TYPE c LENGTH 128  VALUE 'Abgeschlossen',
      END OF bestellung_status.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR Bestellung RESULT result.
    METHODS createBestellungID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Bestellung~createBestellungID.
    METHODS setInitialStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Bestellung~setInitialStatus.
    METHODS acceptBestellung FOR MODIFY
      IMPORTING keys FOR ACTION Bestellung~acceptBestellung RESULT result.
    METHODS finishBestellung FOR MODIFY
      IMPORTING keys FOR ACTION Bestellung~finishBestellung RESULT result.

    METHODS validateDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Bestellung~validateDate.

ENDCLASS.

CLASS lhc_bestellung IMPLEMENTATION.

  METHOD get_features.
    " Read the travel status of the existing travels
    READ ENTITIES OF Z_KUNDE123_DATAMODELL IN LOCAL MODE
      ENTITY Bestellung
        FIELDS ( Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(bestellungen)
      FAILED failed.

    result =
      VALUE #(
        FOR bestellung IN bestellungen
          LET is_accepted =   COND #( WHEN bestellung-Status = bestellung_status-bearbeitung
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled  )
              is_finished =   COND #( WHEN bestellung-Status = bestellung_status-abgeschlossen
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled )
          IN
            ( %tky                 = bestellung-%tky
              %action-acceptBestellung = is_accepted
              %action-finishBestellung = is_finished
             ) ).
  ENDMETHOD.
    METHOD createBestellungID.
      DATA max_bestellungid TYPE Z_BESTELLUNG123_ID.
    DATA update TYPE TABLE FOR UPDATE Z_KUNDE123_DATAMODELL\\Bestellung.

    " Read all travels for the requested bookings.
    " If multiple bookings of the same travel are requested, the travel is returned only once.
    READ ENTITIES OF Z_KUNDE123_DATAMODELL IN LOCAL MODE
    ENTITY Bestellung BY \_Kunde
      FIELDS ( KundeUID )
      WITH CORRESPONDING #( keys )
      RESULT DATA(kunden).

    " Process all affected Travels. Read respective bookings, determine the max-id and update the bookings without ID.
    LOOP AT kunden INTO DATA(kunde).
      READ ENTITIES OF Z_KUNDE123_DATAMODELL IN LOCAL MODE
        ENTITY Kunde BY \_Bestellung
          FIELDS ( BestellungID )
        WITH VALUE #( ( %tky = kunde-%tky ) )
        RESULT DATA(bestellungen).

      " Find max used BookingID in all bookings of this travel
      max_bestellungid ='0000'.
      LOOP AT bestellungen INTO DATA(bestellung).
        IF bestellung-BestellungID > max_bestellungid.
          max_bestellungid = bestellung-BestellungID.
        ENDIF.
      ENDLOOP.

      " Provide a booking ID for all bookings that have none.
      LOOP AT bestellungen INTO bestellung WHERE BestellungID IS INITIAL.
        max_bestellungid += 10.
        APPEND VALUE #( %tky      = bestellung-%tky
                        BestellungID = max_bestellungid
                      ) TO update.
      ENDLOOP.
    ENDLOOP.

    " Update the Booking ID of all relevant bookings
    MODIFY ENTITIES OF Z_KUNDE123_DATAMODELL IN LOCAL MODE
    ENTITY Bestellung
      UPDATE FIELDS ( BestellungID ) WITH update
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD setInitialStatus.
  " Read relevant travel instance data
    READ ENTITIES OF Z_KUNDE123_DATAMODELL IN LOCAL MODE
      ENTITY Bestellung
        FIELDS ( Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(status2).

    " Remove all travel instance data with defined status
    DELETE status2 WHERE Status IS NOT INITIAL.
    CHECK status2 IS NOT INITIAL.

    " Set default travel status
    MODIFY ENTITIES OF Z_KUNDE123_DATAMODELL IN LOCAL MODE
    ENTITY Bestellung
      UPDATE
        FIELDS ( Status )
        WITH VALUE #( FOR status IN status2
                      ( %tky         = status-%tky
                        Status = bestellung_status-eingegangen ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD acceptBestellung.
    " Set the new overall status
    MODIFY ENTITIES OF Z_KUNDE123_DATAMODELL IN LOCAL MODE
      ENTITY Bestellung
         UPDATE
           FIELDS ( Status )
           WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             Status = bestellung_status-bearbeitung ) )
      FAILED failed
      REPORTED reported.

    " Fill the response table
    READ ENTITIES OF Z_KUNDE123_DATAMODELL IN LOCAL MODE
      ENTITY Bestellung
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(bestellungen).

    result = VALUE #( FOR bestellung IN bestellungen
                        ( %tky   = bestellung-%tky
                          %param = bestellung ) ).
  ENDMETHOD.

  METHOD finishBestellung.
    " Set the new overall status
    MODIFY ENTITIES OF Z_KUNDE123_DATAMODELL IN LOCAL MODE
      ENTITY Bestellung
         UPDATE
           FIELDS ( Status )
           WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             Status = bestellung_status-abgeschlossen ) )
      FAILED failed
      REPORTED reported.

    " Fill the response table
    READ ENTITIES OF Z_KUNDE123_DATAMODELL IN LOCAL MODE
      ENTITY Bestellung
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(bestellungen).

    result = VALUE #( FOR bestellung IN bestellungen
                        ( %tky   = bestellung-%tky
                          %param = bestellung ) ).
  ENDMETHOD.
  METHOD validateDate.
  READ ENTITIES OF Z_KUNDE123_DATAMODELL IN LOCAL MODE
      ENTITY Bestellung
        FIELDS ( Abholungsdatum ) WITH CORRESPONDING #( keys )
      RESULT DATA(bestellungen).

    LOOP AT bestellungen INTO DATA(bestellung).
      " Clear state messages that might exist
      APPEND VALUE #(  %tky        = bestellung-%tky
                       %state_area = 'VALIDATE_DATES' )
        TO reported-bestellung.

      IF bestellung-Abholungsdatum < cl_abap_context_info=>get_system_date( ).
        APPEND VALUE #( %tky = bestellung-%tky ) TO failed-bestellung.
        APPEND VALUE #( %tky               = bestellung-%tky
                        %state_area        = 'VALIDATE_DATES'
                        %msg               = NEW Z_123_MESSAGE(
                                                 severity  = if_abap_behv_message=>severity-error
                                                 textid    = Z_123_MESSAGE=>delivery_before_system_date
                                                 Abholungsdatum = bestellung-Abholungsdatum )

                        %element-Abholungsdatum   = if_abap_behv=>mk-on ) TO reported-bestellung.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
