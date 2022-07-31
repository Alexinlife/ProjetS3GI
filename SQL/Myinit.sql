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
    timestamp TIMESTAMP NOT NULL,
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
    debut TIMESTAMP NOT NULL,
    fin timestamp NOT NULL,
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
    date timestamp NOT NULL,
    id SERIAL,
    numero INT NOT NULL,
    APP_id INT NOT NULL,
    plage_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (APP_id) REFERENCES APP(id),
    FOREIGN KEY (plage_id) REFERENCES Plage(id)
);

CREATE TABLE Disponibilité_Utilisateur
(
    cip CHAR(8) NOT NULL,
    idTutorat INT NOT NULL,
    PRIMARY KEY (cip, idtutorat),
    FOREIGN KEY (cip) REFERENCES Utilisateur(cip),
    FOREIGN KEY (idtutorat) REFERENCES tutorat(id)
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
    timestamp TIMESTAMP NOT NULL,
    id SERIAL,
    demandeur VARCHAR(8),
    cible VARCHAR(8),
    tutorat_demandeur int,
    tutorat_cible int,
    confirme int,
    -- 1 confirme  , 0 en attente, -1 annule
    PRIMARY KEY (id),
    FOREIGN KEY (tutorat_demandeur) REFERENCES Tutorat(id),
    FOREIGN KEY (tutorat_cible) REFERENCES Tutorat(id),
    FOREIGN KEY (demandeur) REFERENCES Utilisateur(cip),
    FOREIGN KEY (cible) REFERENCES Utilisateur(cip)
);

CREATE TABLE matchmaking
(
    cip_receveur VARCHAR(8),
    tutorat_receveur INT,
    tutorat_souhaite  INT,
    FOREIGN KEY (cip_receveur) REFERENCES Utilisateur (cip),
    FOREIGN KEY (tutorat_receveur) REFERENCES Tutorat (id),
    FOREIGN KEY (tutorat_souhaite) REFERENCES Tutorat (id)
);

CREATE INDEX ind_courriel_utilisateur ON Utilisateur(courriel);
CREATE INDEX ind_nom_prenom_utilisateur ON Utilisateur(nom,prenom);
CREATE INDEX ind_numero_tutorat ON Tutorat(numero);
CREATE INDEX ind_numero_app ON APP(numero);


CREATE FUNCTION getGroupeTutoratHeure(
    date DATE,
    debut TIMESTAMP,
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
                    dateTutorat timestamp,
                    numeroTutorat INT,
                    debutTutorat timestamp,
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

CREATE FUNCTION getHoraireUtilisateurExclu(
    date timestamp,
    app varchar(8),
    session varchar(3),
    cip VARCHAR(8)
)
    RETURNS TABLE (
                    plage timestamp,
                    plage_id int
                  )
AS
$$
BEGIN
    RETURN QUERY SELECT
                     P.debut,
                     T.plage_id

                 from tutorat T
                    INNER JOIN app A on A.id = T.app_id
                    INNER JOIN plage P on T.plage_id = P.id
                    INNER JOIN session S on S.code = A.session_code
                    INNER JOIN Tutorat_Utilisateur TU on T.id = TU.tutorat_id
                 where Date(getHoraireUtilisateurExclu.date) = date(T.date)
                 and getHoraireUtilisateurExclu.app = A.numero
                 and getHoraireUtilisateurExclu.session = S.code
                 AND getHoraireUtilisateurExclu.cip != TU.cip;
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
                SELECT * FROM Utilisateur U WHERE U.cip = validationCIP.cip
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
        heure TIMESTAMP
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

CREATE OR replace FUNCTION validationForEchangeRapide
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
        valid boolean
    )
AS
    $$BEGIN
    RETURN QUERY SELECT
        validationCIP(validationForEchangeRapide.cip1)
        AND validationCIP(validationForEchangeRapide.cip2)
        AND validationCour(validationForEchangeRapide.app, validationForEchangeRapide.session)
        AND validationTutorat(validationForEchangeRapide.idTutorat1)
        AND validationTutorat(validationForEchangeRapide.idTutorat2)
        AND validationCIPTutorat(validationForEchangeRapide.cip1, validationForEchangeRapide.idTutorat1)
        AND validationCIPTutorat(validationForEchangeRapide.cip2, validationForEchangeRapide.idTutorat2)
        AND validationForEchangeRapide.cip1 != validationForEchangeRapide.cip2
        AS valid;
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
                    heure TIMESTAMP
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

