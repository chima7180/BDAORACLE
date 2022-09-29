

create or replace package GestionTickets as
procedure insertionTicket(pidTicket Ticket.idTicket%TYPE, pdateTicket Ticket.dateTicket%TYPE,
							pdateReception Ticket.dateReception%TYPE, pdateCloture Ticket.dateCloture%TYPE,
							ptitre Ticket.titre%TYPE, pdescription Ticket.description%TYPE,
							ptypeTicket Ticket.typeTicket%TYPE,ppriorite Ticket.priorite%TYPE,
							pnature Ticket.nature%TYPE, pstatut Ticket.statut%TYPE,
							pevaluation Ticket.evaluation%TYPE, pidUtilisateur Ticket.idutilisateur%TYPE,
							pidOperateur Ticket.idOperateur%TYPE, observateurs varchar2);
procedure statsTicketsUtilisateur(pidUtilisateur Utilisateur.idUtilisateur%TYPE);
procedure insertionAttribuer(pidOperateur Operateur.idoperateur%TYPE, pidticket Ticket.idTicket%TYPE,
            pdatedebut Attribuer.dateDebut%TYPE, pdatefin Attribuer.datefin%TYPE);
procedure insertionSuivi (pidSuivi Suivi.idSuivi%TYPE, pdatesuivi Suivi.datesuivi%TYPE,
        ptexte Suivi.texte%TYPE, pidOperateur Suivi.idOperateur%TYPE, pidTicket Suivi.idTicket%TYPE);
procedure statsTicket(pidTicket Ticket.idTicket%TYPE);

end;
/


create or replace package body GestionTickets as

procedure insertionTicket(pidTicket Ticket.idTicket%TYPE, pdateTicket Ticket.dateTicket%TYPE,
							pdateReception Ticket.dateReception%TYPE, pdateCloture Ticket.dateCloture%TYPE,
							ptitre Ticket.titre%TYPE, pdescription Ticket.description%TYPE,
							ptypeTicket Ticket.typeTicket%TYPE,ppriorite Ticket.priorite%TYPE,
							pnature Ticket.nature%TYPE, pstatut Ticket.statut%TYPE,
							pevaluation Ticket.evaluation%TYPE, pidUtilisateur Ticket.idutilisateur%TYPE,
							pidOperateur Ticket.idOperateur%TYPE, observateurs varchar2) as

-- observateurs contient une liste des identifiants des observateurs du ticket.
pb_ck exception;
pragma exception_init(pb_ck,-2290);

pb_fk exception;
pragma exception_init(pb_fk,-2291);

begin
insert into Ticket values (pidTicket, pdateTicket, pdatereception, pdateCloture, ptitre, pdescription, ptypeTicket, ppriorite,
							pnature, pstatut, pevaluation, pidutilisateur, pidoperateur);

-- la requête select de cette boucle décompose la chaine de caractères sur le '-'
-- exemple : '1-3-5' va être décomposé en
-- 1
-- 3
-- 5
for i in (SELECT regexp_substr(observateurs,'[^-]+',1,level) AS observateur
		FROM DUAL
		CONNECT BY regexp_substr(observateurs,'[^-]+',1,level) IS NOT NULL) loop
	insert into Observer values (i.observateur, pidTicket);
end loop;

commit;
dbms_output.put_line('Insertions réussies');

-- on ne fait un rollback que sur les exceptions qui peuvent arriver dans Observer.
-- Ce n'est pas faut de le faire sur les autres exceptions, mais c'est inutile.
exception
	when DUP_VAL_ON_INDEX then dbms_output.put_line('Cet identifiant de ticket existe déjà');
	when pb_ck then
		if sqlerrm like '%CK_DATES_TICKET%' then
			dbms_output.put_line('La date de réception du ticket doit être supérieur à sa date de création');
		elsif sqlerrm like '%CK_DATES_CLOTURE%' then
			dbms_output.put_line('La date de cloture du ticket doit être supérieur à sa date de réception');
		elsif sqlerrm like '%CK_TYPETICKET%' then
			dbms_output.put_line('Le type du ticket doit être incident ou demande');
		elsif sqlerrm like '%CK_NATURE%' then
			dbms_output.put_line('La nature du ticket doit être (téléphonie, internet,automatique)');
		elsif sqlerrm like '%CK_PRIORITE%' then
			dbms_output.put_line('La priorité du ticket doit être entre 1 et 5');
		elsif sqlerrm like '%CK_STATUT%' then
			dbms_output.put_line('Le statut du ticket doit être (créé,attribué,en cours,résolu,clos)');
		elsif sqlerrm like '%CK_NN_OPERATEUR%' then
			dbms_output.put_line('L''opérateur ne peut être nul');
		end if;
	when pb_fk then
		if sqlerrm like '%FK_TICKET_UTILISATEUR%' then
			dbms_output.put_line('L''identifiant d''utilisateur créant le ticket n''existe pas');
		elsif sqlerrm like '%FK_TICKET_OPERATEUR%' then
			dbms_output.put_line('L''identifiant d''opérateur n''existe pas');
		elsif sqlerrm like '%FK_OBSERVER_UTILISATEUR%' then
			dbms_output.put_line('Un des identifiants d''observateur n''existe pas');
			rollback;
		end if;
	when OTHERS then
		dbms_output.put_line(SQLCODE||' - '|| SQLERRM);
		rollback;
