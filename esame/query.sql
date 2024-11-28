-- QUERY 1. Quali sono gli aeroporti (restituire codice e nome) della
-- città di Roma [2 punti]
SELECT a.codice, a.nome
FROM Aeroporto a, LuogoAeroporto la 
WHERE a.codice = la.aeroporto and la.citta = 'Roma';


-- QUERY 2. Quali sono le compagnie (restituire nome e anno di
-- fondazione) che hanno voli di durata di almeno 3 ore [3
-- punti]
SELECT DISTINCT c.nome, c.annoFondaz
FROM Compagnia c, Volo v
WHERE c.nome = v.comp AND v.durataMinuti >= 180;

-- QUERY 3. Qual è la durata più lunga di un volo di ogni compagnia
-- (restituire nome della compagnia e durata di tale volo) [3
-- punti]
SELECT v.comp, MAX(durataMinuti)
FROM Volo v 
GROUP BY v.comp;

-- QUERY 4. Quali sono le compagnie che hanno voli che atterrano in
-- un qualche aeroporto di New York [3 punti]
SELECT DISTINCT a.comp
FROM ArrPart a, LuogoAeroporto la
WHERE a.arrivo = la.aeroporto and la.citta = 'New York';

-- QUERY 5. Quali sono i piani di volo con un cambio che collegano
-- Roma a New York in al più 6 ore (escludendo il tempo del
-- cambio) [4 punti]
WITH SecondoVolo AS(
    SELECT ap.partenza as partenzaS, v.durataMinuti as durataS, v.* as voloS, ap.* as apS
    FROM ArrPart ap, LuogoAeroporto laa, Volo v
    WHERE ap.arrivo = laa.aeroporto and laa.citta = 'New York' and
        ap.codice = v.codice and ap.comp = v.comp
) 
SELECT v.*, ap.*, sv.*
FROM SecondoVolo sv, ArrPart ap, LuogoAeroporto lap, Volo v 
WHERE sv.partenzaS = ap.arrivo and lap.citta = 'Roma' and lap.aeroporto = ap.partenza
    and v.codice = ap.codice and v.comp = ap.comp 
    and (sv.durataS + v.durataMinuti) <= (6*60);
    


-- QUERY 6. Quanti sono, per ogni compagnia, i piani di volo con un
-- cambio (con entrambi i voli di quella compagnia) che
-- collegano Roma a New York in al più 6 ore [4 punti]
WITH SecondoVolo AS(
    SELECT ap.partenza as partenzaS, v.durataMinuti as durataS, v.comp as compS
    FROM ArrPart ap, LuogoAeroporto laa, Volo v
    WHERE ap.arrivo = laa.aeroporto and laa.citta = 'New York' and
        ap.codice = v.codice and ap.comp = v.comp
) 
SELECT v.comp, COUNT(*)
FROM SecondoVolo sv, ArrPart ap, LuogoAeroporto lap, Volo v 
WHERE sv.partenzaS = ap.arrivo and lap.citta = 'Roma' and lap.aeroporto = ap.partenza
    and v.codice = ap.codice and v.comp = ap.comp and sv.compS = v.comp
    and (sv.durataS + v.durataMinuti) <= (6*60)
GROUP BY v.comp


-- QUERY 7. Quali sono i piani di volo con un cambio in Germania che
-- collegano Roma a New York in al più 6 ore di volo
-- (escludendo il tempo di cambio in Germania). Ordinare i
-- voli per durata di volo complessiva (escludendo il tempo di
-- cambio) crescente [4 punti]
WITH SecondoVolo AS(
    SELECT ap.partenza as partenzaS, v.durataMinuti as durataS, v.* as voloS, ap.* as apS
    FROM ArrPart ap, LuogoAeroporto laa, Volo v, LuogoAeroporto lap
    WHERE ap.arrivo = laa.aeroporto and laa.citta = 'New York' and
        ap.codice = v.codice and ap.comp = v.comp and lap.nazione = 'Germany' and
        ap.partenza = lap.aeroporto
) 
SELECT v.*, ap.*, sv.*
FROM SecondoVolo sv, ArrPart ap, LuogoAeroporto lap, Volo v 
WHERE sv.partenzaS = ap.arrivo and lap.citta = 'Roma' and lap.aeroporto = ap.partenza
    and v.codice = ap.codice and v.comp = ap.comp 
    and (sv.durataS + v.durataMinuti) <= (6*60)
ORDER BY (sv.durataS + v.durataMinuti);



-- QUERY 8. Qual è l’anno nel quale è stata fondata la prima
-- compagnia aerea presente nel db [2 punti]
SELECT MIN(c.annoFondaz)
FROM Compagnia c;

-- QUERY 9. Quante sono le compagnie aeree di cui non si conosce
-- l’anno di fondazione [2 punti]
SELECT COUNT(*)
FROM Compagnia c
WHERE c.annoFondaz IS NOT NULL;

-- QUERY 10. Quante sono le compagnie aeree fondate ogni anno. Per
-- ogni anno nel quale è stata fondata almeno una
-- compagnia, restituire l’anno e il numero di compagnie
-- fondate in quell’anno [3 punti]
SELECT c.annoFondaz, COUNT(c.nome)
FROM Compagnia c
WHERE c.annoFondaz IS NOT NULL
GROUP BY c.annoFondaz;