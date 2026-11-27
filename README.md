## Innehåll i repot

- _sql/laboration2.sql:_ databas, användare, tabeller, testdata och SQL-frågor (lösenord ersatt med "placeholder")
- _src/:_ Java-projektet med modell-klasserna i "model" och "Main"
- _bilder/:_ skärmdumpar och datamodellen

## Entiteter och Attribut:

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

## Model till tabell (kul rim):

- Alla tabeller har en primärnyckel "id" av typen INT med AUTO_INCREMENT, så att varje rad får ett unikt värde utan att
  jag behöver komma på ett.
- Textfält är VARCHAR och datum är DATE. Kortnummer är VARCHAR eftersom det kan innehålla bokstäver och bindestreck.
- Obligatoriska fält är NOT NULL. E-post, kortnummer och kompetensnamn är UNIQUE.
- Främmande nycklar gör att databasen själv kontrollerar att en anställd hänvisar till en befintlig avdelning.
- "anstalld_id" i "passerkort" är UNIQUE, vilket gör att en anställd inte kan få två kort.
- Kopplingstabellen "anstalld_kompetens" har en sammansatt primärnyckel (anstalld_id, kompetens_id), så samma kompetens
  inte kan kopplas till samma anställda flera gånger.

## Bilder med korta förklaringar (förklaringar är under bilderna, vill förtydliga de):

![Omstart av lab2](bilder/clean_start_had_to_redo_project.png)

- Första draften låste sig, här är omskapandet av databasen och säkrande att det börja clean.

![Start av ny databas och user](bilder/create_database_user.png)

- Skapandet av min databas och user från root.

![Current User](bilder/current_user.png)

- Screenshot för SQL frågan om current user.

## Tabellskapande:

![Skapande av tabeller](bilder/create_table_anstalld.png)

- Skapande av tabellen "anställd".

![Skapande av tabeller](bilder/create_table_anstalld_kompetens.png)

- Skapande av kopplingstabell för att länka flera primära nycklar.

![Skapande av tabeller](bilder/create_table_avdelning.png)

- Skapande av "avdelning" tabellen.

![Skapande av tabeller](bilder/create_table_kompetens.png)

- Skapande av "kompetens" tabellen.

![Skapande av tabeller](bilder/create_table_passerkort.png)

- Skapande av tabellen "passerkort".

## G Delen:

![Resultat av G1](bilder/g1.png)

- Första SQL frågan: få fram datatabell om anställda med avdelning.
- "Avdelningar utan anställda syns inte (INNER JOIN)."

![Resultat av G2](bilder/g2.png)

- Andra SQL frågan: få fram datatabell om alla avdelningar med anställda (även tomma).
- "Inköp syns trots att den saknar anställda, med NULL i förnamn och efternamn (LEFT JOIN)."

## VG Delen:

![Resultat av VG1](bilder/vg1.png)

- Första VG SQL frågan: få fram datatabell om anställda med avdelning och eventuella kortnummer.
- "Anställda utan passerkort syns med NULL i kortnummer."

![Resultat av VG2](bilder/vg2.png)

- Andra VG SQL frågan: få fram datatabell om avdelningar med anställda och eventuella kortnummer.
- "Inköp syns trots att den saknar anställda, med NULL i namn- och kortnummerkolumnerna. Anställda utan passerkort syns
  med NULL i kortnummer."

![Resultat av VG3](bilder/vg3.png)
![Resultat av VG3](bilder/vg3_1.png)
![Resultat av VG3](bilder/vg3_2.png)

- Tredje VG SQL frågan: få fram datatabell om en anställds samlade uppgifter.
- (byte av id: 1 = Anna (ovan, 4 = Johan utan kort (nedan 1), 5 = Sara utan kompetenser (nedan2)))
  ![Resultat av VG3](bilder/vg3_opt4.png)
  ![Resultat av VG3](bilder/vg3_opt5.png)
- En anställd kan ge flera rader eftersom varje kompetens blir en egen rad i resultatet. Anna har tre kompetenser och
  ger därför tre rader, där hennes uppgifter, avdelningen och kortet upprepas på varje rad.

- Johan saknar passerkort och Sara saknar kompetenser, men båda syns ändå. Eftersom jag utgår från "anstalld" och
  använder LEFT JOIN behålls anställda även när det inte finns någon matchande rad i "passerkort" eller
  "anstalld_kompetens". De saknade kolumnerna blir NULL. Med INNER JOIN hade de försvunnit.

![Resultat av VG4](bilder/vg4_inner.png)
![Resultat av VG4](bilder/vg4_left.png)

- Fjärde VG SQL frågan: INNER JOIN mot LEFT JOIN: Inner join hittar bara resultat som matchar, medan Left tar de som
  matchar samt även de med eventuellt null värde från den vänstra tabellen.
- Avdelningen "Inköp" försvinner med INNER JOIN, eftersom den inte har några anställda och därför inte matchar någon rad
  i "anstalld". Med LEFT JOIN finns den kvar eftersom alla rader från vänster tabell (avdelning) behålls. Kolumnerna för
  förnamn och efternamn visar NULL på den raden, eftersom det inte finns någon anställd att hämta dem från.

## Kontroll av reglerna

![Dubblettkort](bilder/regelkontroll.png)

- Ett andra passerkort till samma anställd nekas, eftersom "anstalld_id" i "passerkort" är UNIQUE.

![Okänd avdelning](bilder/regelkontroll1.png)

- En anställd med en avdelning som inte finns nekas av främmande nyckeln.

![Dubblett i kopplingstabellen](bilder/regelkontroll2.png)

- Samma kompetens kan inte kopplas till samma anställd två gånger, på grund av den sammansatta primärnyckeln.

## Fiktiv testdata:

![Tillagd testdata i tabellerna](bilder/testdata_anstalld.png)
![Tillagd testdata i tabellerna](bilder/testdata_avdelning.png)
![Tillagd testdata i tabellerna](bilder/testdata_kompetens.png)
![Tillagd testdata i tabellerna](bilder/testdata_passerkort.png)

- Min testdata och mina SQL frågor för det, fiktiv testdata.

## Main körning av programet:

![Körning av main](bilder/main_pic1.png)
![Körning av main](bilder/main_pic2.png)
![Körning av main](bilder/main_pic3.png)
![Körning av main](bilder/main_pic4.png)

- Min körning av main och alla resultat av tillagd information och utskrift av data från tabellerna.

## JAVA koden och dess samband:

- Varje tabell har en klass i sub-packaget model: "Avdelning", "Anstalld", "Passerkort" och "Kompetens". Kolumnerna
  motsvaras av attribut. Id-kolumnerna finns inte i klasserna eftersom objektreferenser ersätter nycklar.

- Relationerna är gjorda så här:

- _Anställd → Avdelning:_ "Anstalld" har ett attribut av typen "Avdelning", som motsvarar främmande nyckeln. Flera
  anställda kan peka på samma avdelningsobjekt.
- _Anställd → Passerkort:_ "Anstalld" har ett attribut "Passerkort" som är "null" om anställd saknar kort.
- _Anställd ↔ Kompetens:_ "Anstalld" har en "List<Kompetens>". Listan ersätter kopplingstabellen. Flera anställda kan
  referera till samma "Kompetens"-objekt, och en kompetens kan finnas utan att någon anställd har den.

- Kopplingarna går bara åt ett håll, som uppgiften tillåter.

## Starta programmet

- Öppna projektet i IntelliJ, och välj main fliken, klicka på gröna pilen i toppen av programet ("run main". Resultatet
  skrivs ut i konsolen.





