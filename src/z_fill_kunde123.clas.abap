CLASS z_fill_kunde123 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z_fill_kunde123 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA itab TYPE TABLE OF ZKUNDE123.

*   fill internal travel table (itab)
    itab = VALUE #(
      ( kunde_uid = '02D5290E594C1EDA93815057FD946824' kunde_id = '00000001' kunde_vorname = 'Hans' kunde_nachname = 'Müller' kunde_hausnr = '1' kunde_strasse = 'Musterweg' kunde_stadt = 'Musterstadt'
    kunde_plz = '12345' kunde_firma = 'Musterfirma ' kunde_ansprechpartner = 'Herbert' kunde_erstelltdatum = '20190612133945.5960060' kunde_aktualisiertdatum = '20190702105400.3647680' )
    ( kunde_uid = '02D5290E594C1EDA93815057FD946825' kunde_id = '00000002' kunde_vorname = 'Peter' kunde_nachname = 'Meier' kunde_hausnr = '1b' kunde_strasse = 'Musterstraße' kunde_stadt = 'Musterdorf'
    kunde_plz = '01234' kunde_firma = 'Musterunternehmen ' kunde_ansprechpartner = 'Gisela' kunde_erstelltdatum = '20190613111129.2391370' kunde_aktualisiertdatum = '20190711140753.1472620' )
    ( kunde_uid = '02D5290E594C1EDA93815057FD946826' kunde_id = '00000003' kunde_vorname = 'Ralf' kunde_nachname = 'Wurst' kunde_hausnr = '123a' kunde_strasse = 'AusgedachterWeg' kunde_stadt = 'Mustermetropole'
    kunde_plz = '23456' kunde_firma = 'Musterladen ' kunde_ansprechpartner = 'Hubert' kunde_erstelltdatum = '20190613105654.4296640' kunde_aktualisiertdatum = '20190613111041.2251330' )
    ( kunde_uid = '02D5290E594C1EDA93815057FD946827' kunde_id = '00000004' kunde_vorname = 'Kevin' kunde_nachname = 'Muster' kunde_hausnr = '123a' kunde_strasse = 'AusgedachterWeg' kunde_stadt = 'Mustermetropole'
    kunde_plz = '23456' kunde_firma = 'Musterladen ' kunde_ansprechpartner = 'Ralf' kunde_erstelltdatum = '20190613105654.4296640' kunde_aktualisiertdatum = '20190613111041.2251330' )
    ( kunde_uid = '02D5290E594C1EDA93815057FD946828' kunde_id = '00000005' kunde_vorname = 'Luca' kunde_nachname = 'April' kunde_hausnr = '123a' kunde_strasse = 'AusgedachterWeg' kunde_stadt = 'Mustermetropole'
    kunde_plz = '23456' kunde_firma = 'Musterladen ' kunde_ansprechpartner = 'Freddy' kunde_erstelltdatum = '20190613105654.4296640' kunde_aktualisiertdatum = '20190613111041.2251330' )
).

*   delete existing entries in the database table
    DELETE FROM ZKUNDE123.

*   insert the new table entries
    INSERT ZKUNDE123 FROM TABLE @itab.

*   output the result as a console message
    out->write( |{ sy-dbcnt } kunden entries inserted successfully!| ).

  ENDMETHOD.
ENDCLASS.
