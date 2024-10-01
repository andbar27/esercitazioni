-- 1. Quanti sono gli strutturati di ogni fascia?
SELECT p.posizione, COUNT(*) AS numeroStrutturati
FROM Persona p
GROUP BY p.posizione;


-- 2. Quanti sono gli strutturati con stipendio ≥ 40000?
SELECT count(*) as numeroStrutturati
FROM Persona p
WHERE p.stipendio >= '40000';



-- 3. Quanti sono i progetti già finiti 
--  che superano il budget di 50000?
SELECT count(*)
FROM Progetto p
WHERE p.fine <= CURRENT_DATE AND p.budget > 50000;


-- 4. Qual è la media, il massimo e il minimo delle ore delle 
--  attività relative al progetto ‘Pegasus’ ?
SELECT AVG(ap.oreDurata), MIN(ap.oreDurata), MAX(ap.oreDurata)
FROM Progetto p, AttivitaProgetto ap
WHERE p.nome = 'Pegasus' AND ap.progetto = p.id;



-- 5. Quali sono le medie, i massimi e i minimi delle ore 
--  giornaliere dedicate al progetto ‘Pegasus’ da ogni singolo docente?
SELECT ap.persona, pp.nome, pp.cognome, AVG(ap.oreDurata), 
    MIN(ap.oreDurata), MAX(ap.oreDurata)
FROM Progetto p, AttivitaProgetto ap, Persona pp
WHERE p.nome = 'Pegasus' AND ap.progetto = p.id 
    AND pp.id = ap.persona
GROUP BY ap.persona, pp.nome, pp.cognome
;



-- 6. Qual è il numero totale di ore dedicate alla didattica da ogni
--  docente?
SELECT p.id, p.nome, p.cognome, SUM(anp.oreDurata)
FROM AttivitaNonProgettuale anp, Persona p  
WHERE anp.persona = p.id AND anp.tipo = 'Didattica'
GROUP BY p.id 
;



-- 7. Qual è la media, il massimo e il minimo degli stipendi dei 
--  ricercatori?
SELECT AVG(p.stipendio), MAX(p.stipendio), MIN(p.stipendio)
FROM Persona p 
WHERE p.posizione = 'Ricercatore'
;


-- 8. Quali sono le medie, i massimi e i minimi degli stipendi dei 
--  ricercatori, dei professori associati e dei professori ordinari?
SELECT p.posizione, AVG(p.stipendio), MAX(p.stipendio), MIN(p.stipendio)
FROM Persona p 
GROUP BY p.posizione
;



-- 9. Quante ore ‘Ginevra Riva’ ha dedicato ad ogni progetto nel 
--  quale ha lavorato?
SELECT pp.nome, ap.id, SUM(ap.oreDurata)
FROM Persona p, AttivitaProgetto ap, Progetto pp
WHERE p.nome = 'Ginevra' AND p.cognome = 'Riva' 
    AND p.id = ap.persona AND ap.progetto = pp.id
GROUP BY ap.id
;


-- 10. Qual è il nome dei progetti su cui lavorano più di due 
--  strutturati?
SELECT p.id, p.nome
FROM Progetto p, AttivitaProgetto ap
WHERE p.id = ap.progetto
GROUP BY p.nome, p.id
HAVING COUNT(ap.persona) > 2


-- 11. Quali sono i professori associati che hanno lavorato su più 
--  di un progetto?
SELECT ap.persona, p.nome, p.cognome
FROM Persona p, AttivitaProgetto ap
WHERE ap.persona = p.id and p.posizione = 'Professore Associato'
GROUP BY ap.persona, p.nome, p.cognome
HAVING COUNT(ap.progetto) > 1
-- HAVING COUNT(ap.persona) > 1 funziona uguale non ho capito bene
-- uguale ad 10.