-- 1. Quante sono le compagnie che operano (sia in arrivo che in 
-- partenza) nei diversi aeroporti?
SELECT a.codice, a.nome, COUNT(distinct ap.comp)
FROM ArrPart ap, Aeroporto a, ArrPart ap2
WHERE ap.arrivo = a.codice and ap2.partenza = a.codice 
    and ap2.comp = ap.comp
GROUP BY a.codice, a.nome
	

-- 2. Quanti sono i voli che partono dall’aeroporto ‘HTR’ e hanno 
-- una durata di almeno 100 minuti?
SELECT COUNT(*)
FROM Volo v, ArrPart ap, 
WHERE v.codice = ap.codice and v.comp = ap.comp 
    and ap.partenza= 'HTR' and v.durata >= 100



-- 3. Quanti sono gli aeroporti sui quali opera la compagnia 
-- ‘Apitalia’, per ogni nazione nella quale opera?
SELECT la.nazione, COUNT(distinct la.aeroporto)
FROM ArrPart ap, LuogoAeroporto la  
WHERE ap.comp = 'Apitalia' 
    and (ap.arrivo = la.aeroporto or ap.partenza = la.aeroporto)
GROUP BY la.nazione


-- 4. Qual è la media, il massimo e il minimo della durata dei voli 
-- effettuati dalla compagnia ‘MagicFly’ ?
SELECT AVG(v.durataMinuti), MAX(v.durataMinuti), MIN(v.durataMinuti)
FROM Volo v 
WHERE v.comp = 'MagicFly' 


-- 5. Qual è l’anno di fondazione della compagnia più vecchia che 
-- opera in ognuno degli aeroporti?
SELECT a.codice, a.nome, MIN(c.annoFondaz)
FROM Compagnia c, ArrPart ap, Aeroporto a 
WHERE c.nome = ap.comp 
	and (a.codice = ap.arrivo or a.codice = ap.partenza)
GROUP BY a.codice, a.nome 

-- Con nome compagnia
WITH AnnoMinFond as (
	SELECT a.codice as aer, MIN(c.annoFondaz) as anno
	FROM Compagnia c, ArrPart ap, Aeroporto a 
	WHERE c.nome = ap.comp 
	    and (a.codice = ap.arrivo or a.codice = ap.partenza)
	GROUP BY a.codice 
)
SELECT amf.aer, c.nome, c.annoFondaz
FROM AnnoMinFond amf, Aeroporto a, Compagnia c
WHERE amf.aer = a.codice and amf.anno = c.annoFondaz


-- 6. Quante sono le nazioni (diverse) raggiungibili da ogni nazione
-- tramite uno o più voli?
SELECT la1.nazione, COUNT(distinct la2.nazione)
FROM LuogoAeroporto la1, ArrPart ap1, LuogoAeroporto la2  
WHERE ap1.partenza = la1.aeroporto  and ap1.arrivo = la2.aeroporto
	and la1.nazione <> la2.nazione
GROUP BY la1.nazione


-- 7. Qual è la durata media dei voli che partono da ognuno degli 
-- aeroporti?
SELECT a.codice, a.nome, AVG(v.durataMinuti)
FROM Volo v, ArrPart ap, Aeroporto a 
WHERE v.comp = ap.comp and v.codice = ap.codice
	and (a.codice = ap.partenza)
GROUP BY a.codice, a.nome 


-- 8. Qual è la durata complessiva dei voli operati da ognuna delle 
-- compagnie fondate a partire dal 1950?
SELECT c.nome, SUM(v.durataMinuti)
FROM Compagnia c, Volo v 
WHERE c.nome = v.comp and c.annoFondaz >= 1950
GROUP BY c.nome



-- 9. Quali sono gli aeroporti nei quali operano esattamente due 
-- compagnie?
SELECT a.codice, a.nome
FROM ArrPart ap, Aeroporto a 
WHERE ap.arrivo = a.codice or ap.partenza = a.codice
GROUP BY a.codice
HAVING COUNT(distinct ap.comp) = 2


-- 10. Quali sono le città con almeno due aeroporti?
SELECT la.citta, COUNT(distinct la.aeroporto)
FROM LuogoAeroporto la 
GROUP BY la.citta 
HAVING COUNT(distinct la.aeroporto) > 1

--Conta solo due (sbagliato)
SELECT distinct la.citta
FROM LuogoAeroporto la, LuogoAeroporto la1 
WHERE la.aeroporto <> la1.aeroporto and la.citta = la1.citta


-- 11. Qual è il nome delle compagnie i cui voli hanno una durata 
-- media maggiore di 6 ore?
SELECT v.comp
FROM Volo v 
GROUP BY v.comp
HAVING AVG(v.durataMinuti) > 6*60


-- 12. Qual è il nome delle compagnie i cui voli hanno tutti una 
-- durata maggiore di 100 minuti?
SELECT v.comp
FROM Volo v 
GROUP BY v.comp
HAVING MIN(v.durataMinuti) > 100
