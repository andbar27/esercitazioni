-- 1. Qual è la durata media, per ogni compagnia, dei voli che 
-- partono da un aeroporto situato in Italia?
SELECT ap.comp, AVG(v.durata)
FROM LuogoAeroporto la, ArrPart ap, Volo v
WHERE la.nazione = 'Italia' and ap.partenza = la.codice
    and v.codice = ap=codice and v.comp = ap.comp
GROUP BY ap.comp


-- 2. Quali sono le compagnie che operano voli con durata media 
-- maggiore della durata media di tutti i voli?
SELECT
FROM
WHERE


-- 3. Quali sono le città dove il numero totale di voli in arrivo è 
-- maggiore del numero medio dei voli in arrivo per ogni città?



-- 4. Quali sono le compagnie aeree che hanno voli in partenza da 
-- aeroporti in Italia con una durata media inferiore alla durata media di tutti i voli in partenza da aeroporti
-- in Italia?


-- 5. Quali sono le città i cui voli in arrivo hanno una durata 
-- media che differisce di più di una deviazione standard dalla 
-- durata media di tutti i voli? Restituire città e durate medie 
-- dei voli in arrivo.


-- 6. Quali sono le nazioni che hanno il maggior numero di città 
-- dalle quali partono voli diretti in altre nazioni?