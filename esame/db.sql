begin transaction;

create table Paziente(
    cf varchar(20) NOT NULL,
    nome varchar(30) NOT NULL,
    cognome varchar(30) NOT NULL,

    primary key (cf)
);

create table SpecializzazioneMedica(
    nome varchar(30) NOT NULL,

    primary key(nome)
);

create table Medico(
    codice integer NOT NULL,
    specializzazione varchar(30) NOT NULL,

    primary key (codice),
    foreign key (specializzazione) references SpecializzazioneMedica(nome)
);

create table Ricovero(
    id serial,
    paziente varchar(20) NOT NULL,
    inizio date NOT NULL,
    fine date,

    primary key (id),
    check ((fine IS NULL) OR (fine >= inizio)),
    foreign key (paziente) references Paziente(cf)
);

create table medico_resp(
    ricovero integer NOT NULL,
    medico integer NOT NULL,

    primary key (ricovero, medico),
    foreign key (ricovero) references Ricovero(id),
    foreign key (medico) references Medico(codice)
);

commit;