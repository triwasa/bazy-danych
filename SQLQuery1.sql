--USE master;
--DROP DATABASE Projekty;
--GO

CREATE DATABASE Projekty5;
--GO

USE Projekty5;
--GO

SET LANGUAGE polski;
GO

-------- USUŃ TABELE --------

DROP TABLE IF EXISTS Realizacje;
DROP TABLE IF EXISTS Projekty;
DROP TABLE IF EXISTS Pracownicy;
DROP TABLE IF EXISTS Stanowiska;

--------- CREATE - UTWÓRZ TABELE I POWIĄZANIA --------

CREATE TABLE Stanowiska
(
    nazwa      VARCHAR(10) PRIMARY KEY,
    placa_min  MONEY,
    placa_max  MONEY,
    CHECK (placa_min < placa_max)
);

CREATE TABLE Pracownicy
(
    id           INT NOT NULL PRIMARY KEY,
    nazwisko     VARCHAR(20) NOT NULL,
    szef         INT REFERENCES Pracownicy(id),
    placa        MONEY,
    dod_funkc    MONEY,
    stanowisko   VARCHAR(10) REFERENCES Stanowiska(nazwa),
    zatrudniony  DATETIME
);

CREATE TABLE Projekty
(
    id               INT IDENTITY(10,10) NOT NULL PRIMARY KEY,
    nazwa            VARCHAR(20) NOT NULL UNIQUE,
    dataRozp         DATETIME NOT NULL,
    dataZakonczPlan  DATETIME NOT NULL,
    dataZakonczFakt  DATETIME NULL,
    kierownik        INT REFERENCES Pracownicy(id),
    stawka           MONEY
);

CREATE TABLE Realizacje
(
    idProj  INT REFERENCES Projekty(id),
    idPrac  INT REFERENCES Pracownicy(id),
    godzin  REAL DEFAULT 8
);

GO

---------- INSERT - WSTAW DANE --------

INSERT INTO Stanowiska VALUES ('profesor',   3000, 5000);
INSERT INTO Stanowiska VALUES ('adiunkt',    2000, 3000);
INSERT INTO Stanowiska VALUES ('doktorant',   900, 1300);
INSERT INTO Stanowiska VALUES ('sekretarka', 1500, 2500);
INSERT INTO Stanowiska VALUES ('techniczny', 1500, 2500);
INSERT INTO Stanowiska VALUES ('dziekan',    2700, 4800);

INSERT INTO Pracownicy VALUES (1,  'Wachowiak', NULL, 4500,  900,   'profesor', '01-09-1980');
INSERT INTO Pracownicy VALUES (2,  'Jankowski',    1, 2500, NULL,    'adiunkt', '01-09-1990');
INSERT INTO Pracownicy VALUES (3,  'Fiołkowska',   1, 2550, NULL,    'adiunkt', '01-01-1985');
INSERT INTO Pracownicy VALUES (4,  'Mielcarz',     1, 4000,  400,   'profesor', '01-12-1980');
INSERT INTO Pracownicy VALUES (5,  'Różycka',      4, 2800,  200,   'profesor', '01-09-2001');
INSERT INTO Pracownicy VALUES (6,  'Mikołajski',   4, 1000, NULL,  'doktorant', '01-10-2002');
INSERT INTO Pracownicy VALUES (7,  'Wójcicki',     5, 1350, NULL,  'doktorant', '01-10-2003');
INSERT INTO Pracownicy VALUES (8,  'Listkiewicz',  1, 2200, NULL, 'sekretarka', '01-09-1980');
INSERT INTO Pracownicy VALUES (9,  'Wróbel',       1, 1900,  300, 'techniczny', '01-01-1999');
INSERT INTO Pracownicy VALUES (10, 'Andrzejewicz', 5, 2900, NULL,    'adiunkt', '01-01-2002');

INSERT INTO Projekty VALUES ('e-learning',     '01-01-2015', '31-05-2016',         NULL, 5, 100);
INSERT INTO Projekty VALUES ('web service',    '10-11-2009', '31-12-2010', '20-04-2011', 4,  90);
INSERT INTO Projekty VALUES ('semantic web',   '01-09-2017', '01-09-2019',         NULL, 4,  85);
INSERT INTO Projekty VALUES ('neural network', '01-01-2008', '30-06-2010', '30-06-2010', 1, 120);

