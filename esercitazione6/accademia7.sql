-- 1. Qual è media e deviazione standard degli stipendi per 
-- ogni categoria di strutturati?
SELECT p.posizione, avg(p.stipendio), stddev(p.stipendio)
FROM Persona p
GROUP BY p.posizione


-- 2. Quali sono i ricercatori (tutti gli attributi) con uno 
-- stipendio superiore alla media della loro categoria?
WITH mediaStipRic as (
    SELECT avg(p.stipendio) as stip_medio
    FROM Persona p
    WHERE p.posizione = 'Ricercatore'
    GROUP BY p.posizione
)
SELECT *
FROM Persona p, mediaStipRic m 
WHERE p.posizione = 'Ricercatore' and p.stipendio > m.stip_medio


-- 3. Per ogni categoria di strutturati quante sono le persone con 
-- uno stipendio che differisce di al massimo una deviazione standard 
-- dalla media della loro categoria?
WITH MediaStipendi as (
    SELECT p.posizione as posStrut, avg(p.stipendio) as stip_medio,
        stddev(p.stipendio) as dev_stip
    FROM Persona p
    GROUP BY p.posizione
)
SELECT p.posizione, COUNT(*)
FROM Persona p, MediaStipendi m 
WHERE p.posizione = m.posStrut 
    and p.stipendio >= m.stip_medio - dev_stip 
    and p.stipendio <= m.stip_medio + dev_stip
GROUP BY p.posizione


-- 4. Chi sono gli strutturati che hanno lavorato almeno 20 ore 
-- complessive in attività progettuali? Restituire tutti i loro dati 
-- e il numero di ore lavorate.
SELECT p.*, sum(o.oreDurata)
FROM Persona p, AttivitaProgetto o 
WHERE p.id = o.persona
GROUP BY p.id, p.nome, p.cognome, p.posizione, p.stipendio
HAVING sum(o.oreDurata) >= 20



-- 5. Quali sono i progetti la cui durata è superiore alla media 
-- delle durate di tutti i progetti? Restituire nome dei progetti e 
-- loro durata in giorni.
WITH MediaGiorniProg as (
    SELECT avg(p.fine - p.inizio) as media 
    FROM Progetto p 
)
SELECT p.nome, p.fine - p.inizio
FROM Progetto p, MediaGiorniProg m 
WHERE p.fine - p.inizio > m.media 


-- 6. Quali sono i progetti terminati in data odierna che hanno avuto 
-- attività di tipo “Dimostrazione”? Restituire nome di ogni progetto 
-- e il numero complessivo delle ore dedicate a tali attività nel 
-- progetto.
SELECT p.nome, sum(ap.oreDurata)
FROM AttivitaProgetto ap, Progetto p 
WHERE ap.tipo = 'Dimostrazione' and p.id = ap.progetto 
    and p.fine <= CURRENT_DATE
GROUP BY p.nome


-- 7. Quali sono i professori ordinari che hanno fatto più assenze 
-- per malattia del numero di assenze medio per malattia dei 
-- professori associati? Restituire id, nome e cognome del 
-- professore e il numero di giorni di assenza per malattia.
WITH nAssenzePA as (
	SELECT p.id as pid, count(p.id) as nAs
	FROM Persona p, Assenza a 
	WHERE p.id = a.persona and p.posizione = 'Professore Associato'
	    and a.tipo = 'Malattia'
	GROUP BY p.id
)
SELECT p.id, p.nome as nome,
	p.cognome as cognome,  count(p.id) as nAssenze
FROM Persona p, Assenza a, nAssenzePA naa
WHERE p.id = a.persona and p.posizione = 'Professore Ordinario'
	and a.tipo = 'Malattia' 
GROUP BY p.id, p.nome, p.cognome
HAVING count(p.id) > avg(nAs)


	















