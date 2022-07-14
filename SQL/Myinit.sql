CREATE SCHEMA tg;
CREATE TABLE tg.Utilisateur
(
    cip CHAR(8) NOT NULL,
    nom VARCHAR(255) NOT NULL,
    prenom VARCHAR(255) NOT NULL,
    courriel VARCHAR(255) NOT NULL,
    PRIMARY KEY (cip),
    UNIQUE (courriel)
);

CREATE TABLE tg.Role
(
    Nom VARCHAR(255) NOT NULL,
    id SERIAL,
    PRIMARY KEY (id)
);

CREATE TABLE tg.Log
(
    timestamp TIMESTAMPTZ NOT NULL,
    message VARCHAR(255) NOT NULL,
    id SERIAL,
    PRIMARY KEY (id)
);

CREATE TABLE tg.Session
(
    code VARCHAR(3) NOT NULL,
    PRIMARY KEY (code)
);

CREATE TABLE tg.Plage
(
    debut TIMESTAMPTZ NOT NULL,
    fin TImESTAMPTZ NOT NULL,
    id SERIAL,
    PRIMARY KEY (id)
);

CREATE TABLE tg.Role_utilisateur
(
    role_id INT NOT NULL,
    cip CHAR(8) NOT NULL,
    PRIMARY KEY (role_id, cip),
    FOREIGN KEY (role_id) REFERENCES tg.Role(id),
    FOREIGN KEY (cip) REFERENCES tg.Utilisateur(cip)
);

CREATE TABLE tg.Disponibilité_Utilisateur
(
    cip CHAR(8) NOT NULL,
    id_plage INT NOT NULL,
    PRIMARY KEY (cip, id_plage),
    FOREIGN KEY (cip) REFERENCES tg.Utilisateur(cip),
    FOREIGN KEY (id_plage) REFERENCES tg.Plage(id)
);

CREATE TABLE tg.APP
(
    id SERIAL,
    numero VARCHAR(20) NOT NULL,
    nom VARCHAR(255) NOT NULL,
    session_code VARCHAR(3) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (session_code) REFERENCES tg.Session(code)
);

CREATE TABLE tg.Tutorat
(
    date TIMESTAMP NOT NULL,
    id SERIAL,
    numero INT NOT NULL,
    APP_id INT NOT NULL,
    plage_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (APP_id) REFERENCES tg.APP(id),
    FOREIGN KEY (plage_id) REFERENCES tg.Plage(id)
);

CREATE TABLE tg.Tutorat_Utilisateur
(
    cip CHAR(8) NOT NULL,
    tutorat_id INT NOT NULL,
    PRIMARY KEY (cip, tutorat_id),
    FOREIGN KEY (cip) REFERENCES tg.Utilisateur(cip),
    FOREIGN KEY (tutorat_id) REFERENCES tg.Tutorat(id)
);

CREATE TABLE tg.departement_utilisateurs
(
    cip VARCHAR(8) NOT NULL,
    departement_id VARCHAR(4) NOT NULL,
    PRIMARY KEY (cip, departement_id),
    FOREIGN KEY (cip) REFERENCES tg.Utilisateur(cip)
);

CREATE TABLE tg.Echange
(
    timestamp TIMESTAMPTZ NOT NULL,
    id SERIAL,
    demandeur VARCHAR(8),
    cible VARCHAR(8),
    tutorat_demandeur int,
    tutorat_cibe int,
    confirme int,
    -- 1 confirme  , 0 en attente, -1 annule
    PRIMARY KEY (id),
    FOREIGN KEY (tutorat_demandeur) REFERENCES tg.Tutorat(id),
    FOREIGN KEY (tutorat_cibe) REFERENCES tg.Tutorat(id),
    FOREIGN KEY (demandeur) REFERENCES tg.Utilisateur(cip),
    FOREIGN KEY (cible) REFERENCES tg.Utilisateur(cip)
);


CREATE INDEX ind_courriel_utilisateur ON tg.Utilisateur(courriel);
CREATE INDEX ind_nom_prenom_utilisateur ON tg.Utilisateur(nom,prenom);
CREATE INDEX ind_numero_tutorat ON tg.Tutorat(numero);
CREATE INDEX ind_numero_app ON tg.APP(numero);


