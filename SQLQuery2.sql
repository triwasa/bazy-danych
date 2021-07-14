SELECT YEAR(GETDATE()) AS 'aktualny rok',
       2+3 AS 'suma',
       'el'+'ko' AS 'napis';


SELECT CONVERT(MONEY,2.00/4.00);


SELECT DISTINCT stanowisko
FROM Pracownicy;

SELECT DISTINCT kierownik
FROM Projekty;

SELECT   nazwisko,
         placa
FROM     Pracownicy
ORDER BY  placa DESC;

SELECT nazwa,placa_min
FROM Stanowiska
ORDER BY placa_min DESC,nazwa DESC 

SELECT   TOP 3 nazwisko,
         placa
FROM     Pracownicy
ORDER BY placa DESC;

SELECT TOP 1 nazwa,dataRozp,kierownik
FROM Projekty
ORDER BY dataRozp DESC;

SELECT *
FROM Pracownicy
WHERE stanowisko='adiunkt';

SELECT nazwisko,szef,dod_funkc
FROM Pracownicy
WHERE dod_funkc>100 AND (szef=1 OR szef=5);

SELECT nazwisko,placa
FROM Pracownicy
WHERE placa BETWEEN 1000 AND 2000
      AND nazwisko like '%i';

SELECT nazwa,dataRozp,kierownik
FROM Projekty
WHERE dataRozp>'2005-01-01' AND kierownik IN(4,5);

SELECT *
FROM Pracownicy
WHERE stanowisko IN('adiunkt','doktorant') AND placa>1500;

SELECT nazwa
FROM Projekty
WHERE nazwa LIKE '%web' OR nazwa LIKE'web%';



