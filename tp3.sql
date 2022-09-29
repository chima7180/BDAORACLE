--Partie1
--Creation d'une vue mono table
CREATE VIEW SuiviEvain as
SELECT idSuivi, datesuivi, texte, idOperateur, idTicket FROM Suivi
WHERE idOperateur = 4;

--Affichage du contenu de cette vue
SELECT * FROM SuiviEvain;

--Verification dans la table USER_VIEWS
SELECT * FROM USER_VIEWS;

--Ajout de deux lignes dans la table Suivi
insert into Suivi values (100, '15/09/2019','Verification derniere version neo4j', 4,7);
insert into Suivi values (101, '16/09/2019','Installation v6.3',2,7);

--Interrogation de la table suivi et suiviEvain
SELECT * FROM SUIVI;
--Les 2  lignes ont bien été insérées
SELECT * FROM SUIVIEVAIN;
--On ne voit seulement que idsuivi 100 car il s'agit de la seule ligne
--correspondant à Evain (idOperateur 4)

--Suppresion ligne 100 via SuiviEvain
DELETE FROM SuiviEvain WHERE idSuivi = 100;
--Interrogation de la table suivi et suiviEvain
SELECT * FROM SUIVI;
--La ligne 100 a été supprimé car suivievain travail directement
--sur la table suivi (il s'agit que d'une manière d'afficher)
--et on respecte les contrainte de suivievain
SELECT * FROM SUIVIEVAIN;
--La ligne 100 a été supprimé
--Elle n'existe plus dans suivi donc non plus dans suivievain

--Suppresion ligne 101 via SuiviEvain
DELETE FROM SuiviEvain WHERE idSuivi = 101;
--On ne peut pas supprimer la ligne car elle ne répond pas au contrainte de la vue
--Interrogation de la table suivi et suiviEvain
SELECT * FROM SUIVI;
--La ligne 101 existe toujours du coup

--Insertion via suiviEvain
insert into SuiviEvain values (102, '17/09/2019','Traitement du problème sur les licences', 4,7);
--Interrogation de la table suivi et suiviEvain
SELECT * FROM SUIVI;
--La ligne 102 a été insérée car suivievain travail directement
--sur la table suivi (il s'agit que d'une manière d'afficher)
--et on respecte les contrainte de suivievain (idoperateur = 4)
SELECT * FROM SUIVIEVAIN;
--La ligne 102 apparait alors dans la vue

--Insertion via suiviEvain
insert into SuiviEvain values (103, '17/09/2019','Désintallation version 6.3', 2,7);
--Interrogation de la table suivi et suiviEvain
SELECT * FROM SUIVI;
--La ligne 103 a été insérée car suivievain travail directement
--sur la table suivi (il s'agit que d'une manière d'afficher)
--Pour une insertion les contraintes de SuiviEvain ne sont pas pris en compte
SELECT * FROM SUIVIEVAIN;
--La ligne 103 n'apparait pa car elle ne correspond pas au contrainte

--Il faut pouvoir bloquer la possibilité d'insérer qqch dans la vue
--qu'on ne verra pas dans la vue
--Donc on fait devenir le where une contrainte
CREATE or replace VIEW SuiviEvain as
SELECT idSuivi, datesuivi, texte, idOperateur, idTicket FROM Suivi
WHERE idOperateur = 4
WITH CHECK option constraint ck_evain;

select * from user_constraints;
--Elle est de type V

CREATE or replace VIEW TicketObservateurMousset as
SELECT idTicket, dateTicket, dateReception, dateCloture, titre, ticket.description, typeTicket, priorite, nature, statut, ticket.evaluation, ticket.idUtilisateur, idOperateur FROM Ticket
WHERE idUtilisateur = (SELECT idUtilisateur FROM Utilisateur WHERE nomutilisateur = 'Mousset')
WITH CHECK option constraint ck_mousset;
--Affichage de la table
SELECT * FROM ticketobservateurmousset;

--Insertion de la ligne
insert into ticketobservateurmousset values (8,'13/9/2019','14/9/2019',null,'Installation de mongoDB en U1','Pourriez-vous installer mongoDB dans les salles de U1 ? Les Tps commencent demain','demande',4,'internet','en cours',null,1,2);
--on ne peut pas l'insérer car l'idutilisateur ne correspond pas à l'idutilisateur de mousset = 2

CREATE or replace VIEW dureeAttribution(idOperateur, idTicket, duree) as
SELECT idOperateur, idTicket, datefin-datedebut FROM Attribuer;
--Affichage
SELECT * FROM dureeattribution;

--Changement operateur
UPDATE dureeattribution SET IDOPERATEUR = 2
WHERE idTicket = 1 and idoperateur = 3;
--Affichage de la vue
SELECT * FROM dureeattribution;
--modification ok
rollback;
SELECT * FROM dureeattribution;
--modification annulée

UPDATE dureeattribution SET duree= duree+2
WHERE idTicket = 1 and idoperateur = 3;
--Il ne s'agit pas d'une vraie colonne donc on ne pas la modifié

--C possible quand pas de check : insertion, delete qui repond au where
-- avec check : insertion et delete qui repond au where

--Partie2
create or replace VIEW TicketsUtilisateurs as
SELECT idTicket, dateTicket, dateReception, DATECLOTURE, TITRE, EVALUATION, IDOPERATEUR, nomUtilisateur, prenomUtilisateur FROM TICKET
INNER JOIN UTILISATEUR ON UTILISATEUR.IDUTILISATEUR = TICKET.IDUTILISATEUR;

--insert into TicketsUtilisateurs VALUES (8, '17/05/2019', '18/05/2019', '25/05/2019', 'on est la', 'merci', 1, shimo, Felix);

create table OperateurStagiaire
(idOperateur number,
nomOperateur varchar2(30),
prenomOperateur varchar2(30),
constraint pk_operateurStagiaire primary key(idOperateur));

insert into OperateurStagiaire values (101, 'Martin', 'Jean');
insert into OperateurStagiaire values (102, 'Villamur', 'Etienne');
SELECT * FROM OperateurStagiaire;

create or replace VIEW Operateurs(idOperateur, nomOperateur, prenomOperateur, statut) as
SELECT idOperateur, nomOperateur, prenomOperateur, 'T' FROM OPERATEUR
UNION
SELECT idOperateur, nomOperateur, prenomOperateur, 'S' FROM OperateurStagiaire
;
SELECT * FROM operateurs;


--Partie3

--Q18 User1 donne à User2 le droit de travailler sur sa table Utilisateur avec
-- les privilèges suivants : select, insert, update(prenomUtilisateur).
GRANT select, insert, update on UTILISATEUR to GRT3543A;

--q19 ] User2 fait une modification du prénom d’un Utilisateur dans la table
-- user1.utilisateur. User2 et User1 vérifient le contenu de la table. Que se
-- passe-t-il et pourquoi ? User2 fait un ‘commit’. User1 vérifie le contenu.
-- l'User1 ne voit pas la modif car elle n'a pas été commit
INSERT INTO PQM3570A.UTILISATEUR VALUES (111,'Lebron','James');
SELECT * FROM PQM3570A.utilisateur;
COMMIT;

--q20
-- User2 tente de supprimer une ligne dans la table User1.utilisateur. Que
-- se passe-t-il et pourquoi ?
-- suppression non faites car pas de droits de suppression en Q18
DELETE FROM PQM3570A.utilisateur where idutilisateur= 110;

--q21
-- User1 et User2 font une modification de prénom d’utilisateur pour le même
-- utilisateur. Que se passe-t-il et pourquoi ?
-- la dernière modif commit s'appliquera
UPDATE PQM3570A.UTILISATEUR set PRENOMUTILISATEUR= 'bite' where IDUTILISATEUR= 110;

--Question 23
--User1 supprime les privilèges donnés
revoke select, insert, update ON UTILISATEUR from GRT3543A;

