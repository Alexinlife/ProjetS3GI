package ca.usherbrooke.fgen.api.business;

import java.sql.Timestamp;

public class Notification {
    Timestamp temps;
    int id;
    String demandeur;
    String cible;
    int tutorat_demandeur;
    int tutorat_cible;
    int confirme;
}
