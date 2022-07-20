package ca.usherbrooke.fgen.api.persistence;

import ca.usherbrooke.fgen.api.business.Horaire;
import org.apache.ibatis.annotations.Mapper;

import java.sql.Timestamp;
import java.util.List;

@Mapper
public interface horaireMapper {
    List<Horaire> selectHoraire(String cip1);

    //boolean validerEchangeRapide(String cip1, String cip2, String cours, String tutorat);

    //String getNotification();

    //EchangeDirecte trade(String CIPdonneur, String CIPreceveur);
}
