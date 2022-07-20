--Creation des utilisateur
INSERT INTO utilisateur SELECT DISTINCT extern_presence.students.cip, SPLIT_PART(extern_presence.students.name, ', ', 1), SPLIT_PART(extern_presence.students.name,', ', 2), CONCAT(extern_presence.students.cip, '@usherbrooke.ca') FROM extern_presence.students UNION SELECT DISTINCT extern_presence.lecturers.cip, SPLIT_PART(extern_presence.lecturers.name, ', ', 1), SPLIT_PART(extern_presence.lecturers.name,', ', 2), CONCAT(extern_presence.lecturers.cip, '@usherbrooke.ca') FROM extern_presence.lecturers;
--Assignation des departements
INSERT INTO departement_utilisateurs SELECT DISTINCT extern_presence.students.cip, extern_presence.students.department_id FROM extern_presence.students UNION SELECT DISTINCT extern_presence.lecturers.cip, extern_presence.lecturers.department_id FROM extern_presence.lecturers;
--Creation des roles
INSERT INTO role(nom) VALUES ('Étudiant'), ('Tuteur');
--Assignation des role
INSERT INTO role_utilisateur SELECT DISTINCT role.id, extern_presence.students.cip FROM extern_presence.students, role WHERE role.nom = 'Étudiant' UNION SELECT DISTINCT role.id, extern_presence.lecturers.cip FROM extern_presence.lecturers, role WHERE role.nom = 'Tuteur';
--Creation des sessions
INSERT INTO session SELECT DISTINCT extern_presence.lecturers.trimester_id FROM extern_presence.lecturers UNION SELECT DISTINCT extern_presence.students.trimester_id FROM extern_presence.students UNION SELECT DISTINCT extern_presence.group_appointments.trimester_id FROM extern_presence.group_appointments UNION SELECT DISTINCT extern_presence.group_students.trimester_id FROM extern_presence.group_students UNION SELECT DISTINCT extern_presence.group_tutorat_students.trimester_id FROM extern_presence.group_tutorat_students UNION SELECT DISTINCT extern_presence.units.trimester_id FROM extern_presence.units;
--Creation des apps
INSERT INTO app (numero,nom, session_code) SELECT DISTINCT extern_presence.units.unit_id, extern_presence.units.profile, extern_presence.units.trimester_id FROM extern_presence.units, app_id_seq;
--Creation des plages
INSERT INTO plage (debut, fin) SELECT DISTINCT extern_presence.group_appointments.begin, (extern_presence.group_appointments.begin + '1:30') FROM extern_presence.group_appointments;
--Creation des tutorats
INSERT INTO tutorat (date, numero, app_id, plage_id) SELECT DISTINCT extern_presence.group_appointments.begin, extern_presence.group_appointments.activity_id, app.id, plage.id FROM extern_presence.group_appointments INNER JOIN plage ON plage.debut = extern_presence.group_appointments.begin INNER JOIN app ON app.numero = extern_presence.group_appointments.unit_id;
--Assignation des tutorats
INSERT INTO tutorat_utilisateur (cip, tutorat_id) SELECT DISTINCT gs.cip, t.id FROM extern_presence.group_students gs INNER JOIN extern_presence.group_appointments ga ON gs.grouping = ga.grouping AND gs.no = ga.no AND gs.unit_id = ga.unit_id AND gs.trimester_id = ga.trimester_id AND gs.department_id = ga.department_id INNER JOIN app A ON A.numero = ga.unit_id AND A.numero = gs.unit_id INNER JOIN tutorat t on A.id = t.app_id INNER JOIN plage p on p.id = t.plage_id AND P.debut = ga.begin;
--Création de dispo
INSERT INTO disponibilité_utilisateur (cip, idtutorat) VALUES ('doyf1501', 61), ('laja1501', 1490), ('pelf1504', 61);

--INSERT INTO tutorat_utilisateur (cip, tutorat_id) VALUES ('doyf1501', 1), ('doyf1501', 2), ('doyf1501', 3), ('laja1501', 2), ('laja1501', 3), ('laja1501', 4), ('pelf1504', 3), ('pelf1504', 4), ('pelf1504', 5);
