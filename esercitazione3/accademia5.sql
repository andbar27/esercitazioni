-- Quali sono il nome, la data di inizio e la data di fine dei WP del progetto di nome 
-- ‘Pegasus’ ?
select WP.id, WP.inizio, WP.fine
from WP, Progetto
where WP.progetto = Progetto.id and Progetto.nome = 'Pegasus'; 

-- Quali sono il nome, il cognome e la posizione degli strutturati che hanno almeno
-- una attività nel progetto ‘Pegasus’, ordinati per cognome decrescente?
select distinct p.id, p.nome, p.cognome, p.posizione
from Persona p, Progetto pg, AttivitaProgetto ap
where pg.id = ap.progetto and p.id = ap.persona and pg.nome = 'Pegasus'
order by cognome desc;

-- Quali sono il nome, il cognome e la posizione degli strutturati che hanno più di
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





--
