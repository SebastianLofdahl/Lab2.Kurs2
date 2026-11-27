## Normalisering: filmuthyrning

### Underlaget

Filmuthyrningen sparar sina uthyrningar i ett kalkylblad:

| uthyrningsnummer | datum      | kunduppgifter                            | filmtitel   | speltid |
|------------------|------------|------------------------------------------|-------------|---------|
| 101              | 2026-11-01 | Anna Berg, anna@example.com, 070-1111111 | Stjärnresan | 119 min |
| 102              | 2026-11-02 | Erik Lind, erik@example.com, 070-2222222 | Månjakten   | 99 min  |
| 103              | 2026-11-05 | Anna Berg, anna@example.com, 070-1111111 | Månjakten   | 99 min  |

Förutsättningar enligt uppgiften:

- Varje uthyrning gäller för en kund och en film.
- Samma kund kan hyra flera gånger och samma film kan komma upp i flera uthyrningar.
- Mailen identifierar kunden och filmtiteln identifierar i sin tur filmen.

Problemen jag ser med underlaget:

- Cellen "kunduppgifter" innehåller tre separata uppgifter (namn, mail och telefon), och "speltid" blandar ett tal med
  en enhet.
- Annas uppgifter står på två rader (101 och 103).
- Månjakten och speltiden 99 min står på två rader (102 och 103).

### Steg 1: Dela upp celler med flera uppgifter

Jag delar `kunduppgifter` i `fornamn`, `efternamn`, `mail` och `telefon`. Speltiden `119 min` blir talet `119` i
kolumnen `speltid_min`, med enheten i kolumnnamnet. Då innehåller varje cell exakt ett värde, och man kan räkna på
speltiden. Det här motsvarar första normalformen (1NF). Som primärnyckel väljer jag `uthyrningsnummer`, eftersom varje
uthyrning har ett eget nummer.

| uthyrningsnummer (PK) | datum      | fornamn | efternamn | epost            | telefon     | filmtitel   | speltid_min |
|-----------------------|------------|---------|-----------|------------------|-------------|-------------|-------------|
| 101                   | 2026-11-01 | Anna    | Berg      | anna@example.com | 070-1111111 | Stjärnresan | 119         |
| 102                   | 2026-11-02 | Erik    | Lind      | erik@example.com | 070-2222222 | Månjakten   | 99          |
| 103                   | 2026-11-05 | Anna    | Berg      | anna@example.com | 070-1111111 | Månjakten   | 99          |

**Problemet som lösts:** cellerna är nu atomära, så man kan söka och sortera på till exempel efternamn eller mail.

**Vad kvarstår:** samma fakta upprepas fortfarande.

- Annas namn, mail och telefon står på rad 101 och 103.
- Månjakten och 99 minuter står på rad 102 och 103.

Det ger tre problem:

- **Ändringsproblem:** ändrar Anna telefonnummer måste två rader ändras. Missar man en blir databasen motsägelsefull.
- **Insättningsproblem:** man kan inte registrera en ny kund eller film som ännu inte har någon uthyrning.
- **Raderingsproblem:** raderas uthyrning 101 försvinner all information om Stjärnresan, eftersom den bara finns på den
  raden.

### Steg 2: Kontroll av delberoenden (andra normalformen)

En tabell bryter mot andra normalformen (2NF) om en kolumn beror på bara en del av en sammansatt primärnyckel. Här
består nyckeln av en enda kolumn (`uthyrningsnummer`), så tabellen uppfyller redan 2NF och inget behöver ändras i det
här steget.

### Steg 3: Dela upp uppgifter som hör ihop

Jag undersöker vad varje kolumn egentligen beror på:

- `uthyrningsnummer` bestämmer datum, vilken kund och vilken film.
- `epost` bestämmer kundens förnamn, efternamn och telefon. De hör till kunden, inte till uthyrningen.
- `filmtitel` bestämmer speltiden. Den hör till filmen, inte till uthyrningen.

Det är beroenden mellan kolumner som inte är nyckeln, och de bryter mot tredje normalformen (3NF). Lösningen är att
varje sorts uppgift får en egen tabell: `kund`, `film` och `uthyrning`. Uthyrningen kopplas till kund och film med
främmande nycklar. Än så länge använder jag mail och filmtitel som nycklar:

**kund**

| epost (PK)       | fornamn | efternamn | telefon     |
|------------------|---------|-----------|-------------|
| anna@example.com | Anna    | Berg      | 070-1111111 |
| erik@example.com | Erik    | Lind      | 070-2222222 |

**film**

| filmtitel (PK) | speltid_min |
|----------------|-------------|
| Stjärnresan    | 119         |
| Månjakten      | 99          |

**uthyrning**

