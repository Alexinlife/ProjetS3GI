package ca.usherbrooke.fgen.api.persistence;

import ca.usherbrooke.fgen.api.business.EchangeDirecte;
import ca.usherbrooke.fgen.api.business.Horaire;
import ca.usherbrooke.fgen.api.business.Message;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface horaireMapper {
    List<Horaire> selectHoraire(String HeureDebut, String HeureFin, String Date, String Local,
                         String Description, String nomCours);

    boolean validerEchangeRapide(String cip1, String cip2, String cours, String tutorat);

    String getNotification();

    //EchangeDirecte trade(String CIPdonneur, String CIPreceveur);
}
