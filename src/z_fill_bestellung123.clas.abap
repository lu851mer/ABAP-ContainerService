CLASS z_fill_bestellung123 DEFINITION
   PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z_fill_bestellung123 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA itab TYPE TABLE OF ZBESTELLUNG123.

*   fill internal travel table (itab)
    itab = VALUE #(
      ( bestellung_uid = '02D5290E594C1EDA93815057FD946724' bestellung_id = '00000001' bestellung_kunde_uid = '02D5290E594C1EDA93815057FD946824' bestellung_abholungsdatum = '20210228' bestellung_kommentar = 'Kein Kommentar'
     bestellung_erstelltdatum = '20190612133945.5960060 ' bestellung_aktualisiertdatum = '20190702105400.3647680' bestellung_status = 'Eingegangen' )
    ( bestellung_uid = '02D5290E594C1EDA93815057FD946725' bestellung_id = '00000002' bestellung_kunde_uid = '02D5290E594C1EDA93815057FD946825' bestellung_abholungsdatum = '20210606' bestellung_kommentar = 'Bitte nachts bringen'
     bestellung_erstelltdatum = '20190613111129.2391370 ' bestellung_aktualisiertdatum = '20190711140753.1472620' bestellung_status = 'Eingegangen' )
    ( bestellung_uid = '02D5290E594C1EDA93815057FD946726' bestellung_id = '00000003' bestellung_kunde_uid = '02D5290E594C1EDA93815057FD946826' bestellung_abholungsdatum = '20210126' bestellung_kommentar = 'Bin zwischen 9-10 nicht da'
     bestellung_erstelltdatum = '20190613105654.4296640 ' bestellung_aktualisiertdatum = '20190613111041.2251330' bestellung_status = 'In Bearbeitung' )
     ( bestellung_uid = '02D5290E594C1EDA93815057FD946727' bestellung_id = '00000004' bestellung_kunde_uid = '02D5290E594C1EDA93815057FD946827' bestellung_abholungsdatum = '20210126' bestellung_kommentar = 'Bitte vor Garage stellen'
     bestellung_erstelltdatum = '20190613105654.4296640 ' bestellung_aktualisiertdatum = '20190613111041.2251330' bestellung_status = 'In Bearbeitung' )
     ( bestellung_uid = '02D5290E594C1EDA93815057FD946728' bestellung_id = '00000005' bestellung_kunde_uid = '02D5290E594C1EDA93815057FD946828' bestellung_abholungsdatum = '20210126' bestellung_kommentar = 'Bitte bei Nachbar abstellen'
     bestellung_erstelltdatum = '20190613105654.4296640 ' bestellung_aktualisiertdatum = '20190613111041.2251330' bestellung_status = 'Eingegangen' )
).

*   delete existing entries in the database table
    DELETE FROM ZBESTELLUNG123.

*   insert the new table entries
    INSERT ZBESTELLUNG123 FROM TABLE @itab.

*   output the result as a console message
    out->write( |{ sy-dbcnt } bestellung entries inserted successfully!| ).

  ENDMETHOD.
ENDCLASS.
