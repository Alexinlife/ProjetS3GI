--Creation des utilisateur
INSERT INTO public.utilisateur SELECT DISTINCT extern_presence.students.cip, SPLIT_PART(extern_presence.students.name, ', ', 1), SPLIT_PART(extern_presence.students.name,', ', 2), CONCAT(extern_presence.students.cip, '@usherbrooke.ca') FROM extern_presence.students UNION SELECT DISTINCT extern_presence.lecturers.cip, SPLIT_PART(extern_presence.lecturers.name, ', ', 1), SPLIT_PART(extern_presence.lecturers.name,', ', 2), CONCAT(extern_presence.lecturers.cip, '@usherbrooke.ca') FROM extern_presence.lecturers;
--Assignation des departements
INSERT INTO public.departement_utilisateurs SELECT DISTINCT extern_presence.students.cip, extern_presence.students.department_id FROM extern_presence.students UNION SELECT DISTINCT extern_presence.lecturers.cip, extern_presence.lecturers.department_id FROM extern_presence.lecturers;
--Creation des roles
INSERT INTO public.role(nom) VALUES ('Étudiant'), ('Tuteur');
--Assignation des role
INSERT INTO public.role_utilisateur SELECT DISTINCT public.role.id, extern_presence.students.cip FROM extern_presence.students, public.role WHERE publiC.role.nom = 'Étudiant' UNION SELECT DISTINCT public.role.id, extern_presence.lecturers.cip FROM extern_presence.lecturers, public.role WHERE public.role.nom = 'Tuteur';
--Creation des sessions
INSERT INTO public.session SELECT DISTINCT extern_presence.lecturers.trimester_id FROM extern_presence.lecturers UNION SELECT DISTINCT extern_presence.students.trimester_id FROM extern_presence.students UNION SELECT DISTINCT extern_presence.group_appointments.trimester_id FROM extern_presence.group_appointments UNION SELECT DISTINCT extern_presence.group_students.trimester_id FROM extern_presence.group_students UNION SELECT DISTINCT extern_presence.group_tutorat_students.trimester_id FROM extern_presence.group_tutorat_students UNION SELECT DISTINCT extern_presence.units.trimester_id FROM extern_presence.units;
--Creation des apps
INSERT INTO public.app (numero,nom, session_code) SELECT DISTINCT extern_presence.units.unit_id, extern_presence.units.profile, extern_presence.units.trimester_id FROM extern_presence.units, public.app_id_seq;
--Creation des plages
INSERT INTO public.plage (debut, fin) SELECT DISTINCT extern_presence.group_appointments.begin, (extern_presence.group_appointments.begin + '1:30') FROM extern_presence.group_appointments;
--Creation des tutorats
INSERT INTO public.tutorat (date, numero, app_id, plage_id) SELECT DISTINCT extern_presence.group_appointments.begin, extern_presence.group_appointments.activity_id, public.app.id, public.plage.id FROM extern_presence.group_appointments INNER JOIN public.plage ON public.plage.debut = extern_presence.group_appointments.begin INNER JOIN public.app ON public.app.numero = extern_presence.group_appointments.unit_id;
