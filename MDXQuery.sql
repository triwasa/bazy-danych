--Zadanie 1
SELECT {([Measures].[Obrot]), ([Measures].[Ilosc])} ON COLUMNS,
       {[Dim Regiony].[Region].[All], [Dim Regiony].[Region].[Region]} ON ROWS
FROM [FraniaCube]
WHERE {([Dim Towary].[Podgrupa].&[okapy], [Dim Czas].[Hierarchy].[Rok].&[2006].&[2])};

--Zadanie 2
SELECT {([Measures].[Ilosc]), ([Measures].[Sprzedaz Hist Count])} ON COLUMNS,
	   {([Dim Regiony].[Region].[Region], [Dim Towary].[Towar].[Towar])} ON ROWS
FROM [FraniaCube]
WHERE {([Dim Towary].[Podgrupa].&[okapy], [Dim Czas].[Rok].&[2006])};

--Zadanie 3
SELECT {[Dim Towary].[Towar].[Towar]} ON COLUMNS,
	   {[Dim Regiony].[Region].[Region]} ON ROWS
FROM [FraniaCube]
WHERE {([Dim Towary].[Podgrupa].&[okapy], [Dim Czas].[Rok].&[2006], [Measures].[Ilosc])};

--Zadanie 4
SELECT {[Dim Czas].[Miesiac].[Miesiac]} ON COLUMNS,
	   {[Dim Towary].[Hierarchy].[Podgrupa Hierarchia].&[okapy BI].CHILDREN} ON ROWS
FROM [FraniaCube]
WHERE {([Measures].[Ilosc], [Dim Czas].[Hierarchy].[Rok].&[2006].&[1].&[1]:[Dim Czas].[Hierarchy].[Rok].&[2006].&[2].&[4])};

--Zadanie 5
SELECT {[Measures].[Ilosc]} ON COLUMNS,
        ORDER ({NONEMPTYCROSSJOIN([Dim Towary].[Grupa].[Grupa], [Dim Regiony].[Region].[Region])} , [Measures].[Ilosc] , DESC ) ON ROWS
FROM   [FraniaCube]
WHERE  ([Dim Towary].[Podgrupa].&[zmywarki], [Dim Czas].[Rok].&[2007]);

--Zadanie 6
WITH SET [ZbiorKlienci] AS '{[Dim Klienci].[Klient].&[AVANS], [Dim Klienci].[Klient].&[MEDIA MARKT]}'
     MEMBER [Dim Klienci].[Klient].[Zagregowane] AS AGGREGATE([ZbiorKlienci])
SELECT  {[Measures].[Wartosc Hist]} ON COLUMNS,
        {([ZbiorKlienci]), ([Dim Klienci].[Klient].[Zagregowane])} ON ROWS
FROM  [FraniaCube];

--Przykład AGGREGATE
WITH 
    SET [Wszystkie lata] AS '{[Dim Czas].[Hierarchy].[Rok].&[2004]:[Dim Czas].[Hierarchy].[Rok].&[2007]}'
    MEMBER [Dim Czas].[Hierarchy].[razem] AS 'Aggregate([Wszystkie lata])'
SELECT {[Measures].[Cena], [Measures].[Ilosc], [Measures].[Obrot]} ON COLUMNS,
        {([Wszystkie lata]),([Dim Czas].[Hierarchy].[razem])} ON ROWS
FROM [FraniaCube];

--Zadanie 7
WITH MEMBER [Measures].[Max_ilosc] AS MAX([Dim Regiony].[Region].[Region], [Measures].[Ilosc])
SELECT  {[Measures].[Ilosc]} ON COLUMNS,
        {([Dim Towary].[Grupa].[Grupa], FILTER([Dim Regiony].[Region].[Region], [Measures].[Ilosc]=[Measures].[Max_ilosc]))} ON ROWS
FROM [FraniaCube]
WHERE {([Dim Czas].[Rok].&[2007],[Dim Towary].[Podgrupa].&[zmywarki])};

--Zadanie 8
WITH MEMBER [Measures].[UdzialRynek] AS  ([Measures].[Obrot]) / ([Measures].[Obrot], [Dim Towary].[Podgrupa].[All]), FORMAT = '#.00%'
SELECT  {[Measures].[UdzialRynek]} ON COLUMNS,
        {[Dim Towary].[Podgrupa].[Podgrupa]} ON ROWS
