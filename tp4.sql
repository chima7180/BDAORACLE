set serveroutput on

-- Q1 Ecrire un trigger qui lors d’une insertion dans la table Ticket,
--attribue automatiquement le ticket à l’opérateur référent pour le ticket
--(insertion du tuple correspondant dans la table Attribuer, avec comme date
--de début la date de réception du ticket, et la date de fin à null).
-- Q2 Modifier ce trigger pour qu’il fonctionne également lors d’une mise à jour de la
-- colonne idOperateur sur la table Ticket. Lorsque l’opérateur référent d’un ticket
-- change, on ferme l’attribution du ticket pour l’ancien opérateur avec la date actuelle
-- (sysdate) et on attribue le ticket au nouvel opérateur (date de début égale à la date
-- actuelle)
create or replace trigger insert_attribuer
after insert or update on TICKET
for each row
begin
if inserting then
    insert into ATTRIBUER values (:new.idOperateur, :new.idTicket, :new.dateReception,:new.dateCloture );
elsif updating then
    update ATTRIBUER set datefin = sysdate where idoperateur = :old.idOperateur and idticket = :old.idticket;
    insert into ATTRIBUER values (:new.idOperateur, :new.idTicket, sysdate,:new.dateCloture );
end if;
end;
/

update ticket set idoperateur = 4 where idoperateur = 3 and idticket = 9;


alter table Utilisateur add nbTickets number;
update Utilisateur U
set nbTickets = (select count(*) from Ticket T
 where U.idUtilisateur = T.idUtilisateur);

--Que font-ils ?
 --Ces commandes modifies la table utilisateur en modifiant 6 lignes
 --on y ajoute une colonne nbTicket
 --on update ensuite la table en comptant le nombre de ticket par utilisateur

-- Lors d’une insertion ou d’une suppression dans Ticket, la colonne
-- nbTickets de la table Utilisateur doit être mise à jour
create or replace trigger t_a_id_Ticket
after insert or delete on Ticket
for each row
begin
if inserting then
    update Utilisateur U
    set nbTickets = (nbTickets+1) where idUtilisateur = :new.idUtilisateur;
elsif deleting then
    delete from attribuer where idticket = 11;
    update Utilisateur U
    set nbTickets = (nbTickets-1) where idUtilisateur = :old.idUtilisateur;
end if;
end;
/

--La compilation est OK
insert into Ticket values (11,'12/9/2018','12/9/2018',null,'Demande d''installation de
MongoDB dans les salles U3','Pourriez-vous installer MongoDB
dans les salles','demande',2,'internet','créé',null,3,3);
delete from Ticket where idticket = 11;

--L'insertion ne fonctionne pas car on fait une recherche sur une ligne qu'on est entrain de travailler

--Partie 3 : Élaboration de contraintes complexes.
-- Ecrire un trigger qui lors d’une insertion dans la table Suivi, vérifie que la date
-- de suivi est supérieure à la date de réception du ticket.
-- Le trigger empêchera l’insertion en cas de problème.
create or replace trigger insert_suivi
after insert or update on SUIVI
for each row
declare
vdaterecep ticket.datereception%TYPE;
begin
select datereception into vdaterecep from ticket where idTicket = :new.idticket;

if vdaterecep < :new.datesuivi then raise_application_error(-20003,'La date de suivi doit être supérieur à la date de réception du ticket');
end if;
end;
/
-- trigger en after ou before
-- Pas de changement ici, même en trigger after l'insertion est annulée
-- Donc: le raise_application_error empêche l'ordre sur lequel porte le trigger d'être réalisé
-- que le trigger soit on trigger before ou en trigger after
-- Attention cependant: il se peut que le code diffère en certains points lorsqu'on met le trigger
-- en before ou en after (pas le cas ici)


create or replace procedure insertionSuivi (pidsuivi suivi.idsuivi%TYPE, pdatesuivi suivi.DATESUIVI%TYPE, ptexte suivi.texte%TYPE, pidoperateur suivi.idoperateur%TYPE, pidticket suivi.idticket%TYPE) as
pb_date exception;
pragma exception_init(pb_date, -20003);
pb_op exception;
pragma exception_init(pb_op, -20004);
begin
insert into suivi values (pidSuivi,pdatesuivi,ptexte,pidoperateur,pidticket);

exception
when pb_date then
    dbms_output.put_line('Pb de date');
when pb_op then
    dbms_output.put_line('Ce ticket n"est pas attribuer à cet opérateur');
end;
/


delete from suivi where idsuivi = 126 ;
execute insertionSuivi(126, '15/06/2022', 'cc', 3,8);

--Si on fait le test avant l'insertion la ligne ne sera pas insérer
--Si on fait un trigger apres la ligne ne sera quand meme pas insérer car l'insertion correspondra à une erreur
--mais d'un point de vue logique vaut mieux faire un before

-- Ecrire un autre trigger sur la table Suivi qui vérifie que l’opérateur effectuant le
-- suivi est bien affecté sur le ticket (relation Attribuer)
create or replace trigger verif_suivi
before insert on SUIVI
for each row
declare
vidop ticket.idoperateur%TYPE;
begin
select idoperateur into vidop from attribuer where idTicket = :new.idticket;
if vidop != :new.idoperateur then raise_application_error(-20004,'Ce ticket n"est pas attribuer à cet opérateur');
end if;
end;
/
execute insertionSuivi(126, '15/06/2022', 'cc', 4,8);