end insertionTicket;


procedure statsTicketsUtilisateur(pidUtilisateur Utilisateur.idUtilisateur%TYPE) as
vnb number;

begin

select count(*) into vnb
from Ticket T
where idUtilisateur = pidutilisateur;

dbms_output.put_line('Nombre total de tickets de l''utilisateur '||pidutilisateur||': '||vnb);

select count(*) into vnb
from Ticket T
where idUtilisateur = pidutilisateur
and statut='clos';

dbms_output.put_line('Nombre de tickets clos : '||vnb);

dbms_output.put_line('Liste des tickets ouverts: ');


for c_ligne in (select idTicket, titre, nomOperateur
                from Ticket T, Operateur O
                where T.idOperateur = O.idOperateur
                and idUtilisateur = pidUtilisateur
                and statut !='clos'
                order by dateTicket desc) loop
    dbms_output.put_line(c_ligne.idTicket||' - '|| c_ligne.titre ||' - Operateur :'||c_ligne.nomOperateur);
end loop;

end statsTicketsUtilisateur;



procedure insertionAttribuer(pidOperateur Operateur.idoperateur%TYPE, pidticket Ticket.idTicket%TYPE,
            pdatedebut Attribuer.dateDebut%TYPE, pdatefin Attribuer.datefin%TYPE) as

-- on nomme l'erreur non nommée -2292 (problème de check) en pb_check_date
pb_check_date exception;
pragma exception_init(pb_check_date, -2292);

-- on nomme l'erreur non nommée -2291 (problème de clé étrangère) en pb_cle_etrangere
pb_cle_etrangere exception;
pragma exception_init(pb_cle_etrangere,-2291);

begin

insert into Attribuer values (pidOperateur, pidTicket, pdatedebut, pdatefin);
commit;

exception
when pb_check_date then
dbms_output.put_line('Cet opérateur est déjà affecté à ce ticket');

-- l'erreur peut se déclencher soit pour l'opérateur, soit pour le ticket.
-- on teste donc le message d'erreur
when pb_cle_etrangere then
    if sqlerrm like'%FK_ATTRIBUER_OPERATEUR%' then
        dbms_output.put_line('Cet opérateur n''existe pas');
    else
        dbms_output.put_line('Ce ticket n''existe pas');
    end if;

when dup_val_on_index then
    dbms_output.put_line('Cet opérateur est déjà affecté à ce ticket');

-- toujours ajouter others, pour tous les cas non traités jusqu'ici
when others then
    dbms_output.put_line(SQLCODE||' - '|| SQLERRM);
end insertionAttribuer;


procedure insertionSuivi (pidSuivi Suivi.idSuivi%TYPE, pdatesuivi Suivi.datesuivi%TYPE,
        ptexte Suivi.texte%TYPE, pidOperateur Suivi.idOperateur%TYPE, pidTicket Suivi.idTicket%TYPE) as

 vdateTicket  Ticket.dateTicket%TYPE;

-- on nommme l'erreur qui remonte du trigger TP4.Q5
pb_date_trigger exception;
pragma exception_init(pb_date_trigger, -20001);

-- on nommme l'erreur qui remonte du trigger TP4.Q7
pb_operateur_trigger exception;
pragma exception_init(pb_date_trigger, -20002);

 -- on nomme l'erreur non nommée -2291 (problème de clé étrangère) en pb_cle_etrangere
 pb_cle_etrangere exception;
 pragma exception_init(pb_cle_etrangere,-2291);

begin

