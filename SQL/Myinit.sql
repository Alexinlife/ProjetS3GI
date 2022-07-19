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

CREATE TABLE Echange
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
    FOREIGN KEY (tutorat_demandeur) REFERENCES Tutorat(id),
    FOREIGN KEY (tutorat_cibe) REFERENCES Tutorat(id),
    FOREIGN KEY (demandeur) REFERENCES Utilisateur(cip),
    FOREIGN KEY (cible) REFERENCES Utilisateur(cip)
);


CREATE INDEX ind_courriel_utilisateur ON Utilisateur(courriel);
CREATE INDEX ind_nom_prenom_utilisateur ON Utilisateur(nom,prenom);
CREATE INDEX ind_numero_tutorat ON Tutorat(numero);
CREATE INDEX ind_numero_app ON APP(numero);


CREATE FUNCTION getGroupeTutoratHeure(
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
        WHERE getGroupeTutoratHeure.date = T.date
        AND getGroupeTutoratHeure.debut = p.debut
        AND getGroupeTutoratHeure.app = A.numero
        AND getGroupeTutoratHeure.session = S.code;
END;
$$
    LANGUAGE 'plpgsql';

CREATE FUNCTION getHoraireUtilisateur(
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
                FROM Utilisateur U
                INNER JOIN Tutorat_Utilisateur TU on U.cip = TU.cip
                INNER JOIN Tutorat T on T.id = TU.tutorat_id
                INNER JOIN Plage P on P.id = T.plage_id
                INNER JOIN APP A on A.id = T.APP_id
                INNER JOIN Session S on S.code = A.session_code
                WHERE getHoraireUtilisateur.cip =U.cip;
END;
$$
    LANGUAGE 'plpgsql';

CREATE FUNCTION validationCIP (
    cip VARCHAR(8)
)
    RETURNS BOOLEAN
AS
$$
BEGIN
        CASE WHEN EXISTS
            (
                SELECT * FROM Utilisateur U WHERE U.cip = 'doyf1501'
            )
            THEN RETURN TRUE;
            ELSE RETURN FALSE;
        END CASE;
END$$
    LANGUAGE  'plpgsql';

CREATE FUNCTION validationCIPTutorat(
    cip VARCHAR(8),
    tutoratID INT
)
    RETURNS BOOLEAN
AS
$$
BEGIN

        CASE WHEN EXISTS
            (
                SELECT * FROM tutorat_utilisateur tu
                        WHERE tu.cip = validationCIPTutorat.cip
                        AND tu.tutorat_id = validationCIPTutorat.tutoratID
            )
            THEN RETURN TRUE;
            ELSE RETURN FALSE;
            END CASE;
END
$$
    LANGUAGE  'plpgsql';

CREATE FUNCTION validationSession (
    session VARCHAR(3)
)
    RETURNS BOOLEAN
AS
$$
BEGIN
        CASE WHEN EXISTS
            (
                SELECT * FROM Session S
                WHERE s.code = validationSession.session
            )
            THEN RETURN TRUE;
            ELSE RETURN FALSE;
            END CASE;
END
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
                    FROM plage P
                    WHERE P.id = returnHeureID.id;
END;$$
    LANGUAGE 'plpgsql';


CREATE FUNCTION validationCour (
    app VARCHAR(8),
    session VARCHAR(3)
)
    RETURNS BOOLEAN
AS
$$
BEGIN
        CASE WHEN EXISTS
            (
                SELECT * FROM app A
                WHERE A.numero = validationCour.app
                AND A.session_code = validationCour.session
            )
            THEN RETURN TRUE;
            ELSE RETURN FALSE;
            END CASE;
END
$$
    LANGUAGE 'plpgsql';

CREATE FUNCTION validationTutorat (
    idTutorat INT
)

    RETURNS BOOLEAN
AS
$$
BEGIN
        CASE WHEN EXISTS
            (
                SELECT * FROM tutorat T
                WHERE T.id = validationTutorat.idTutorat
            )
            THEN RETURN TRUE;
            ELSE RETURN FALSE;
            END CASE;
END
$$
    LANGUAGE 'plpgsql';

CREATE FUNCTION validationForEchangeRapide
(
    cip1 VARCHAR(8),
    cip2 VARCHAR(8),
    app VARCHAR(8),
    session VARCHAR(3),
    idTutorat1 INT,
    idTutorat2 INT
)
    RETURNS TABLE
    (
        valid BOOLEAN
    )
AS
    $$BEGIN
        RETURN QUERY SELECT
    CASE WHEN validationCIP(validationForEchangeRapide.cip1)
        AND validationCIP(validationForEchangeRapide.cip2)
        AND validationCour(validationForEchangeRapide.app, validationForEchangeRapide.session)
        AND validationTutorat(validationForEchangeRapide.idTutorat1)
        AND validationTutorat(validationForEchangeRapide.idTutorat2)
        AND validationCIPTutorat(validationForEchangeRapide.cip1, validationForEchangeRapide.idTutorat1)
        AND validationCIPTutorat(validationForEchangeRapide.cip2, validationForEchangeRapide.idTutorat2)
        AND validationForEchangeRapide.cip1 != validationForEchangeRapide.cip2
        THEN TRUE
        ELSE FALSE
        END;
end;$$ LANGUAGE 'plpgsql';

CREATE FUNCTION getGroupeTutoratJour(
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
                 FROM Utilisateur U
                          INNER JOIN tutorat_utilisateur tu on U.cip = tu.cip
                          INNER JOIN Tutorat T on tu.tutorat_id = T.id
                          INNER JOIN APP A on A.id = T.APP_id
                          INNER JOIN Session S on A.session_code = S.code
                          INNER JOIN Plage P on T.plage_id = P.id
                 WHERE getGroupeTutoratJour.date = T.date
                   AND getGroupeTutoratJour.app = A.numero
                   AND getGroupeTutoratJour.session = S.code;
END;
$$
    LANGUAGE 'plpgsql';

CREATE FUNCTION getNotif
    (
        cip VARCHAR(8)
    )
    RETURNS TABLE
    (
        temps TIMESTAMPTZ,
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
                         FROM echange E
                        WHERE getNotif.cip =E.cible;
    END;$$
    LANGUAGE 'plpgsql';


CREATE FUNCTION getDipsoTutorat(
    date DATE,
    debut TIMESTAMPTZ,
    app VARCHAR(8),
    session VARCHAR(3)
)
RETURNS TABLE
(
    idTutorat INT,
    cip VARCHAR(8)
)
AS
$$
BEGIN

END;
$$
    LANGUAGE 'plpgsql';

