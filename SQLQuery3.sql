WITH CTE_Frania AS
    (SELECT Dim_Czas.rok, Dim_Towary.Podgrupa, Sprzedaz_hist.Obrot
     FROM Sprzedaz_hist
         JOIN Dim_Towary ON Sprzedaz_hist.IdTowary = Dim_Towary.id
         JOIN Dim_Czas ON Sprzedaz_hist.IdCzas = Dim_Czas.id)
SELECT Obrot
FROM CTE_Frania
WHERE rok = 2005
    AND Podgrupa = 'pralki'

	SELECT  rok, kwartal,
        COUNT(*) as [ile wypłat], 
        AVG(pensja) as [srednia wyplat]
FROM   Wyplaty
WHERE  pracownik = 'Monika'
GROUP BY CUBE (rok, kwartal);
---2---
WITH CTE_Frania AS
    (SELECT T.Towar , R.Region , Sum(H.Ilosc) AS 'ilosc' 
     FROM Sprzedaz_hist H
         JOIN Dim_Towary T ON H.IdTowary = T.Id
         JOIN Dim_Czas C ON H.IdCzas = C.id
		 JOIN Dim_Regiony R ON H.IdRegion = R.Id
		 WHERE Podgrupa = 'okapy'
		 AND Rok = '2006'
		 GROUP BY CUBE(Region,Towar))
SELECT Region, "okapy kominowe", "okapy teleskopowe", "okapy kominowe", "okapy uniwersalne"
FROM CTE_Frania
PIVOT( SUM("ilosc") FOR Towar In ("okapy teleskopowe", "okapy meblowe", "okapy kominowe", "okapy uniwersalne")) AS p

---1---

WITH CTE_Frania AS
    (SELECT T.Towar , R.Region , Sum(Hs.Ilosc) AS 'ilosc' 
     FROM Sprzedaz_hist Hs
         JOIN Dim_Towary T ON Hs.IdTowary = T.Id
         JOIN Dim_Czas C ON Hs.IdCzas = C.id
		 JOIN Dim_Regiony R ON Hs.IdRegion = R.Id
		 WHERE Podgrupa = 'okapy'
		 AND Rok = '2006'
		 GROUP BY CUBE(Region,Towar))
SELECT ilosc, Towar, Region
FROM CTE_Frania


---3---

WITH CT AS 
	(SELECT R.Region, Hs.Ilosc
	FROM Sprzedaz_hist Hs
	Join Dim_Czas C ON Hs.IdCzas = C.Id
	Join Dim_Regiony R ON Hs.IdRegion = R.Id
	WHERE (C.Rok = '2007' AND C.Miesiac < '5'))
	SELECT SUM(Ilosc) FROM CT GROUP BY(Dim_Regiony.Region)
