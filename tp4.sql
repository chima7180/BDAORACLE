set serveroutput on

--Q1
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