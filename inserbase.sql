delete from Suivi;
delete from Attribuer;
delete from Observer;
delete from Ticket;
delete from  Operateur;
delete from  Utilisateur;

/* Utilisateurs et Opérateurs */


insert into Utilisateur values (1,'Pinel-Sauvagnat','Karen');
insert into Utilisateur values (2,'Mousset','Paul');
insert into Utilisateur values (3,'Torguet','Patrice');
insert into Utilisateur values (4,'Aoun','André');
insert into Utilisateur values (5,'Leroux','Jackie');



insert into Operateur values (1,'Bitard','Paul');
insert into Operateur values (2,'Sergent','Laura');
insert into Operateur values (3,'Jaffres','Simon');
insert into Operateur values (4,'Evain','Léon');
insert into Operateur values (5,'Martin','Jacqueline');
insert into Operateur values (6,'Sinel','Valérie');
insert into Operateur values (7,'Pinon','Jean');
insert into Operateur values (8,'Carbonnel','Philippe');
insert into Operateur values (9,'Pirarde','Samuel');


/* Tickets, Observateurs, opérateurs attribués, Suivis */




insert into Ticket values (1,'30/8/2019','31/8/2019','7/9/2019','Création de comptes oracle','Serait-il possible de créer des comptes Oracle sur telline pour la promo M1-RT ? Merci',
        'demande',4,'internet','clos','merci, autre ticket à suivre pour suite des comptes',1,3);

insert into Observer values (2,1);
insert into Observer values (5,1);

insert into Attribuer values (3,1,'31/8/2019','7/9/2019');
insert into Attribuer values (4,1,'1/9/2019','5/9/2019');
insert into Attribuer values (5,1,'4/9/2019','6/9/2019');

insert into Suivi values (1,'2/9/2019','Recherche de personnes compétentes pour la création des comptes',3,1);
insert into Suivi values (2,'4/9/2019','Regénération de l''instance telline',4,1);
insert into Suivi values (3,'5/9/2019','Attente de confirmation de l''inscription des étudiants',4,1);
insert into Suivi values (4,'6/9/2019','Création des comptes',5,1);
insert into Suivi values (5,'7/9/2019','Envoi des comptes à l''enseignant',3,1);



insert into Ticket values (2,'4/9/2019','4/9/2019',null,'Regénération de compte oracle','Bonjour, Serait-il possible de recréer le compte de l''étudiant 2567892 qui semble ne pas fonctionner ? Merci',
        'demande',2,'internet','en cours',null,1,4);

insert into Observer values (5,2);

insert into Attribuer values (4,2,'4/9/2019',null);
insert into Attribuer values (5,2,'4/9/2019',null);

insert into Suivi values (6,'4/9/2019','Vérification du compte',4,2);
insert into Suivi values (7,'5/9/2019','Regénération du compte',4,2);



insert into Ticket values (3,'6/9/2019','6/9/2019','7/9/2019','Problème installation Neo4j salle U4-201','Bonjour, Neo4j est non fonctionnel en salle U4-201',
    'incident',5,'internet','résolu',null,3,3);

insert into Observer values (4,3);

insert into Attribuer values (3,3,'6/9/2019',null);
insert into Attribuer values (6,3,'6/9/2019',null);

insert into Suivi values (8,'6/9/2019','Vérification de la salle',6,3);
insert into Suivi values (9,'6/9/2019','Relance de l''installation',6,3);
insert into Suivi values (10,'6/9/2019','Installation OK',6,3);



insert into Ticket values (4,'6/9/2019','6/9/2019',null,'Ouverture salle U3-205','La porte de la salle U3-205 est bloquée',
    'incident',5,'téléphonie','en cours',null,2,9);

insert into Attribuer values (9,4,'6/9/2019',null);

insert into Suivi values (11,'6/9/2019','Vérification de la salle',9,4);
insert into Suivi values (12,'6/9/2019','Appel des services techniques et mise en attente',9,4);



insert into Ticket values (5,'10/9/2019','10/9/2019','11/9/2019','Automatic message - Wifi','Detected problem with Wifi U567942',
    'incident',5,'automatique','clos',null,null,8);

insert into Attribuer values (8,5,'10/9/2019','11/9/2019');

insert into Suivi values (13,'10/9/2019','Vérification de la borne',8,5);
insert into Suivi values (14,'10/9/2019','Reboot',8,5);
insert into Suivi values (15,'11/9/2019','Cloture du ticket',8,5);




insert into Ticket values (6,'13/9/2019','16/9/2019','18/9/2019','Demande d''installation de MongoDB dans les salles U3','Pourriez-vous installer MOngoDB dans les salles',
        'demande',2,'internet','clos','merci',1,3);

insert into Observer values (3,6);
insert into Observer values (4,6);

insert into Attribuer values (3,6,'16/9/2019','18/9/2019');
insert into Attribuer values (4,6,'16/9/2019','18/9/2019');
insert into Attribuer values (5,6,'17/9/2019','18/9/2019');

insert into Suivi values (16,'16/9/2019','Téléchargement des programmes d''installation',4,6);
insert into Suivi values (17,'16/9/2019','Vérification des besoins en machines',4,6);
insert into Suivi values (18,'16/9/2019','Installation sur image de test',4,6);
insert into Suivi values (19,'17/9/2019','Test de l''image de test',4,6);
insert into Suivi values (20,'18/9/2019','Deploiement',4,6);
insert into Suivi values (21,'17/9/2019','Test de l''image de test',5,6);
insert into Suivi values (22,'18/9/2019','Cloture du ticket',5,6);




insert into Ticket values (7,'13/9/2019','14/9/2019',null,'Installation de neo4j sur les salles du bâtiment U1','Pourriez-vous installer Neo4j dans les salles de U1 ? Les Tps commencent la semaine prochaine',
        'demande',4,'internet','en cours',null,1,2);


insert into Attribuer values (3,7,'14/9/2019',null);



commit;