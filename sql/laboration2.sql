CREATE DATABASE laboration2;

CREATE USER 'lab2_user'@'localhost' IDENTIFIED BY 'placeholder';

GRANT CREATE, ALTER, DROP, REFERENCES, INDEX,
    SELECT, INSERT, UPDATE, DELETE
    ON laboration2.* TO 'lab2_user'@'localhost';

-- ^Dessa tre ovan körs som root, en gång. Sedan kör dessa inte igen.

SELECT CURRENT_USER(), DATABASE();

-- Tabeller (körs som lab2_user)
DROP TABLE IF EXISTS anstalld_kompetens;
DROP TABLE IF EXISTS passerkort;
DROP TABLE IF EXISTS kompetens;
DROP TABLE IF EXISTS anstalld;
DROP TABLE IF EXISTS avdelning;
-- Kör dessa för att jag i ett annat fönster hade lagt till dessa och det vart lite konstig.
-- Så vill ha ett clean table ifall att.

CREATE TABLE avdelning
(
    avdelning_id INT AUTO_INCREMENT PRIMARY KEY,
    namn         VARCHAR(100) NOT NULL,
    kontorsort   VARCHAR(100) NOT NULL
);

CREATE TABLE anstalld
(
    anstalld_id       INT AUTO_INCREMENT PRIMARY KEY,
    fornamn           VARCHAR(50)  NOT NULL,
    efternamn         VARCHAR(50)  NOT NULL,
    epost             VARCHAR(255) NOT NULL UNIQUE,
    anstallningsdatum DATE         NOT NULL,
    avdelning_id      INT          NOT NULL,
    FOREIGN KEY (avdelning_id) REFERENCES avdelning (avdelning_id)
);

CREATE TABLE passerkort
(
    passerkort_id   INT AUTO_INCREMENT PRIMARY KEY,
    kortnummer      VARCHAR(20) NOT NULL UNIQUE,
    utfardandedatum DATE        NOT NULL,
    giltigt_till    DATE        NOT NULL,
    anstalld_id     INT         NOT NULL UNIQUE,
    FOREIGN KEY (anstalld_id) REFERENCES anstalld (anstalld_id)
);

CREATE TABLE kompetens
(
    kompetens_id INT AUTO_INCREMENT PRIMARY KEY,
    namn         VARCHAR(100) NOT NULL UNIQUE,
    beskrivning  VARCHAR(255) NOT NULL
);

CREATE TABLE anstalld_kompetens
(
    anstalld_id  INT NOT NULL,
    kompetens_id INT NOT NULL,
    PRIMARY KEY (anstalld_id, kompetens_id),
    FOREIGN KEY (anstalld_id) REFERENCES anstalld (anstalld_id),
    FOREIGN KEY (kompetens_id) REFERENCES kompetens (kompetens_id)
);

-- Testdata
INSERT INTO avdelning (avdelning_id, namn, kontorsort)
VALUES (1, 'IT', 'Stockholm'),
       (2, 'Ekonomi', 'Göteborg'),
       (3, 'Försäljning', 'Malmö'),
       (4, 'Inköp', 'Uppsala');

INSERT INTO anstalld (anstalld_id, fornamn, efternamn, epost, anstallningsdatum, avdelning_id)
VALUES (1, 'Anna', 'Svensson', 'anna.svensson@foretaget.se', '2021-03-15', 1),
       (2, 'Erik', 'Johansson', 'erik.johansson@foretaget.se', '2019-08-01', 1),
       (3, 'Maria', 'Lindberg', 'maria.lindberg@foretaget.se', '2022-01-10', 2),
       (4, 'Johan', 'Karlsson', 'johan.karlsson@foretaget.se', '2020-05-20', 2),
       (5, 'Sara', 'Nilsson', 'sara.nilsson@foretaget.se', '2023-09-04', 3);

