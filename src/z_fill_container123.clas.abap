CLASS z_fill_container123 DEFINITION
   PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z_fill_container123 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA itab TYPE TABLE OF ZCONTAINER123.

*   fill internal travel table (itab)
    itab = VALUE #(
    ( container_uid = '02D5290E594C1EDA93815057FD946924' container_id = '00000001' container_abfall_id = '00000001'
      container_bestellung_id = '00000001' container_gewicht = '1000'
    container_verfuegbar = 'FALSE' container_erstelltdatum = '20190612133945.5960060 ' container_aktualisiertdatum = '20190702105400.3647680'  )
    ( container_uid = '02D5290E594C1EDA93815057FD946925' container_id = '00000002' container_abfall_id = '00000002'
    container_bestellung_id = '00000002' container_gewicht = '2000'
    container_verfuegbar = 'TRUE' container_erstelltdatum = '20190613111129.2391370 ' container_aktualisiertdatum = '20190711140753.1472620' )
    ( container_uid = '02D5290E594C1EDA93815057FD946926' container_id = '00000003' container_abfall_id = '00000003'
    container_bestellung_id = '00000003' container_gewicht = '3000'
    container_verfuegbar = 'FALSE' container_erstelltdatum = '20190613105654.4296640 ' container_aktualisiertdatum = '20190613111041.2251330' )
    ( container_uid = '02D5290E594C1EDA93815057FD946927' container_id = '00000004' container_abfall_id = '00000004'
    container_bestellung_id = '00000004' container_gewicht = '1252'
    container_verfuegbar = 'TRUE' container_erstelltdatum = '20190613105654.4296640 ' container_aktualisiertdatum = '20190613111041.2251330' )
    ( container_uid = '02D5290E594C1EDA93815057FD946928' container_id = '00000005' container_abfall_id = '00000005'
    container_bestellung_id = '00000005' container_gewicht = '10000'
    container_verfuegbar = 'FALSE' container_erstelltdatum = '20190613105654.4296640 ' container_aktualisiertdatum = '20190613111041.2251330' )
).

*   delete existing entries in the database table
    DELETE FROM ZCONTAINER123.

*   insert the new table entries
    INSERT ZCONTAINER123 FROM TABLE @itab.

*   output the result as a console message
    out->write( |{ sy-dbcnt } container entries inserted successfully!| ).

  ENDMETHOD.
ENDCLASS.
