CREATE TABLE Utilisateur
(
    cip CHAR(8) NOT NULL,
    nom VARCHAR(255) NOT NULL,
    prenom VARCHAR(255) NOT NULL,
    courriel VARCHAR(255) NOT NULL,
    PRIMARY KEY (cip),
    UNIQUE (courriel)
);

CREATE TABLE Role
(
    Nom VARCHAR(255) NOT NULL,
    id SERIAL,
    PRIMARY KEY (id)
);

CREATE TABLE Echange
(
    timestamp TIMESTAMPTZ NOT NULL,
    message VARCHAR(255) NOT NULL,
    id SERIAL,
    PRIMARY KEY (id)
);

CREATE TABLE Log
(
    timestamp TIMESTAMPTZ NOT NULL,
    message VARCHAR(255) NOT NULL,
    id SERIAL,
    PRIMARY KEY (id)
);

CREATE TABLE Session
(
    code VARCHAR(3) NOT NULL,
    PRIMARY KEY (code)
);

CREATE TABLE Plage
(
    debut TIMESTAMPTZ NOT NULL,
    fin TImESTAMPTZ NOT NULL,
    id SERIAL,
    PRIMARY KEY (id)
);

CREATE TABLE Role_utilisateur
(
    role_id INT NOT NULL,
    cip CHAR(8) NOT NULL,
    PRIMARY KEY (role_id, cip),
    FOREIGN KEY (role_id) REFERENCES Role(id),
    FOREIGN KEY (cip) REFERENCES Utilisateur(cip)
);

CREATE TABLE Disponibilité_Utilisateur
(
    cip CHAR(8) NOT NULL,
    id_plage INT NOT NULL,
    PRIMARY KEY (cip, id_plage),
    FOREIGN KEY (cip) REFERENCES Utilisateur(cip),
    FOREIGN KEY (id_plage) REFERENCES Plage(id)
);

CREATE TABLE APP
(
    id SERIAL,
    numero VARCHAR(20) NOT NULL,
    nom VARCHAR(255) NOT NULL,
    session_code VARCHAR(3) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (session_code) REFERENCES Session(code)
);

CREATE TABLE Tutorat
(
    date TIMESTAMP NOT NULL,
    id SERIAL,
    numero INT NOT NULL,
    APP_id INT NOT NULL,
    plage_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (APP_id) REFERENCES APP(id),
    FOREIGN KEY (plage_id) REFERENCES Plage(id)
);

CREATE TABLE Tutorat_Utilisateur
(
    cip CHAR(8) NOT NULL,
    tutorat_id INT NOT NULL,
    PRIMARY KEY (cip, tutorat_id),
    FOREIGN KEY (cip) REFERENCES Utilisateur(cip),
    FOREIGN KEY (tutorat_id) REFERENCES Tutorat(id)
);

CREATE TABLE departement_utilisateurs
(
    cip VARCHAR(8) NOT NULL,
    departement_id VARCHAR(4) NOT NULL,
    PRIMARY KEY (cip, departement_id),
    FOREIGN KEY (cip) REFERENCES Utilisateur(cip)
);

CREATE INDEX ind_courriel_utilisateur ON Utilisateur(courriel);
CREATE INDEX ind_nom_prenom_utilisateur ON Utilisateur(nom,prenom);
CREATE INDEX ind_numero_tutorat ON Tutorat(numero);
CREATE INDEX ind_numero_app ON APP(numero);


CREATE FUNCTION get_groupe_tutorat_heure(
    date DATE,
    debut TIMESTAMPTZ,
    app VARCHAR(8),
    session VARCHAR(3)
)
    RETURNS TABLE (
                      cip VARCHAR,
                      nom VARCHAR,
                      prenom VARCHAR
                  )
AS
$$
BEGIN
    RETURN QUERY SELECT
                     Utilisateur.cip,
                     Utilisateur.nom,
                     utilisateur.prenom

    FROM Utilisateur
        INNER JOIN tutorat_utilisateur tu on Utilisateur.cip = tu.cip
        INNER JOIN Tutorat T on tu.tutorat_id = T.id
        INNER JOIN APP A on A.id = T.APP_id
        INNER JOIN Session S on A.session_code = S.code
        INNER JOIN Plage P on T.plage_id = P.id
        WHERE get_groupe_tutorat_heure.date = T.date
        AND get_groupe_tutorat_heure.debut = p.debut
        AND get_groupe_tutorat_heure.app = A.numero
        AND get_groupe_tutorat_heure.session = S.code;
END;
$$
    LANGUAGE 'plpgsql';

CREATE FUNCTION get_groupe_tutorat_jour(
    date DATE,
    app VARCHAR(8),
    session VARCHAR(3)
)e
    RETURNS TABLE (
                      cip VARCHAR,
                      nom VARCHAR,
                      prenom VARCHAR,
                      debut TIMESTAMPTZ
                  )
AS
$$
BEGIN
    RETURN QUERY SELECT
                     U.cip,
                     U.nom,
                     U.prenom,
                     P.debut
                 FROM Utilisateur U, Plage P
                          INNER JOIN tutorat_utilisateur tu on U.cip = tu.cip
                          INNER JOIN Tutorat T on tu.tutorat_id = T.id
                          INNER JOIN APP A on A.id = T.APP_id
                          INNER JOIN Session S on A.session_code = S.code
                 WHERE get_groupe_tutorat_jour.date = T.date
                   AND get_groupe_tutorat_jour.app = A.numero
                   AND get_groupe_tutorat_jour.session = S.code
                   AND T.plage_id = P.id;
END;
$$
    LANGUAGE 'plpgsql';

--CREATE FUNCTION get_dipso_tutorat_plage(
--    date DATE,
--    debut TIMESTAMPTZ,
--    app VARCHAR(8),
--    session VARCHAR(3)
--)
--AS
--$$
--BEGIN
--
--END;
--$$
--    LANGUAGE 'plpgsql';


--CREATE schema sch;
--CREATE TABLE sch.dept_tri (department_id VARCHAR(4), trimester_id VARCHAR(3), PRIMARY KEY (department_id, trimester_id));
--INSERT INTO sch.dept_tri
--    SELECT DISTINCT department_id, trimester_id FROM extern_presence.group_appointments;