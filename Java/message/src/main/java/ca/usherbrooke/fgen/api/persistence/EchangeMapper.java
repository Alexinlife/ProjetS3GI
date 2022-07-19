package ca.usherbrooke.fgen.api.persistence;


import ca.usherbrooke.fgen.api.business.Echange;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface EchangeMapper {

    boolean getValidation(String cip1, String cip2, String app, String session, int idtutorat1, int idtutorat2);
    Echange EchangeRapide();
    Echange Matchmaking();
}
