-- 1. Quali sono il nome, la data di inizio e la data di fine dei WP del progetto di nome 
-- ‘Pegasus’ ?
select WP.id, WP.inizio, WP.fine
from WP, Progetto
where WP.progetto = Progetto.id and Progetto.nome = 'Pegasus'; 

-- 2. Quali sono il nome, il cognome e la posizione degli strutturati che hanno almeno
-- una attività nel progetto ‘Pegasus’, ordinati per cognome decrescente?
select distinct p.id, p.nome, p.cognome, p.posizione
from Persona p, Progetto pg, AttivitaProgetto ap
where pg.id = ap.progetto and p.id = ap.persona and pg.nome = 'Pegasus'
order by cognome desc;

-- 3. Quali sono il nome, il cognome e la posizione degli strutturati che hanno più di
-- una attività nel progetto ‘Pegasus’ ?
select distinct p.id, p.nome, p.cognome
from
	(select p.id as pers, ap.id as apid
	from Persona p, Progetto pg, AttivitaProgetto ap
	where pg.id = ap.progetto and p.id = ap.persona 
		and pg.nome = 'Pegasus') as p1, 
	(select p.id as pers, ap.id as apid
	from Persona p, Progetto pg, AttivitaProgetto ap
	where pg.id = ap.progetto and p.id = ap.persona 
		and pg.nome = 'Pegasus') as p2,
	Persona p
where p1.pers = p2.pers and p1.apid <> p2.apid 
	and p.id = p1.pers;


-- 4. Quali sono il nome, il cognome e la posizione dei Professori Ordinari che hanno
-- fatto almeno una assenza per malattia?
select distinct p.id, p.nome, p.cognome
from Persona p, Assenza a
where a.persona = p.id 
	and p.posizione = 'Professore Ordinario'
	and a.tipo = 'Malattia';


-- 5. Quali sono il nome, il cognome e la posizione dei Professori Ordinari che hanno
-- fatto almeno una assenza per malattia?
select distinct p.id, p.nome, p.cognome
from Persona p, Assenza a, Persona p1, Assenza a1
where a.persona = p.id 
	and p.posizione = 'Professore Ordinario'
	and a.tipo = 'Malattia'
	and a1.tipo = 'Malattia'
	and a1.persona = p1.id 
	and p1.posizione = 'Professore Ordinario'
	and p1.id = p.id and a.id <> a1.id;

-- 6. Quali sono il nome, il cognome e la posizione dei Ricercatori che hanno almeno
-- un impegno per didattica?
select distinct p.id, p.nome, p.cognome
from Persona p, AttivitaNonProgettuale a
where p.id = a.persona
	and a.tipo = 'Didattica'
	and p.posizione = 'Ricercatore';


-- 7. Quali sono il nome, il cognome e la posizione dei Ricercatori che hanno più di un
-- impegno per didattica?
select distinct p.id, p.nome, p.cognome
from Persona p, AttivitaNonProgettuale a, 
	Persona p1, AttivitaNonProgettuale a1
where p.id = a.persona
	and a.tipo = 'Didattica'
	and p.posizione = 'Ricercatore'
	and p1.id = a1.persona
	and a1.tipo = 'Didattica'
	and p1.posizione = 'Ricercatore'
	and p1.id = p.id
	and a1.id <> a.id;

-- 8. Quali sono il nome e il cognome degli strutturati che nello stesso giorno hanno sia
-- attività progettuali che attività non progettuali?
select p.id, p.nome, p.cognome
from Persona p, AttivitaProgetto ap, 
	AttivitaNonProgettuale anp
where p.id = ap.persona 
	and p.id = anp.persona
	and ap.giorno = anp.giorno;


-- 9. Quali sono il nome e il cognome degli strutturati che nello stesso giorno hanno sia
-- attività progettuali che attività non progettuali? Si richiede anche di proiettare il
-- giorno, il nome del progetto, il tipo di attività non progettuali e la durata in ore di
-- entrambe le attività.
select p.id, p.nome, p.cognome, ap.giorno, pg.nome,
	ap.oreDurata, anp.tipo, anp.oreDurata
from Persona p, AttivitaProgetto ap, 
	AttivitaNonProgettuale anp, Progetto pg
where p.id = ap.persona 
	and p.id = anp.persona
	and ap.giorno = anp.giorno
	and ap.progetto = pg.id;


-- 10. Quali sono il nome e il cognome degli strutturati che nello stesso giorno sono
-- assenti e hanno attività progettuali?
select p.id, p.nome, p.cognome
from Persona p, AttivitaProgetto ap, Assenza a
where p.id = ap.persona and p.id = a.persona
	and ap.giorno = a.giorno;


-- 11. Quali sono il nome e il cognome degli strutturati che nello stesso giorno sono
-- assenti e hanno attività progettuali? Si richiede anche di proiettare il giorno, il
-- nome del progetto, la causa di assenza e la durata in ore della attività progettuale.
select p.id, p.nome, p.cognome, ap.giorno, 
	a.tipo, pg.nome, ap.oreDurata
from Persona p, AttivitaProgetto ap, Assenza a, Progetto pg
where p.id = ap.persona and p.id = a.persona
	and ap.giorno = a.giorno
	and pg.id = ap.progetto;


-- 12. Quali sono i WP che hanno lo stesso nome, ma appartengono a progetti diversi?
select distinct w.nome
from WP w, WP w1
where w.nome = w1.nome and w.progetto <> w1.progetto;