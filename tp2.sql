--Ex1
--Creattion de la procedure
CREATE OR REPLACE PROCEDURE insertionAttribuer(pidop ATTRIBUER.IDOPERATEUR%TYPE, pidticket ATTRIBUER.IDTICKET%type, vdatedebut ATTRIBUER.DATEDEBUT%type, vdatefin ATTRIBUER.DATEFIN%type) as

--Declaration des erreurs
date_pas_bon exception;
pragma exception_init(date_pas_bon, -2290);
idop_existe exception;
pragma exception_init ( idop_existe,-2291 );


BEGIN
INSERT INTO ATTRIBUER VALUES (pidop, pidticket, vdatedebut, vdatefin);


EXCEPTION
--Date fin antérieure à dateDebut
when date_pas_bon then
    dbms_output.put_line('La date de fin est antérieur à la date de début');
--Couple déjà existant
when dup_val_on_index then
    dbms_output.put_line('Le couple existe déjà');
--idOperateur inexistant
when idop_existe then
    dbms_output.put_line('idOperateur est inexistant');
when others then
    dbms_output.put_line(SQLCODE||' '||SQLERRM);
END;
/
EXECUTE insertionAttribuer(5,3,'31/5/2019','7/9/2020');


--ex2
--Creattion de la procedure
CREATE OR REPLACE PROCEDURE insertionAttribuer(pidop ATTRIBUER.IDOPERATEUR%TYPE, pidticket ATTRIBUER.IDTICKET%type, vdatedebut ATTRIBUER.DATEDEBUT%type, vdatefin ATTRIBUER.DATEFIN%type) as

--Declaration des erreurs
date_pas_bon exception;
pragma exception_init(date_pas_bon, -2290);
idop_existe exception;
pragma exception_init ( idop_existe,-2291 );
idti_idop_existe exception;
pragma exception_init ( idti_idop_existe,-2291 );

BEGIN
INSERT INTO ATTRIBUER VALUES (pidop, pidticket, vdatedebut, vdatefin);


EXCEPTION
--Date fin antérieure à dateDebut
when date_pas_bon then
    dbms_output.put_line('La date de fin est antérieur à la date de début');
--Couple déjà existant
when dup_val_on_index then
    dbms_output.put_line('Le couple existe déjà');
--idOperateur et idticket inexistant
when idti_idop_existe then
    if sqlerrm like '%FK_ATTRIBUER_TICKET%' then
        dbms_output.put_line('idticket est inexistant');
    else
        dbms_output.put_line('idOperateur est inexistant');
end if;
when others then
    dbms_output.put_line(SQLCODE||' '||SQLERRM);
END;
/
EXECUTE insertionAttribuer(5,3,'31/5/2019','7/9/2020');

--ex3
CREATE OR REPLACE PROCEDURE insertionSuivi(pidSuivi SUIVI.IDSUIVI%TYPE,pdatesuivi SUIVI.DATESUIVI%TYPE, ptexte SUIVI.TEXTE%TYPE, pidOperateur SUIVI.IDOPERATEUR%TYPE, pidTicket SUIVI.IDTICKET%TYPE) as
--Déclaration des erreurs
date_crea TICKET.DATETICKET%TYPE;
date_pas_bon exception;
ids_existe exception;
pragma exception_init(ids_existe, -2290);
fk_inexiste exception;
pragma exception_init(fk_inexiste, -2291);

BEGIN
--commencer par le select sinon impossible de vérifier
SELECT dateticket into date_crea FROM TICKET WHERE idTicket = pidTicket;
IF date_crea > pdatesuivi then raise date_pas_bon ;
END IF;
INSERT INTO SUIVI VALUES (pidSuivi, pdatesuivi, ptexte, pidOperateur, pidTicket);


EXCEPTION
when no_data_found then
    dbms_output.put_line('idTicket est inexistant');
when date_pas_bon then
    dbms_output.put_line('La date de suivi est antérieure à la date de création du ticket');
when dup_val_on_index then
    dbms_output.put_line('idSuivi déjà existant');
when fk_inexiste then
    dbms_output.put_line('idOperateur est inexistant');
when others then
    dbms_output.put_line(SQLCODE||' '||SQLERRM);
END;
/

EXECUTE insertionSuivi(26,'30/08/2019','Envoi des comptes à l''enseignant',15,1);

