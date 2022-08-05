package ca.usherbrooke.fgen.api.persistence;


import ca.usherbrooke.fgen.api.business.Echange;
import org.apache.ibatis.annotations.Mapper;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.List;

@Mapper
public interface EchangeMapper {

    Echange getValidation(String cip1, String cip2, String app, String session, int idtutorat1, int idtutorat2);
    Echange getInfoCip2(String cip1, String cip2, int idTutorat1);
    Echange EchangeRapide(String cip1, String cip2, String app, String session);
    Echange checkMatchmaking(int idTutorat, int idTutorat2);
    Echange checkDispo(int idTutorat);
    Echange createMatch(String cip, int idTutorat, int idTutorat2);
    Echange echangeMatch(String cip1, String cip2, int idTutorat, int idTutorat2);
    Echange getInfoForMatchmaking(String cip1, int idTutorat, int plageid);
}
