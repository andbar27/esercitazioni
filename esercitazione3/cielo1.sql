-- 1. Quali sono i voli (codice e nome della compagnia) la cui durata supera le 3 ore?
select codice, comp
from Volo 
where durataMinuti > 180;

-- 2. Quali sono le compagnie che hanno voli che superano le 3 ore?
select distinct comp
from Volo 
where durataMinuti > 180;

-- 3. Quali sono i voli (codice e nome della compagnia) che partono dall’aeroporto con
-- codice ‘CIA’ ?
select v.codice, v.comp
from Volo v, ArrPArt ap
where v.codice = ap.codice and v.comp = ap.comp 
	and ap.partenza = 'CIA';

-- 4. Quali sono le compagnie che hanno voli che arrivano all’aeroporto con codice
-- ‘FCO’ ?
select distinct v.comp
from Volo v, ArrPArt ap
where v.codice = ap.codice and v.comp = ap.comp 
	and ap.arrivo = 'FCO';


-- 5. Quali sono i voli (codice e nome della compagnia) che partono dall’aeroporto ‘FCO’
-- e arrivano all’aeroporto ‘JFK’ ?
select distinct v.codice, v.comp
from Volo v, ArrPArt ap
where v.codice = ap.codice and v.comp = ap.comp 
	and ap.arrivo = 'JFK' and ap.partenza = 'FCO';


-- 6. Quali sono le compagnie che hanno voli che partono dall’aeroporto ‘FCO’ e atter-
-- rano all’aeroporto ‘JFK’ ?
select distinct v.comp
from Volo v, ArrPArt ap
where v.codice = ap.codice and v.comp = ap.comp 
	and ap.arrivo = 'JFK' and ap.partenza = 'FCO';

-- 7. Quali sono i nomi delle compagnie che hanno voli diretti dalla città di ‘Roma’ alla
-- città di ‘New York’ ?
select distinct v.comp
from Volo v, ArrPart ap, 
	LuogoAeroporto lap, LuogoAeroporto laa
where v.codice = ap.codice and v.comp = ap.comp and 
	(ap.arrivo = laa.aeroporto and laa.citta = 'Roma'
	and ap.partenza = lap.aeroporto and lap.citta = 'New York')
	or 
	(ap.arrivo = laa.aeroporto and laa.citta = 'New York'
	and ap.partenza = lap.aeroporto and lap.citta = 'Roma');    


-- 8. Quali sono gli aeroporti (con codice IATA, nome e luogo) nei quali partono voli
-- della compagnia di nome ‘MagicFly’ ?
select distinct a.codice, a.nome, la.citta 
from ArrPart ap, Aeroporto a, LuogoAeroporto la
where ap.partenza = a.codice and ap.comp = 'MagicFly'
	and la.aeroporto = a.codice;


-- 9. Quali sono i voli che partono da un qualunque aeroporto della città di ‘Roma’ e
-- atterrano ad un qualunque aeroporto della città di ‘New York’ ? Restituire: codice
-- del volo, nome della compagnia, e aeroporti di partenza e arrivo.
select distinct v.codice, v.comp, app.nome, aa.nome
from Volo v, ArrPart ap, 
	LuogoAeroporto lap, LuogoAeroporto laa,
	Aeroporto aa, Aeroporto app
where v.codice = ap.codice and v.comp = ap.comp 
	and lap.aeroporto = app.codice
	and laa.aeroporto = aa.codice
	and ap.arrivo = laa.aeroporto and laa.citta = 'New York'
	and ap.partenza = lap.aeroporto and lap.citta = 'Roma';


-- DA FINIREEEE
-- 10. Quali sono i possibili piani di volo con esattamente un cambio (utilizzando solo
-- voli della stessa compagnia) da un qualunque aeroporto della città di ‘Roma’ ad un
-- qualunque aeroporto della città di ‘New York’ ? Restituire: nome della compagnia,
-- codici dei voli, e aeroporti di partenza, scalo e arrivo
select ap1.comp, scalo.vcode, scalo.apar, ap1.partenza, ap1.codice, ap1.arrivo
from ArrPart ap1, LuogoAeroporto a1,
	(select distinct aa.codice, laa.citta, ap.comp, v.codice as vcode, ap.partenza as apar
	from Volo v, ArrPart ap, 
		LuogoAeroporto lap, LuogoAeroporto laa,
		Aeroporto aa, Aeroporto app
	where v.codice = ap.codice and v.comp = ap.comp 
		and lap.aeroporto = app.codice
		and laa.aeroporto = aa.codice
		and ap.arrivo = laa.aeroporto and laa.citta <> 'New York'
		and ap.partenza = lap.aeroporto and lap.citta = 'Roma') as scalo
where ap1.comp = scalo.comp and ap1.partenza = scalo.codice and ap1.arrivo = a1.aeroporto
	and a1.citta = 'New York' 



-- 11. Quali sono le compagnie che hanno voli che partono dall’aeroporto ‘FCO’, atter-
-- rano all’aeroporto ‘JFK’, e di cui si conosce l’anno di fondazione?
select distinct v.comp
from Volo v, ArrPart ap, 
	LuogoAeroporto lap, LuogoAeroporto laa, Compagnia c
where v.codice = ap.codice and v.comp = ap.comp and 
	ap.arrivo = laa.aeroporto and laa.citta = 'New York'
	and ap.partenza = lap.aeroporto and lap.citta = 'Roma'
	and c.nome = v.comp and c.annoFondaz is not NULL;    