INSERT INTO passerkort (kortnummer, utfardandedatum, giltigt_till, anstalld_id)
VALUES ('K-1001', '2024-01-10', '2027-01-10', 1),
       ('K-1002', '2024-01-10', '2027-01-10', 2),
       ('K-1003', '2024-03-01', '2027-03-01', 3);

INSERT INTO kompetens (kompetens_id, namn, beskrivning)
VALUES (1, 'Java', 'Objektorienterad programmering i Java'),
       (2, 'SQL', 'Databasfrågor och datamodellering'),
       (3, 'Projektledning', 'Planering och ledning av projekt'),
       (4, 'Python', 'Skriptning och dataanalys');

INSERT INTO anstalld_kompetens (anstalld_id, kompetens_id)
VALUES (1, 1),
       (1, 2),
       (1, 3),
       (2, 1),
       (2, 2),
       (3, 3),
       (4, 2);

-- G1: anställda med avdelning
SELECT a.fornamn, a.efternamn, av.namn AS avdelning
FROM anstalld a
         INNER JOIN avdelning av ON a.avdelning_id = av.avdelning_id;

-- G2: alla avdelningar med anställda (även tomma)
SELECT av.namn AS avdelning, a.fornamn, a.efternamn
FROM avdelning av
         LEFT JOIN anstalld a ON a.avdelning_id = av.avdelning_id;

-- VG1: anställda med avdelning och eventuellt kortnummer
SELECT a.fornamn, a.efternamn, av.namn AS avdelning, p.kortnummer
FROM anstalld a
         INNER JOIN avdelning av ON a.avdelning_id = av.avdelning_id
         LEFT JOIN passerkort p ON p.anstalld_id = a.anstalld_id;

-- VG2: avdelningar med anställda och eventuellt kortnummer
SELECT av.namn AS avdelning, a.fornamn, a.efternamn, p.kortnummer
FROM avdelning av
         LEFT JOIN anstalld a ON a.avdelning_id = av.avdelning_id
         LEFT JOIN passerkort p ON p.anstalld_id = a.anstalld_id;

-- VG3: en anställds samlade uppgifter (byt id: 1 = Anna, 4 = Johan utan kort, 5 = Sara utan kompetenser)
SELECT a.anstalld_id,
       a.fornamn,
       a.efternamn,
       a.epost,
       a.anstallningsdatum,
       av.namn AS avdelning,
       av.kontorsort,
       p.kortnummer,
       p.utfardandedatum,
       p.giltigt_till,
       k.namn  AS kompetens,
       k.beskrivning
FROM anstalld a
         LEFT JOIN avdelning av ON a.avdelning_id = av.avdelning_id
         LEFT JOIN passerkort p ON p.anstalld_id = a.anstalld_id
         LEFT JOIN anstalld_kompetens ak ON ak.anstalld_id = a.anstalld_id
         LEFT JOIN kompetens k ON k.kompetens_id = ak.kompetens_id
WHERE a.anstalld_id = 1;

-- VG4: INNER JOIN mot LEFT JOIN
SELECT av.namn AS avdelning, a.fornamn, a.efternamn
FROM avdelning av
         INNER JOIN anstalld a ON a.avdelning_id = av.avdelning_id;

SELECT av.namn AS avdelning, a.fornamn, a.efternamn
FROM avdelning av
         LEFT JOIN anstalld a ON a.avdelning_id = av.avdelning_id;

-- Regelkontroller (ska om jag gjort rätt resultera i felmeddelande.)
# INSERT INTO passerkort (kortnummer, utfardandedatum, giltigt_till, anstalld_id)
# VALUES ('K-9999', '2025-01-01', '2028-01-01', 1);
# INSERT INTO anstalld (fornamn, efternamn, epost, anstallningsdatum, avdelning_id)
# VALUES ('Test', 'Testsson', 'test@foretaget.se', '2025-01-01', 99);
# INSERT INTO anstalld_kompetens (anstalld_id, kompetens_id)
# VALUES (1, 1);