CREATE FUNCTION tg.getGroupeTutoratHeure(
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
        INNER JOIN tg.tutorat_utilisateur tu on tg.Utilisateur.cip = tu.cip
        INNER JOIN tg.Tutorat T on tu.tutorat_id = T.id
        INNER JOIN tg.APP A on A.id = T.APP_id
        INNER JOIN tg.Session S on A.session_code = S.code
        INNER JOIN tg.Plage P on T.plage_id = P.id
        WHERE tg.getGroupeTutoratHeure.date = T.date
        AND tg.getGroupeTutoratHeure.debut = p.debut
        AND tg.getGroupeTutoratHeure.app = A.numero
        AND tg.getGroupeTutoratHeure.session = S.code;
END;
$$
    LANGUAGE 'plpgsql';

CREATE FUNCTION tg.getHoraireUtilisateur(
    cip VARCHAR(8)
)
    RETURNS TABLE (
                    idTutorat INT,
                    dateTutorat TIMESTAMP,
                    numeroTutorat INT,
                    debutTutorat TIMESTAMPTZ,
                    numeroAPP VARCHAR(8),
                    sessionApp VARCHAR(3)
                  )
AS
$$
BEGIN
    RETURN QUERY SELECT
        T.id,
        T.date,
        T.numero,
        P.debut,
        A.numero,
        S.code
                FROM tg.Utilisateur U
                INNER JOIN tg.Tutorat_Utilisateur TU on U.cip = TU.cip
                INNER JOIN tg.Tutorat T on T.id = TU.tutorat_id
                INNER JOIN tg.Plage P on P.id = T.plage_id
                INNER JOIN tg.APP A on A.id = T.APP_id
                INNER JOIN tg.Session S on S.code = A.session_code
                WHERE tg.getHoraireUtilisateur.cip =U.cip;
END;
$$
    LANGUAGE 'plpgsql';

CREATE FUNCTION tg.validationCIP (
    cip VARCHAR(8)
)
    RETURNS TABLE
    (
        valid BOOLEAN
    )
AS
$$
BEGIN
    SELECT
        CASE WHEN EXISTS
            (
                SELECT * FROM tg.Utilisateur U WHERE U.cip = tg.validationCIP.cip
            )
            THEN 'TRUE'
            ELSE 'FALSE'
        END;
END;
$$
    LANGUAGE  'plpgsql';

CREATE FUNCTION tg.validationCIPCour (
    cip VARCHAR(8),
    cour INT
)
    RETURNS TABLE
            (
                valid BOOLEAN
            )
AS
$$
BEGIN
    SELECT
        CASE WHEN EXISTS
            (
                SELECT * FROM tg.tutorat_utilisateur tu
                        WHERE tu.cip = tg.validationCIPCour.cip
                        AND tu.tutorat_id = tg.validationCIPCour.cour
            )
                 THEN 'TRUE'
             ELSE 'FALSE'
            END;
END;
$$
    LANGUAGE  'plpgsql';

CREATE FUNCTION tg.validationSession (
    session VARCHAR(3)
)
    RETURNS TABLE
            (
                valid BOOLEAN
            )
AS
$$
BEGIN
    SELECT
        CASE WHEN EXISTS
            (
                SELECT * FROM tg.Session S
                WHERE s.code = tg.validationSession.session
            )
                 THEN 'TRUE'
             ELSE 'FALSE'
            END;
END;
$$
    LANGUAGE  'plpgsql';

CREATE FUNCTION returnHeureID
    (
        id INT
    )
RETURNS TABLE
    (
        heure TIMESTAMPTZ
    )
AS
$$BEGIN
    RETURN QUERY SELECT
                    P.debut
                    FROM tg.plage P
                    WHERE P.id = tg.returnHeureID.id;
END;$$
    LANGUAGE 'plpgsql';


CREATE FUNCTION tg.validationCour (
    app VARCHAR(8),
    session VARCHAR(3)
)
    RETURNS TABLE
            (
                valid BOOLEAN
            )
AS
$$
BEGIN
    SELECT
        CASE WHEN EXISTS
            (
                SELECT * FROM tg.app A
                WHERE A.numero = tg.validationCour.app
                AND A.session_code = tg.validationCour.session
            )
                 THEN 'TRUE'
             ELSE 'FALSE'
            END;
END;
$$
    LANGUAGE  'plpgsql';

CREATE FUNCTION tg.getGroupeTutoratJour(
    date DATE,
    app VARCHAR(8),
    session VARCHAR(3)
)
    RETURNS TABLE (
                    cip VARCHAR,
                    nom VARCHAR,
                    prenom VARCHAR,
                    heure TIMESTAMPTZ
                  )
AS
$$
BEGIN
    RETURN QUERY SELECT
                     U.cip,
                     U.nom,
                     U.prenom,
                     P.debut
                 FROM tg.Utilisateur U
                          INNER JOIN tg.tutorat_utilisateur tu on U.cip = tu.cip
                          INNER JOIN tg.Tutorat T on tu.tutorat_id = T.id
                          INNER JOIN tg.APP A on A.id = T.APP_id
                          INNER JOIN tg.Session S on A.session_code = S.code
                          INNER JOIN tg.Plage P on T.plage_id = P.id
                 WHERE tg.getGroupeTutoratHeure.date = T.date
                   AND tg.getGroupeTutoratHeure.app = A.numero
                   AND tg.getGroupeTutoratHeure.session = S.code;
END;
$$
    LANGUAGE 'plpgsql';

CREATE FUNCTION tg.getNotif
    (
        cip VARCHAR(8)
    )
    RETURNS TABLE
    (
        time TIMESTAMPTZ,
        id INT,
        demandeur VARCHAR(8),
        cible VARCHAR(8),
        tutorat_demandeur INT,
        tutorat_cible INT,
        confirme INT
    )
AS
    $$BEGIN
        RETURN QUERY SELECT
                         E.timestamp,
                         E.id,
                         E.demandeur,
                         E.cible,
                         E.tutorat_demandeur,
                         E.tutorat_cibe,
                         E.confirme
                         FROM tg.echange E
                        WHERE tg.getNotif.cip =E.cible;
    END;$$
    LANGUAGE 'plpgsql'


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