CLASS z_123_message DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .
    INTERFACES if_abap_behv_message.

  CONSTANTS:
      BEGIN OF pickup_after_deliverydate,
        msgid TYPE symsgid VALUE 'Z_MESSAGECLASS',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'Lieferungsdatum',
        attr2 TYPE scx_attrname VALUE 'Abholungsdatum',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF pickup_after_deliverydate .
  CONSTANTS:
      BEGIN OF delivery_after_system_date,
        msgid TYPE symsgid VALUE 'Z_MESSAGECLASS',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'Lieferungsdatum',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF delivery_after_system_date .
    CONSTANTS:
      BEGIN OF abfallid_unknown,
        msgid TYPE symsgid VALUE 'Z_MESSAGECLASS',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'ABFALLID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF abfallid_unknown .
    CONSTANTS:
      BEGIN OF bestellungid_unknown,
        msgid TYPE symsgid VALUE 'Z_MESSAGECLASS',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'BESTELLUNGID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF bestellungid_unknown .

    METHODS constructor
      IMPORTING
        severity   TYPE if_abap_behv_message=>t_severity DEFAULT if_abap_behv_message=>severity-error
        textid     LIKE if_t100_message=>t100key OPTIONAL
        previous   TYPE REF TO cx_root OPTIONAL
        lieferungsdatum TYPE Z_BESTELLUNG123_DATUM OPTIONAL
        abholungsdatum TYPE Z_BESTELLUNG123_DATUM OPTIONAL
        abfallid TYPE Z_ABFALL123_ID OPTIONAL
        bestellungid   TYPE Z_BESTELLUNG123_ID  OPTIONAL
      .
    DATA lieferungsdatum TYPE Z_BESTELLUNG123_DATUM READ-ONLY.
    DATA abholungsdatum TYPE Z_BESTELLUNG123_DATUM READ-ONLY.
    DATA abfallid TYPE string READ-ONLY.
    DATA bestellungid TYPE string READ-ONLY.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z_123_MESSAGE IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

    me->if_abap_behv_message~m_severity = severity.
    me->lieferungsdatum = lieferungsdatum.
    me->abholungsdatum = abholungsdatum.
    me->abfallid = |{ abfallid ALPHA = OUT }|.
    me->bestellungid = |{ bestellungid ALPHA = OUT }|.
  ENDMETHOD.
  ENDCLASS.