FROM   [FraniaCube];

--Zadanie 9
WITH 
    MEMBER [Podgr] AS '[Dim Towary].[Hierarchy].Parent.Name'
	MEMBER [Gr] AS '[Dim Towary].[Hierarchy].Parent.Parent.Name'
SELECT {([Podgr]),([Gr])} ON COLUMNS,
      [Dim Towary].[Hierarchy].[Towar Hierarchia].Members ON ROWS
FROM [FraniaCube];

--Zadanie 10
WITH
	MEMBER [UdzialPodgrupa] AS ([Measures].[Obrot]) / ([Measures].[Obrot], [Dim Towary].[Hierarchy].Parent), FORMAT = '#0.00%'
	MEMBER [UdzialGrupa] AS ([Measures].[Obrot]) / ([Measures].[Obrot], [Dim Towary].[Hierarchy].Parent.Parent), FORMAT = '#0.00%'
	MEMBER [UdzialRynek] AS ([Measures].[Obrot]) / ([Measures].[Obrot], [Dim Towary].[Hierarchy].[All]), FORMAT = '#0.00%'
SELECT {([UdzialPodgrupa]),([UdzialGrupa]),([UdzialRynek])} ON COLUMNS,
		[Dim Towary].[Hierarchy].[Towar Hierarchia].Members ON ROWS
FROM [FraniaCube];

--Zadanie 11
WITH SET [Najlepsi] AS 'TOPCOUNT([Dim Regiony].[Region].[Region], 3, [Measures].[Ilosc])'
     SET [Reszta] AS 'EXCEPT([Dim Regiony].[Region].[Region], [Najlepsi])'
     MEMBER [Dim Regiony].[Region].[Najlepsi-suma] AS 'SUM([Najlepsi])'
     MEMBER [Dim Regiony].[Region].[Reszta-suma] AS 'SUM([Reszta])'
SELECT  [Measures].[Ilosc] ON COLUMNS,
        {([Dim Regiony].[Region].[Region]), ([Dim Regiony].[Region].[Najlepsi-suma]), ([Dim Regiony].[Region].[Reszta-suma])} ON ROWS
FROM  [FraniaCube];

--Zadanie 12
WITH
	MEMBER [Akumulacja] AS SUM(YTD(), [Measures].[Ilosc])
SELECT {[Measures].[Ilosc], [Akumulacja]} ON COLUMNS,
		DESCENDANTS([Dim Czas].[Hierarchy].[Rok].&[2006], 2) ON ROWS
FROM [FraniaCube]
WHERE {([Dim Towary].[Towar].&[lodowki dwudrzwiowe]),([Dim Towary].[Towar].&[lodowki kombi])};

--Zadanie 13 dla wszystkich lat (tak żeby wynik zgadzał się z moodlem)
WITH 
	MEMBER [Skok] AS 'IIF(ISEMPTY(([Measures].[Obrot], [Dim Czas].[Kwartal].PrevMember)), "-",
					  IIF(([Measures].[Obrot], [Dim Czas].[Kwartal].CurrentMember) > ([Measures].[Obrot], [Dim Czas].[Kwartal].PrevMember), "wzrost" , "spadek"))' 
SELECT {([Measures].[Obrot]), ([Skok])} ON COLUMNS,
       {([Dim Regiony].[Region].[Region], [Dim Czas].[Kwartal].[Kwartal])} ON ROWS
FROM [FraniaCube];

--Zadanie 13 dla 2007 (tak żeby było zgodnie z poleceniem)
WITH 
	MEMBER [Skok] AS 'IIF(ISEMPTY(([Measures].[Obrot], [Dim Czas].[Kwartal].PrevMember)), "-",
					  IIF(([Measures].[Obrot], [Dim Czas].[Kwartal].CurrentMember) > ([Measures].[Obrot], [Dim Czas].[Kwartal].PrevMember), "wzrost" , "spadek"))' 
SELECT {([Measures].[Obrot]), ([Skok])} ON COLUMNS,
       {NONEMPTYCROSSJOIN([Dim Regiony].[Region].[Region], DESCENDANTS([Dim Czas].[Hierarchy].[Rok].&[2007], 1))} ON ROWS
FROM [FraniaCube];
