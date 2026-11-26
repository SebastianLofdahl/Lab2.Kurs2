## Entiteter och Atribut:

- Avdelning: namn, kontorsort.
- Anställd: förnamn, efternamn, unik mail, anställningsdatum.
- Passerkort: unikt kortsnummer, utfärdsdatum, sista gilltighetsdatum.
- Kompetens: unikt namn, beskrivning.

## Relationer (med UML skrift):

![Diagram av tabellernas relationer](bilder/tables_diagram.png)
_(Dessa pilar var jobbigt att lista ut hur man gör i detta)_

- Avdelning 1 → 0..* Anställd. Främmande nyckel avdelning_id i anstalld, NOT NULL eftersom en anställd måste ha en
  avdelning.
- Anställd 1 → 0..1 Passerkort. Främmande nyckel anstalld_id i passerkort, med UNIQUE så att en anställd inte kan få två
  kort. Kortet kan inte finnas utan anställd (NOT NULL).
- Anställd * ↔ * Kompetens. Det kräver en kopplingstabell anstalld_kompetens med sammansatt primärnyckel (anstalld_id,
  kompetens_id), vilket hindrar samma koppling två gånger.

## Bilder med korta förklaringar (förklaringar är under bilderna, vill förtydliga de):

![Omstart av lab2](bilder/clean_start_had_to_redo_project.png)

- Var tvungen att göra om hela labben, vet inte exakt vad som hände med förra men hela databasen låste sig och var
  lättare att bara börja om och göra om stegen.

![Start av ny databas och user](bilder/create_database_user.png)

- Skapandet av min databas och user från root.

![Skapande av tabeller](bilder/create_table_anstalld.png)

- Skapande av tabellen "anställd".

![Skapande av tabeller](bilder/create_table_anstalld_kompetens.png)

- Skapande av relationstabell för att länka flera primära nycklar.

![Skapande av tabeller](bilder/create_table_avdelning.png)

- Skapande av "avdelning" tabellen.

![Skapande av tabeller](bilder/create_table_kompetens.png)

- Skapande av "kompetens" tabellen.

![Skapande av tabeller](bilder/create_table_passerkort.png)

- Skapande av tabellen "passerkort".

![Resultat av G1](bilder/g1.png)

- Första prompten: få fram datatabell om anställda med avdelning.

![Resultat av G2](bilder/g2.png)

- Andra prompten: få fram datatabell om alla avdelningar med anställda (även tomma).

![Resultat av VG1](bilder/vg1.png)

- Första VG promten: få fram datatabell om anställda med avdelning och eventuella kortnummer.

![Resultat av VG2](bilder/vg2.png)

- Andra VG promten: få fram datatabell om avdelningar med anställda och eventuella kortnummer.

![Resultat av VG3](bilder/vg3.png)
![Resultat av VG3](bilder/vg3_1.png)
![Resultat av VG3](bilder/vg3_2.png)

- Tredje VG prompten: få fram datatabell om en anställds samlade uppgifter.
- (byte av id: 1 = Anna (ovan, 4 = Johan utan kort (nedan 1), 5 = Sara utan kompetenser (nedan2)))
  ![Resultat av VG3](bilder/vg3.png)
  ![Resultat av VG3](bilder/vg3.png)

![Resultat av VG4](bilder/vg4_inner.png)
![Resultat av VG4](bilder/vg4_left.png)

- INNER JOIN mot LEFT JOIN: Inner join hittar bara resultat som matchar, medan Left tar de som matchar samt även de med
  eventuellt null värde från den vänstra tabellen.

![Tillagd testdata i tabellerna](bilder/testdata_anstalld.png)
![Tillagd testdata i tabellerna](bilder/testdata_avdelning.png)
![Tillagd testdata i tabellerna](bilder/testdata_kompetens.png)
![Tillagd testdata i tabellerna](bilder/testdata_passerkort.png)

- Min testdata och mina SQL promts för det, bad google om diverse namn och uppgifter.

![Körning av main](bilder/main_pic1.png)
![Körning av main](bilder/main_pic2.png)
![Körning av main](bilder/main_pic3.png)
![Körning av main](bilder/main_pic4.png)

- Min körning av main och alla resultat av tillagd information och utskrift av data från tabellerna.