INSERT INTO Realizacje VALUES (10,  5, 8);
INSERT INTO Realizacje VALUES (10, 10, 6);
INSERT INTO Realizacje VALUES (10,  9, 2);
INSERT INTO Realizacje VALUES (20,  4, 8);
INSERT INTO Realizacje VALUES (20,  6, 8);
INSERT INTO Realizacje VALUES (20,  9, 2);
INSERT INTO Realizacje VALUES (30,  4, 8);
INSERT INTO Realizacje VALUES (30,  6, 6);
INSERT INTO Realizacje VALUES (30, 10, 6);
INSERT INTO Realizacje VALUES (30,  9, 2);
INSERT INTO Realizacje VALUES (40,  1, 8);
INSERT INTO Realizacje VALUES (40,  2, 4);
INSERT INTO Realizacje VALUES (40,  3, 4);
INSERT INTO Realizacje VALUES (40,  9, 2);

------------ SELECT --------

SELECT * FROM Stanowiska;
SELECT * FROM Pracownicy;
SELECT * FROM Projekty;
SELECT * FROM Realizacje;

SELECT id,
       nazwa,
       stawka
FROM Projekty;

SELECT *
FROM Projekty;

SELECT *
FROM Pracownicy;

SELECT [Nazwa projektu] = nazwa,
       dataRozp         AS [Data rozpoczecia projektu], 
       dataZakonczPlan  [Planowana data zakonczenia],
       dataZakonczFakt  data_zakonczenia_faktycznego,
       kierownik        'Kierownik projektu',
       stawka           "Stawka w PLN"
FROM   Projekty;

SELECT [nazwa stanowiska] =nazwa,
       [płaca minimalna na stanowisku]= placa_min
FROM Stanowiska;

SELECT UPPER(nazwa) AS nazwa_projektu
FROM   Projekty;

SELECT  stanowisko,
        LEN(stanowisko) AS liczba_znaków
FROM Pracownicy;

SELECT nazwa, 
       stawka * 8 AS 'dniówka'
FROM   Projekty;
SELECT  nazwisko,
        placa * 12 AS 'placa roczna'
FROM Pracownicy;
SELECT YEAR(dataRozp) AS 'rok_rozp',
        dataRozp
FROM Projekty;

SELECT zatrudniony
FROM Pracownicy;
SELECT  nazwisko,
        DATEDIFF(MONTH, zatrudniony, '01-01-2019') AS 'mies_zatr'
FROM Pracownicy;
SELECT nazwisko, 
       ISNULL(dod_funkc, 0) AS dodatek
FROM   Pracownicy;
SELECT nazwisko, 
       ISNULL(dod_funkc, 8) AS 'dodatek'
FROM   Pracownicy;

SELECT nazwisko,
       (ISNULL(dod_funkc, 0) + placa)*12 AS roczne_wyn
FROM  Pracownicy;

SELECT nazwa,
       DATEDIFF(MONTH, dataRozp, ISNULL(dataZakonczFakt, GETDATE()))
FROM Projekty;

SELECT nazwisko,
       CAST(placa AS VARCHAR)  + ' zł'    AS placa_1,
       CONVERT(VARCHAR, placa) + ' zł'    AS placa_2,
       CONVERT(VARCHAR, zatrudniony, 103) AS data_zatrudnienia
FROM   Pracownicy;

SELECT DISTINCT
       kierownik
FROM Projekty;

SELECT nazwisko,
       placa
FROM   Pracownicy
ORDER BY placa;

SELECT nazwa,
       placa_min
FROM   Stanowiska
ORDER BY placa_min;

SELECT DISTINCT kierownik
FROM Projekty;

SELECT nazwa,
       placa_min
FROM Stanowiska
ORDER BY placa_min DESC ,nazwa DESC;

SELECT TOP 1 dataRozp,
            nazwa
FROM Projekty
ORDER BY dataRozp DESC;

SELECT nazwisko,
        placa,
        stanowisko
FROM Pracownicy
WHERE  (stanowisko='adiunkt' or stanowisko='doktorant')
        AND placa>1500;
SELECT nazwisko,
       placa,
       CASE WHEN placa > 2000
            THEN 'przyzwoite zarobki'
            ELSE 'dać dodatek socjalny'
       END AS 'jaka płaca?'
FROM   Pracownicy;