-- L'erreur applicative n''existe plus : on prend l'erreur qui remonte du trigger
-- select dateTicket into vdateTicket
-- from ticket where idTicket=pidTicket;

-- déclenchement de l'erreur applicative
-- if (pdateSuivi <vdateTicket) then
 --   raise pb_date;
-- end if;

insert into Suivi values (pidSuivi, pdateSuivi, ptexte, pidOperateur, pidTicket);
commit;

exception
    when dup_val_on_index then dbms_output.put_line('Cet identifiant de suivi existe déjà');

    -- si l'identifiant de ticket n'existe pas, la requête récupérant la date de création du ticket DANS LE TRIGGER va renvoyer un no_data_found
    -- il est remonté dans la procédure
    when no_data_found then dbms_output.put_line('Cet identifiant de ticket n''existe pas');

    -- erreur remontee du trigger de TP4.Q5
    when pb_date_trigger then dbms_output.put_line('Erreur trigger: La date de suivi ne peut pas être antérieure à la date de création du ticket ('||vdateTicket||')');

    -- erreur remontee du trigger de TP4.Q7
	when pb_operateur_trigger then dbms_output.put_line('Erreur trigger: Cet opérateur ne peut pas effectuer de suivi sur ce ticket, il ne lui a pas été attribué');

    -- l'erreur -2291 ne peut se produire avec ce code que sur un problème d'operateur
    when pb_cle_etrangere then dbms_output.put_line('Cet identifiant d''opérateur n''existe pas');

    when others then dbms_output.put_line(SQLCODE||' - '||SQLERRM);
end insertionSuivi;




procedure statsTicket(pidTicket Ticket.idTicket%TYPE) as

vtitre ticket.titre%TYPE;
vdescription ticket.description%TYPE;
vstatut ticket.statut%TYPE;
vnature ticket.nature%TYPE;
vdateticket ticket.dateTicket%TYPE;
vdateReception ticket.datereception%TYPE;
vnomOperateur operateur.nomOperateur%TYPE;
vprenomOperateur operateur.prenomOperateur%TYPE;
vnomUtilisateur Utilisateur.nomUtilisateur%TYPE;
vprenomUtilisateur utilisateur.prenomUtilisateur%TYPE;
vidUtilisateur Utilisateur.idUtilisateur%TYPE;

begin
    select titre, description, statut, nature, dateTicket, dateReception,
    nomOperateur, prenomOperateur, idUtilisateur
    into vtitre, vdescription, vstatut, vnature, vdateTicket, vdateReception,
    vnomOperateur,  vprenomOperateur, vidUtilisateur
    from ticket T, operateur o
    where t.idoperateur = o.idoperateur
    and t.idticket = pidticket;

    -- cas où il n'y a pas d'utilisateur associé, pour éviter l'erreur NO_DATA_FOUND
    if (vidUtilisateur is not null) then
        select nomUtilisateur, prenomUtilisateur into vnomUtilisateur, vprenomUtilisateur
        from Utilisateur
        where idUtilisateur=vidUtilisateur;
    end if;

    dbms_output.put_line('Informations sur le ticket '||pidticket);
    dbms_output.put_line('Titre : '||vtitre);
    dbms_output.put_line('Description : '||vdescription);
    dbms_output.put_line('Statut : '||vstatut);
    dbms_output.put_line('Nature : '||vnature);
    dbms_output.put_line('Date de création : '||vdateTicket);
    dbms_output.put_line('Date de réception : '||vdateReception);
    dbms_output.put_line('Operateur : '||vprenomOperateur||' '||vnomOperateur);
    if (vnomUtilisateur is not null) then
        dbms_output.put_line('Utilisateur : '||vprenomUtilisateur||' '||vnomutilisateur);
    end if;

     dbms_output.put_line('Opérateurs affectés au ticket : ');
    for i in (select operateur.idoperateur, nomOperateur, prenomOperateur from Operateur, attribuer
            where operateur.idoperateur = attribuer.idoperateur
            and idticket=pidticket) loop
            dbms_output.put_line('       Opérateur '||i.prenomOperateur||' '||i.nomOperateur);
            for j in (select idSuivi, dateSuivi, texte from Suivi
                    where idOperateur = i.idOperateur
                    and idticket=pidticket) loop
                    dbms_output.put_line('              '||j.idSuivi||' - '||j.dateSuivi||' - '||j.texte);
            end loop;
    end loop;

end statsTicket;

end;
/

execute gestionTickets.statsTicket(1);