| uthyrningsnummer (PK) | datum      | epost (FK)       | filmtitel (FK) |
|-----------------------|------------|------------------|----------------|
| 101                   | 2026-11-01 | anna@example.com | Stjärnresan    |
| 102                   | 2026-11-02 | erik@example.com | Månjakten      |
| 103                   | 2026-11-05 | anna@example.com | Månjakten      |

**Problemet som lösts:** varje fakta står nu på ett ställe. Annas telefonnummer finns bara på en rad och Månjaktens
speltid bara på en rad.

**Vad kvarstår:** mail och filmtitel är långa texter som upprepas i `uthyrning`, och de kan ändras. Ändrar Anna
mailadress måste alla hennes uthyrningar uppdateras. Det löser jag i nästa steg.

### Steg 4: Välj nycklar

Jag ersätter mail och filmtitel som nycklar med automatiskt genererade id:n (`kund_id` och `film_id`):

- Ett id ändras aldrig, så en kund kan byta mailadress utan att uthyrningarna påverkas.
- Heltal är korta och enkla att koppla ihop tabeller med.
- `mail` och `titel` behålls som **UNIQUE** och **NOT NULL**, så att samma kund eller film inte kan läggas in två
  gånger.

`uthyrningsnummer` behålls som primärnyckel i `uthyrning`, eftersom det redan finns i underlaget och är unikt. Främmande
nycklarna `kund_id` och `film_id` är NOT NULL, eftersom varje uthyrning måste gälla exakt en kund och exakt en film.

### Den färdiga strukturen

**kund**

| kund_id (PK) | fornamn | efternamn | epost (UNIQUE)   | telefon     |
|--------------|---------|-----------|------------------|-------------|
| 1            | Anna    | Berg      | anna@example.com | 070-1111111 |
| 2            | Erik    | Lind      | erik@example.com | 070-2222222 |

**film**

| film_id (PK) | titel (UNIQUE) | speltid_min |
|--------------|----------------|-------------|
| 1            | Stjärnresan    | 119         |
| 2            | Månjakten      | 99          |

**uthyrning**

| uthyrningsnummer (PK) | datum      | kund_id (FK) | film_id (FK) |
|-----------------------|------------|--------------|--------------|
| 101                   | 2026-11-01 | 1            | 1            |
| 102                   | 2026-11-02 | 2            | 2            |
| 103                   | 2026-11-05 | 1            | 2            |

### Nycklar

| Tabell    | Primärnyckel (PK) | Främmande nyckel (FK) | Hänvisar till  |
|-----------|-------------------|-----------------------|----------------|
| kund      | kund_id           | -                     | -              |
| film      | film_id           | -                     | -              |
| uthyrning | uthyrningsnummer  | kund_id               | kund (kund_id) |
| uthyrning | uthyrningsnummer  | film_id               | film (film_id) |

### Relationer

- **kund 1 → 0..\* uthyrning (en-till-många):** en kund kan hyra noll eller flera gånger, och varje uthyrning hör till
  exakt en kund.
- **film 1 → 0..\* uthyrning (en-till-många):** en film kan förekomma i noll eller flera uthyrningar, och varje
  uthyrning gäller exakt en film.
- **kund \* ↔ \* film (många-till-många):** en kund kan hyra flera filmer och en film kan hyras av flera kunder.
  Relationen löses av tabellen `uthyrning`, som kopplar ihop dem och dessutom har egna uppgifter (datum).
- Det finns inga en-till-en-relationer i den här strukturen.

### Kontroll: all information finns kvar

Med en JOIN sätter jag ihop tabellerna igen:

```sql
SELECT u.uthyrningsnummer,
       u.datum,
       k.fornamn,
       k.efternamn,
       k.epost,
       k.telefon,
       f.titel,
       f.speltid_min
FROM uthyrning u
         INNER JOIN kund k ON u.kund_id = k.kund_id
         INNER JOIN film f ON u.film_id = f.film_id;
```

| uthyrningsnummer | datum      | fornamn | efternamn | epost            | telefon     | titel       | speltid_min |
|------------------|------------|---------|-----------|------------------|-------------|-------------|-------------|
| 101              | 2026-11-01 | Anna    | Berg      | anna@example.com | 070-1111111 | Stjärnresan | 119         |
| 102              | 2026-11-02 | Erik    | Lind      | erik@example.com | 070-2222222 | Månjakten   | 99          |
| 103              | 2026-11-05 | Anna    | Berg      | anna@example.com | 070-1111111 | Månjakten   | 99          |

Resultatet är samma som tabellen i steg 1, så ingen information har gått förlorad.

### Problemen från steg 1 är lösta

- **Ändring:** ändrar Anna telefonnummer sker det på en rad i `kund`.
- **Insättning:** en ny kund eller film kan läggas in utan att någon uthyrning finns.
- **Radering:** raderas uthyrning 101 finns Stjärnresan kvar i `film`.