Officina(
    _id: integer_, 
    nome: varchar, 
    indirizzo: Indirizzo
    )
    FK: direttore ref Direttore(staff)

Dipendente(
    _codiceFiscale: CodiceFiscale_
    )
    FK: staff references Staff(persona)

Lavora(
    officina: integer, 
    dipendente: CodiceFiscale, 
    data_assunzione: date
    )
    FK: officina references Officina(id)
    FK: dipendente references Dipendente(codiceFiscale)
    Vincolo inclusione Dipendente(codiceFiscale) occorre in Lavora(dipendente)