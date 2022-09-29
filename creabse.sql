drop table Suivi;
drop table Attribuer;
drop table Observer;
drop table Ticket;
drop table Operateur;
drop table Utilisateur;

/* Utilisateurs et Opérateurs */

create table Utilisateur
(idUtilisateur number,
nomUtilisateur varchar2(30),
prenomUtilisateur varchar2(30),
constraint pk_utilisateur primary key(idUtilisateur));



create table Operateur
(idOperateur number,
nomOperateur varchar2(30),
prenomOperateur varchar2(30),
constraint pk_operateur primary key(idOperateur));



/* Tickets, Observateurs, opérateurs attribués, Suivis */

create table Ticket
(idTicket number,
dateTicket date,
dateReception date,
dateCloture date,
titre varchar2(60),
description varchar2(300),
typeTicket varchar2(8),
priorite number(1),
nature varchar2(15),
statut varchar2(10),
evaluation varchar2(100),
idUtilisateur number,
idOperateur number,
constraint pk_ticket primary key(idTicket),
constraint ck_dates_ticket check (dateReception>=dateTicket),
constraint ck_dates_cloture check (datecloture>=dateReception),
constraint ck_typeticket check (typeTicket in ('incident','demande')),
constraint ck_priorité check (priorite between 1 and 5),
constraint ck_nature check (nature in ('téléphonie', 'internet','automatique')),
constraint ck_statut check (statut in ('créé','attribué','en cours','résolu','clos')),
constraint fk_ticket_utilisateur foreign key(idUtilisateur) references utilisateur(idUtilisateur),
constraint fk_ticket_operateur foreign key(idoperateur) references Operateur(idoperateur),
constraint ck_nn_operateur check (idoperateur is not null)
);





create table Observer
(idUtilisateur number,
idTicket number,
constraint pk_observer primary key (idUtilisateur, idTicket),
constraint fk_observer_utilisateur foreign key (idUtilisateur) references Utilisateur(idUtilisateur),
constraint fk_observer_ticket foreign key(idTicket) references Ticket(idTicket)
);


create table Attribuer
(idOperateur number,
idTicket number,
datedebut date,
datefin date,
constraint pk_attribuer primary key(idoperateur, idticket),
constraint ck_dates check (datedebut<=datefin),
constraint fk_attribuer_operateur foreign key(idoperateur) references Operateur(idOperateur),
constraint fk_attribuer_ticket foreign key(idticket) references Ticket(idTicket));

create table Suivi
(idSuivi number,
datesuivi date,
texte varchar2(300),
idOperateur number,
idTicket number,
constraint pk_suivi primary key(idsuivi),
constraint fk_suivi_operateur foreign key(idOperateur) references operateur(idOperateur),
constraint fk_suivi_ticket foreign key(idTicket) references Ticket(idTicket)
);
