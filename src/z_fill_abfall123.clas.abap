CLASS z_fill_abfall123 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z_fill_abfall123 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA itab TYPE TABLE OF ZABFALL123.

*   fill internal travel table (itab)
    itab = VALUE #(
      ( abfall_uid = '02D5290E594C1EDA93815057FD946624' abfall_id = '00000001' abfall_waehrung = 'EUR' abfall_preis = '200' abfall_kategorie = 'ERDE'
     abfall_erstelltdatum = '20190612133945.5960060 ' abfall_aktualisiertdatum = '20190702105400.3647680'  )
    ( abfall_uid = '02D5290E594C1EDA93815057FD946625' abfall_id = '00000002' abfall_waehrung = 'EUR' abfall_preis = '187' abfall_kategorie = 'SCHROTT'
     abfall_erstelltdatum = '20190613111129.2391370 ' abfall_aktualisiertdatum = '20190711140753.1472620' )
    ( abfall_uid = '02D5290E594C1EDA93815057FD946626' abfall_id = '00000003' abfall_waehrung = 'EUR' abfall_preis = '123' abfall_kategorie = 'BAUGEM'
     abfall_erstelltdatum = '20190613105654.4296640 ' abfall_aktualisiertdatum = '20190613111041.2251330' )
     ( abfall_uid = '02D5290E594C1EDA93815057FD946627' abfall_id = '00000004' abfall_waehrung = 'EUR' abfall_preis = '23' abfall_kategorie = 'KUNSTSTOFF'
     abfall_erstelltdatum = '20190613105654.4296640 ' abfall_aktualisiertdatum = '20190613111041.2251330' )
     ( abfall_uid = '02D5290E594C1EDA93815057FD946628' abfall_id = '00000005' abfall_waehrung = 'EUR' abfall_preis = '13' abfall_kategorie = 'BAUMIN'
     abfall_erstelltdatum = '20190613105654.4296640 ' abfall_aktualisiertdatum = '20190613111041.2251330' )
     ( abfall_uid = '02D5290E594C1EDA93815057FD946629' abfall_id = '00000006' abfall_waehrung = 'EUR' abfall_preis = '192' abfall_kategorie = 'HOLZ'
     abfall_erstelltdatum = '20190613105654.4296640 ' abfall_aktualisiertdatum = '20190613111041.2251330' )
     ( abfall_uid = '02D5290E594C1EDA93815057FD946623' abfall_id = '00000007' abfall_waehrung = 'EUR' abfall_preis = '222' abfall_kategorie = 'METALL'
     abfall_erstelltdatum = '20190613105654.4296640 ' abfall_aktualisiertdatum = '20190613111041.2251330' )
     ( abfall_uid = '02D5290E594C1EDA93815057FD946622' abfall_id = '00000008' abfall_waehrung = 'EUR' abfall_preis = '351' abfall_kategorie = 'BODEN'
     abfall_erstelltdatum = '20190613105654.4296640 ' abfall_aktualisiertdatum = '20190613111041.2251330' )
).

*   delete existing entries in the database table
    DELETE FROM ZABFALL123.

*   insert the new table entries
    INSERT ZABFALL123 FROM TABLE @itab.

*   output the result as a console message
    out->write( |{ sy-dbcnt } abfall entries inserted successfully!| ).

  ENDMETHOD.
ENDCLASS.
