--Creation des utilisateur
INSERT INTO tg.utilisateur SELECT DISTINCT extern_presence.students.cip, SPLIT_PART(extern_presence.students.name, ', ', 1), SPLIT_PART(extern_presence.students.name,', ', 2), CONCAT(extern_presence.students.cip, '@usherbrooke.ca') FROM extern_presence.students UNION SELECT DISTINCT extern_presence.lecturers.cip, SPLIT_PART(extern_presence.lecturers.name, ', ', 1), SPLIT_PART(extern_presence.lecturers.name,', ', 2), CONCAT(extern_presence.lecturers.cip, '@usherbrooke.ca') FROM extern_presence.lecturers;
--Assignation des departements
INSERT INTO tg.departement_utilisateurs SELECT DISTINCT extern_presence.students.cip, extern_presence.students.department_id FROM extern_presence.students UNION SELECT DISTINCT extern_presence.lecturers.cip, extern_presence.lecturers.department_id FROM extern_presence.lecturers;
--Creation des roles
INSERT INTO tg.role(nom) VALUES ('Étudiant'), ('Tuteur');
--Assignation des role
INSERT INTO tg.role_utilisateur SELECT DISTINCT tg.role.id, extern_presence.students.cip FROM extern_presence.students, tg.role WHERE tg.role.nom = 'Étudiant' UNION SELECT DISTINCT tg.role.id, extern_presence.lecturers.cip FROM extern_presence.lecturers, tg.role WHERE tg.role.nom = 'Tuteur';
--Creation des sessions
INSERT INTO tg.session SELECT DISTINCT extern_presence.lecturers.trimester_id FROM extern_presence.lecturers UNION SELECT DISTINCT extern_presence.students.trimester_id FROM extern_presence.students UNION SELECT DISTINCT extern_presence.group_appointments.trimester_id FROM extern_presence.group_appointments UNION SELECT DISTINCT extern_presence.group_students.trimester_id FROM extern_presence.group_students UNION SELECT DISTINCT extern_presence.group_tutorat_students.trimester_id FROM extern_presence.group_tutorat_students UNION SELECT DISTINCT extern_presence.units.trimester_id FROM extern_presence.units;
--Creation des apps
INSERT INTO tg.app (numero,nom, session_code) SELECT DISTINCT extern_presence.units.unit_id, extern_presence.units.profile, extern_presence.units.trimester_id FROM extern_presence.units, tg.app_id_seq;
--Creation des plages
INSERT INTO tg.plage (debut, fin) SELECT DISTINCT extern_presence.group_appointments.begin, (extern_presence.group_appointments.begin + '1:30') FROM extern_presence.group_appointments;
--Creation des tutorats
INSERT INTO tg.tutorat (date, numero, app_id, plage_id) SELECT DISTINCT extern_presence.group_appointments.begin, extern_presence.group_appointments.activity_id, tg.app.id, tg.plage.id FROM extern_presence.group_appointments INNER JOIN tg.plage ON tg.plage.debut = extern_presence.group_appointments.begin INNER JOIN tg.app ON tg.app.numero = extern_presence.group_appointments.unit_id;
--Assignation des tutorats
--INSERT INTO tg.tutorat_utilisateur (cip, tutorat_id) SELECT DISTINCT extern_presence.group_students.cip, tg.tutorat.id FROM extern_presence.group_students,extern_presence.group_appointments ,tg.tutorat WHERE extern_presence.group_appointments.unit_id = extern_presence.group_students.unit_id AND extern_presence.group_appointments.grouping = extern_presence.group_students.grouping AND extern_presence.group_appointments.no = extern_presence.group_students.no AND extern_presence.group_appointments.activity_id = tg.tutorat.numero;
--INSERT INTO tg.tutorat_utilisateur (cip, tutorat_id) SELECT DISTINCT gs.cip, t.id FROM extern_presence.group_students gs INNER JOIN extern_presence.group_appointments ga ON gs.grouping = ga.grouping AND gs.no = ga.no AND gs.unit_id = ga.unit_id AND gs.trimester_id = ga.trimester_id AND gs.department_id = ga.department_id INNER JOIN tg.tutorat t ON t.numero = ga.activity_id;
INSERT INTO tg.tutorat_utilisateur (cip, tutorat_id) VALUES ('doyf1501', 1), ('doyf1501', 2), ('doyf1501', 3), ('laja1501', 2), ('laja1501', 3), ('laja1501', 4), ('pelf1504', 3), ('pelf1504', 4), ('pelf1504', 5);