CREATE FUNCTION getEchange
    (
        cip VARCHAR(8)
    )
    RETURNS TABLE
    (
        temps TIMESTAMP,
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
                         E.tutorat_cible,
                         E.confirme
                         FROM echange E
                        WHERE getEchange.cip =E.cible;
    END;$$
    LANGUAGE 'plpgsql';


CREATE or replace FUNCTION getDispoTutorat(
    date DATE,
    app VARCHAR(8),
    session VARCHAR(3)
)
RETURNS TABLE
(
    cip VARCHAR(8),
    idTutorat INT
)
AS
$$
    DECLARE NbTutorat INT;
    DECLARE nbMAX INT;
    DECLARE cnt INT;
    DECLARE nbPersonne
BEGIN
    CREATE TEMP TABLE temporaire (cip VARCHAR(8),idTutorat INT, PRIMARY KEY (cip, idTutorat)) ON COMMIT DROP;
    INSERT INTO temporaire SELECT DU.cip, DU.idTutorat FROM disponibilité_utilisateur DU
        INNER JOIN tutorat T ON t.id = DU.idtutorat
        INNER JOIN APP A on A.id = T.APP_id
        INNER JOIN Session S on S.code = A.session_code
        INNER JOIN Plage P on P.id::integer = T.plage_id::integer
        WHERE T.date = getDispoTutorat.date
        AND A.numero = getDispoTutorat.app
        AND S.code = getDispoTutorat.session;
    CREATE TEMP TABLE listeTutorat (idTuto INT) ON COMMIT DROP;
    INSERT INTO listeTutorat SELECT T.id FROM Tutorat T
        INNER JOIN APP A2 on A2.id = T.APP_id
        INNER JOIN Session S2 on S2.code = A2.session_code
        WHERE t.date = getDispoTutorat.date
        AND A2.numero = getDispoTutorat.app
        AND S2.code = getDispoTutorat.session;
    NbTutorat := (SELECT COUNT(*) FROM listeTutorat);
    cnt := 0;
    nbMax = 0;
    FOR cnt IN 1..nbTutorat LOOP
        nbPersonne :=
        (
        SELECT COUNT(*) FROM tutorat_utilisateur
        )
    END LOOP;
    --nbMax := max()
    RETURN QUERY SELECT T.cip, T.idTutorat FROM temporaire T;
END;
$$
    LANGUAGE 'plpgsql';

CREATE FUNCTION getListTuto
(
    numero_tuto INT,
    app_id INT
)
RETURNS TABLE
(
    id INT,
    date TIMESTAMP,
    plage_id INT
)
AS
$$
BEGIN
    RETURN QUERY SELECT
        T.id, T.date, T.plage_id
    FROM Tutorat T
    WHERE T.numero = getListTuto.numero_tuto
        AND T.app_id = getListTuto.app_id;
END;
$$
    LANGUAGE 'plpgsql';

CREATE FUNCTION makeEchange
(
    cip1 VARCHAR(8),
    cip2 VARCHAR(8),
    app VARCHAR(8),
    session VARCHAR(3)
)
RETURNS
    BOOLEAN
AS $$
    DECLARE tutorat1 INT;
    DECLARE tutorat2 INT;
BEGIN
    tutorat1 := (SELECT TU.tutorat_id FROM tutorat_utilisateur TU
        INNER JOIN Tutorat T ON TU.tutorat_id = T.id
        INNER JOIN APP A on T.APP_id = A.id
        INNER JOIN Session S on S.code = A.session_code
        WHERE TU.cip = makeechange.cip1
        AND A.numero = makeechange.app
        AND S.code = makeechange.session);
    tutorat2 := (SELECT TU.tutorat_id FROM tutorat_utilisateur TU
        INNER JOIN Tutorat T ON TU.tutorat_id = T.id
        INNER JOIN APP A on T.APP_id = A.id
        INNER JOIN Session S on S.code = A.session_code
        WHERE TU.cip = makeechange.cip2
        AND A.numero = makeechange.app
        AND S.code = makeechange.session);
    DELETE FROM Tutorat_Utilisateur TU
        WHERE (TU.tutorat_id = tutorat1 AND TU.cip = makeechange.cip1)
        OR (TU.tutorat_id =tutorat2 AND TU.cip = makeEchange.cip2);
    UPDATE tutorat_utilisateur TU SET tutorat_id = tutorat2
        WHERE TU.cip = makeechange.cip1 AND TU.tutorat_id = tutorat1;
    UPDATE tutorat_utilisateur TU SET tutorat_id = tutorat1
        WHERE TU.cip = makeechange.cip2 AND TU.tutorat_id = tutorat2;
    INSERT INTO log (timestamp, message) VALUES (NOW(),format('Echange cip : %s , %s Tutorat : %s  , ' ||
        '%s APP : %s Session : %s ', cip1, cip2, tutorat1, tutorat2, app, session));
    RETURN TRUE;
end;$$ LANGUAGE 'plpgsql';

CREATE FUNCTION checkInMatchMaking
(
    plageIDDemandeur INT,
    plageIDReceveur INT
)
RETURNS TABLE
(
    cip VARCHAR(8)
)
AS $$
BEGIN
    RETURN QUERY SELECT M.cip_receveur FROM matchmaking M
        WHERE M.tutorat_receveur = checkInMatchMaking.plageIDReceveur
        AND m.tutorat_souhaite = checkInMatchMaking.plageIDDemandeur;
END;$$ LANGUAGE 'plpgsql';

CREATE FUNCTION checkInDispo
(
    idTutorat INT
)
    RETURNS TABLE
            (
                cip VARCHAR(8)
            )
AS $$
BEGIN
    RETURN QUERY SELECT D.cip FROM disponibilité_utilisateur D
                 WHERE D.idtutorat = checkInDispo.idTutorat;
END;$$ LANGUAGE 'plpgsql';

CREATE FUNCTION createMatchMaking
(
    cipReceveur VARCHAR(8),
    tutoratReceveur INT,
    tutoratSouhaite INT
)
RETURNS BOOLEAN
AS $$
BEGIN
    INSERT INTO matchmaking(cip_receveur, tutorat_receveur, tutorat_souhaite)
        VALUES
        (
            createMatchMaking.cipReceveur,
            createMatchMaking.tutoratReceveur,
            createMatchMaking.tutoratSouhaite
        );
END;$$ LANGUAGE 'plpgsql';

CREATE FUNCTION updateEchangeForCreation
(
    demandeur VARCHAR(8),
    cible VARCHAR(8),
    tutorat_demandeur INT,
    tutorat_cible INT,
    confirme INT
)
RETURNS BOOLEAN
AS $$
BEGIN
    UPDATE echange E SET E.confirme = updateEchangeForCreation.confirme
            WHERE updateEchangeForCreation.demandeur = E.demandeur
            AND updateEchangeForCreation.cible = E.cible
            AND updateEchangeForCreation.tutorat_demandeur = E.tutorat_demandeur
            AND updateEchangeForCreation.tutorat_cible = E.tutorat_cible;
    RETURN TRUE;
END;$$ LANGUAGE 'plpgsql';

CREATE FUNCTION insertEchangeForCreation
(
    demandeur VARCHAR(8),
    cible VARCHAR(8),
    tutorat_demandeur INT,
    tutorat_cible INT,
    confirme INT
)
RETURNS BOOLEAN
AS $$
BEGIN
    INSERT INTO echange (timestamp, demandeur, cible, tutorat_demandeur, tutorat_cible, confirme)
           VALUES
           (
               now(),
               InsertEchangeForCreation.demandeur,
               InsertEchangeForCreation.cible,
               InsertEchangeForCreation.tutorat_demandeur,
               InsertEchangeForCreation.tutorat_cible,
               InsertEchangeForCreation.confirme
           );
    RETURN TRUE;
END;$$ LANGUAGE 'plpgsql';

CREATE FUNCTION createEchange
(
    demandeur VARCHAR(8),
    cible VARCHAR(8),
    tutorat_demandeur INT,
    tutorat_cible INT,
    confirme INT
)
RETURNS BOOLEAN
AS $$
BEGIN
    SELECT CASE WHEN EXISTS
    (
        SELECT * FROM echange E
            WHERE createEchange.demandeur = E.demandeur
            AND createEchange.cible = E.cible
            AND createEchange.tutorat_demandeur = E.tutorat_demandeur
            AND createEchange.tutorat_cible = E.tutorat_cible
    )
    THEN
        (updateEchangeForCreation(demandeur, cible, tutorat_demandeur, tutorat_cible, confirme))
    ELSE
       (insertEchangeForCreation(demandeur, cible, tutorat_demandeur, tutorat_cible, confirme))
end;
    RETURN TRUE;
END;$$ LANGUAGE 'plpgsql';

CREATE FUNCTION makeEchangeWithTutorat
(
    cip1 VARCHAR(8),
    cip2 VARCHAR(8),
    tutorat1 INT,
    tutorat2 INT
)
RETURNS BOOLEAN
AS $$
BEGIN
    DELETE FROM Tutorat_Utilisateur TU
    WHERE (TU.tutorat_id = tutorat1 AND TU.cip = makeechange.cip1)
        OR (TU.tutorat_id =tutorat2 AND TU.cip = makeEchange.cip2);
    UPDATE tutorat_utilisateur TU SET tutorat_id = tutorat2
        WHERE TU.cip = makeechangeWithTutorat.cip1 AND TU.tutorat_id = makeechangeWithTutorat.tutorat1;
    UPDATE tutorat_utilisateur TU SET tutorat_id = makeechangeWithTutorat.tutorat1
        WHERE TU.cip = makeechangeWithTutorat.cip2 AND TU.tutorat_id = makeechangeWithTutorat.tutorat2;
    INSERT INTO log (timestamp, message) VALUES (NOW(),format('Echange cip : %s , %s Tutorat : %s '
        , cip1, cip2, tutorat1, tutorat2));
    RETURN TRUE;
END;$$ LANGUAGE 'plpgsql';

CREATE FUNCTION getInfoCIP2
(
    cip1 VARCHAR(8),
    cip2 VARCHAR(8),
    idTutorat1 INT
)
RETURNS TABLE
(
    IdTutorat2 INT,
    App VARCHAR(8),
    Session VARCHAR(3)
)
AS $$
    DECLARE vapp VARCHAR(8);
    DECLARE vsession VARCHAR(3);
BEGIN
    vapp := (SELECT A.numero FROM tutorat_utilisateur TU
        INNER JOIN Tutorat T on T.id = TU.tutorat_id
        INNER JOIN APP A on A.id = T.APP_id
        WHERE TU.cip = getInfoCIP2.cip1
        AND tu.tutorat_id = getInfoCIP2.IdTutorat1);
    vsession := (SELECT S.code FROM tutorat_utilisateur TU
        INNER JOIN Tutorat T on T.id = TU.tutorat_id
        INNER JOIN APP A on A.id = T.APP_id
        INNER JOIN session S on S.code = A.session_code
        WHERE TU.cip = getInfoCIP2.cip1
        AND tu.tutorat_id = getInfoCIP2.IdTutorat1);
    RETURN QUERY SELECT TU2.tutorat_id, vapp, vsession FROM Tutorat_Utilisateur TU2
        INNER JOIN Tutorat T2 on T2.id = TU2.tutorat_id
        INNER JOIN app a2 on T2.app_id = a2.id
        INNER JOIN session S2 on S2.code = a2.session_code
        WHERE TU2.cip = getInfoCIP2.cip2
        AND a2.numero = vapp
        AND s2.code = vsession;
END;$$ LANGUAGE 'plpgsql';