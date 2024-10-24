-- 1. Qual è la durata media, per ogni compagnia, dei voli che 
-- partono da un aeroporto situato in Italia?
SELECT ap.comp, AVG(v.durata)
FROM LuogoAeroporto la, ArrPart ap, Volo v
WHERE la.nazione = 'Italia' and ap.partenza = la.codice
    and v.codice = ap=codice and v.comp = ap.comp
GROUP BY ap.comp


-- 2. Quali sono le compagnie che operano voli con durata media 
-- maggiore della durata media di tutti i voli?
WITH DurataMediaVolo as (
    SELECT AVG(v.durataMinuti) as durataMedia
    FROM Volo v 
)
SELECT distinct v.comp, AVG(v.durataMinuti)
FROM Volo v, DurataMediaVolo dmv 
GROUP BY v.comp, dmv.durataMedia
HAVING AVG(v.durataMinuti) > dmv.durataMedia


-- 3. Quali sono le città dove il numero totale di voli in arrivo è 
-- maggiore del numero medio dei voli in arrivo per ogni città?
WITH ArriviXCitta AS (
    SELECT la.citta AS citta, COUNT(ap.codice) AS nArrivi
    FROM LuogoAeroporto la, ArrPart ap 
    WHERE la.aeroporto = ap.arrivo
    GROUP BY la.citta
),
ArriviMedi AS (
    SELECT AVG(ac.nArrivi) as arriviMedi 
    FROM ArriviXCitta ac 
)
SELECT axc.citta, axc.nArrivi
FROM ArriviMedi am, ArriviXCitta axc  
WHERE axc.nArrivi > am.ArriviMedi 


-- 4. Quali sono le compagnie aeree che hanno voli in partenza da 
-- aeroporti in Italia con una durata media inferiore alla durata 
-- media di tutti i voli in partenza da aeroporti in Italia?
WITH DurataMediaPartenzeItalia AS (
    SELECT AVG(v.durataMinuti) as avgArrIt
    FROM LuogoAeroporto la, ArrPart ap, Volo v  
    WHERE ap.partenza = la.aeroporto and la.nazione = 'Italy'
        and v.codice = ap.codice and v.comp = ap.comp
)
SELECT v.comp, dmai.avgArrIt
FROM DurataMediaPartenzeItalia dmai, 
    LuogoAeroporto la, ArrPart ap, Volo v 
WHERE la.nazione = 'Italy' and la.aeroporto = ap.partenza
    and v.codice = ap.codice and v.comp = ap.comp
GROUP BY v.comp, dmai.avgArrIt
HAVING AVG(v.durataMinuti) < dmai.avgArrIt



-- 5. Quali sono le città i cui voli in arrivo hanno una durata 
-- media che differisce di più di una deviazione standard dalla 
-- durata media di tutti i voli? Restituire città e durate medie 
-- dei voli in arrivo.
WITH DurataMediaVoli AS (
    SELECT AVG(v.durataMinuti) as dMedia, STDDEV(v.durataMinuti) as std 
    FROM Volo v 
), 
DurataMediaXCitta AS (
    SELECT AVG(v.durataMinuti)
    FROM Volo v, LuogoAeroporto la, ArrPart ap 
    WHERE v.codice = ap.codice and v.comp = ap.comp and 
        la.aeroporto = ap.arrivo
    GROUP BY la.citta
)
SELECT la.citta, avg(v.durataMinuti)
FROM Volo v, LuogoAeroporto la, ArrPart ap, DurataMediaVoli dmv 
WHERE v.codice = ap.codice and v.comp = ap.comp and 
    la.aeroporto = ap.arrivo 
GROUP BY la.citta, dmv.dMedia, dmv.std
HAVING AVG(v.durataMinuti) + dmv.std < dmv.dMedia or 
    AVG(v.durataMinuti) - dmv.std >= dmv.dMedia
-- media 405.9090909090909091
-- devstdd 222.393999265023
-- media - devstdd = 183 o meno di questo
-- media + devstdd = 628 o più di questo


-- 6. Quali sono le nazioni che hanno il maggior numero di città 
-- dalle quali partono voli diretti in altre nazioni?
SELECT distinct lac.nazione, COUNT(DISTINCT lac.citta)
FROM LuogoAeroporto lac, LuogoAeroporto lan, ArrPart ap  
WHERE ap.partenza = lac.aeroporto and ap.arrivo = lan.aeroporto
    and lac.nazione <> lan.nazione
GROUP BY lac.nazione