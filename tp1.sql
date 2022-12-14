--commande a exec
SET serveroutput on

--q1
Select TABLE_NAME from user_tables; --obtenir liste des tables créées
select * from user_tables;  --obtenir liste des tables créées
SELECT COLUMN_NAME, DATA_TYPE FROM USER_TAB_COLS WHERE TABLE_NAME = 'TICKET'; --description de des colonnes
SELECT * FROM USER_CONSTRAINTS; --nom et type des contraintes créées

--q2
SELECT count(*) FROM TICKET WHERE IDUTILISATEUR= 1; --le nombre total de tickets créés par l’utilisateur 1,
SELECT count(*) FROM TICKET WHERE STATUT='clos' and IDUTILISATEUR=1; --le nombre de ses tickets clos (statut = ‘clos)
SELECT IDTICKET, TITRE, NOMOPERATEUR FROM TICKET INNER JOIN OPERATEUR ON OPERATEUR.IDOPERATEUR=TICKET.IDOPERATEUR WHERE STATUT!='clos' and IDUTILISATEUR=1 order by DATETICKET DESC;
-- . la liste de ses tickets encore ouverts (statut différent de ‘clos’) triée par ordre
-- chronologique décroissant de création (uniquement idTicket et titre du
-- ticket, ainsi que le nom de l’opérateur référent).

--Manuel
CREATE OR REPLACE PROCEDURE statsTicketsUtilisateur as

nbTicket number;
nbTicketClos number;
vidticket ticket.idticket%TYPE;
vtitre ticket.titre%TYPE;
vnomoperateur operateur.nomoperateur%TYPE;

cursor manuel is SELECT IDTICKET, TITRE, NOMOPERATEUR  FROM TICKET
INNER JOIN OPERATEUR ON OPERATEUR.IDOPERATEUR = TICKET.IDOPERATEUR
WHERE IDUTILISATEUR = 1 AND STATUT != 'clos'
ORDER BY DATETICKET DESC;

BEGIN
--Question 2
--Le nombre total de tickets créés par l'utilisateur 1
SELECT COUNT(*) into nbTicket FROM TICKET WHERE IDUTILISATEUR = 1;

--Le nombre de ses tickets clos (statut = 'clos')
SELECT COUNT(*) into nbTicketClos FROM TICKET WHERE IDUTILISATEUR = 1 AND STATUT ='clos' ;

--Curseur Manuel
open manuel;
fetch manuel into vidticket, vtitre, vnomoperateur;
while manuel%FOUND loop
    dbms_output.put_line(vidticket|| vtitre|| vnomoperateur);
    fetch manuel into vidticket, vtitre, vnomoperateur;
end loop;
close manuel;
END;
/

--Curseur semi-automatique
for ticket in semi loop
    dbms_output.put_line('Curseur semi-automatique');
    dbms_output.put_line(vidticket'|' vtitre'|' vnomoperateur);
end loop;
avec en var
cursor semi is SELECT IDTICKET, TITRE, NOMOPERATEUR  FROM TICKET
INNER JOIN OPERATEUR ON OPERATEUR.IDOPERATEUR = TICKET.IDOPERATEUR
WHERE IDUTILISATEUR = 1 AND STATUT != 'clos'
ORDER BY DATETICKET DESC;
--Curseur automatique
dbms_output.put_line('Curseur automatique');
for ticket_auto in (SELECT IDTICKET, TITRE, NOMOPERATEUR  FROM TICKET
INNER JOIN OPERATEUR ON OPERATEUR.IDOPERATEUR = TICKET.IDOPERATEUR
WHERE IDUTILISATEUR = 1 AND STATUT != 'clos'
ORDER BY DATETICKET DESC) loop
    dbms_output.put_line(ticket_auto.idticket||'|'|| ticket_auto.titre||'|'|| ticket_auto.nomoperateur);
end loop;

EXECUTE statsTicketsUtilisateur;

--Q3 paramétrer l’identifiant de l’utilisateur pour lequel on veut les informations précédentes.
CREATE OR REPLACE PROCEDURE statsTicketsUtilisateur(papy TICKET.IDUTILISATEUR%type) as

nbTicket number;
nbTicketClos number;

BEGIN
--Curseur automatique
dbms_output.put_line('Curseur automatique');
for ticket_auto in (SELECT IDTICKET, TITRE, NOMOPERATEUR  FROM TICKET
INNER JOIN OPERATEUR ON OPERATEUR.IDOPERATEUR = TICKET.IDOPERATEUR
WHERE IDUTILISATEUR = papy AND STATUT != 'clos'
ORDER BY DATETICKET DESC) loop
    dbms_output.put_line(ticket_auto.idticket||'|'|| ticket_auto.titre||'|'|| ticket_auto.nomoperateur);
end loop;


END;
/

EXECUTE statsTicketsUtilisateur(2);

--q4 affichez le code source de vos programmes stockés
SELECT * from USER_SOURCE;


