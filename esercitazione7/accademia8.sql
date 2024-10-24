-- 1. Quali sono le persone (id, nome e cognome) che hanno avuto 
-- assenze solo nei giorni in cui non avevano alcuna attivitÃ 
-- (progettuali o non progettuali)?
SELECT distinct p.id, p.nome, p.cognome
FROM AttivitaNonProgettuale anp right outer join (Assenza a left outer join AttivitaProgetto ap 
    on a.persona = ap.persona and a.giorno = ap.giorno) on anp.persona = a.persona and anp.giorno = a.giorno,
    Persona p
WHERE anp.giorno IS NULL and ap.giorno IS NULL and p.id = a.persona


-- 2. Quali sono le persone (id, nome e cognome) che non hanno mai 
-- partecipato ad alcun progetto durante la durata del progetto 
-- “Pegasus”?
WITH PersoneLavDurPeg as (
    SELECT DISTINCT ap.persona as pers
    FROM Progetto pgs, AttivitaProgetto ap 
    WHERE pgs.nome = 'Pegasus' and ap.giorno >= pgs.inizio 
        and ap.giorno <= pgs.fine
)
SELECT p.id, p.nome, p.cognome
FROM Persona p left outer join PersoneLavDurPeg plp on p.id =plp.pers
WHERE plp.pers IS NULL


-- 3. Quali sono id, nome, cognome e stipendio dei ricercatori con 
-- stipendio maggiore di tutti i professori (associati e ordinari)?
WITH StipendioMaxProf as (
    SELECT MAX(p.stipendio) as stip_max
    FROM Persona p  
    WHERE p.posizione in ('Professore Associato', 'Professore Ordinario')
)
SELECT p.id, p.nome, p.cognome
FROM Persona p, StipendioMaxProf smp 
WHERE p.stipendio > smp.stip_max
ORDER BY p.id ASC 

-- 4. Quali sono le persone che hanno lavorato su progetti con un 
-- budget superiore alla media dei budget di tutti i progetti?



-- 5. Quali sono i progetti con un budget inferiore allala media, 
-- ma con un numero complessivo di ore dedicate alle attività di 
-- ricerca sopra la media?