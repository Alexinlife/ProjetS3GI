package ca.usherbrooke.fgen.api.service;

import ca.usherbrooke.fgen.api.business.Echange;
import ca.usherbrooke.fgen.api.persistence.EchangeMapper;
import ca.usherbrooke.fgen.api.business.infoMatchmake;

import javax.inject.Inject;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;
import java.util.Objects;


@Path("/api")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)

public class EchangeService {

    @Inject
    EchangeMapper echangeMapper;

    @GET
    @Path("echange-rapide/{cip1}/{cip2}/{idtutorat1}")
    public void EchangeRapide(
            @PathParam("cip1") String cip1,
            @PathParam("cip2") String cip2,
            @PathParam("idtutorat1") int idtutorat1
    )
    {
        Echange infoCip2 = echangeMapper.getInfoCip2(cip1, cip2, idtutorat1);

        Echange valid = echangeMapper.getValidation(cip1, cip2, infoCip2.App, infoCip2.Session, idtutorat1, infoCip2.IdTutorat2);
        if(valid.valid)
        {
            System.out.println("true");
            echangeMapper.EchangeRapide(cip1, cip2, infoCip2.App, infoCip2.Session);
        }
        else {
            System.out.println(valid.valid);
            return;
        }
    }

    @GET
    @Path("matchmaking/{cip}/{idtutorat1}/{plageidDemander}")
    public void Matchmaking(
            @PathParam("cip") String cip,
            @PathParam("idtutorat1") int idtutorat1,
            @PathParam("plageidDemander") int plageDemander
    )
    {
        System.out.println("ALLO");
        Echange infoTuto = echangeMapper.getInfoForMatchmaking(cip,idtutorat1, plageDemander);
        System.out.println(infoTuto.IdTutorat2);
        String valid = echangeMapper.checkMatchmaking(idtutorat1,infoTuto.IdTutorat2).cip;
        System.out.println("ALLO");
        System.out.print("CIP : ");
        System.out.println(valid);
        if(!Objects.equals(valid, "alloallo"))
        {
            System.out.println("penis");
            echangeMapper.echangeMatch(cip, valid, idtutorat1,infoTuto.IdTutorat2);
        }
        else {
            valid = echangeMapper.checkDispo(infoTuto.IdTutorat2).cip;
            if(!Objects.equals(valid, "alloallo")){
                echangeMapper.echangeMatch(cip, valid, idtutorat1,infoTuto.IdTutorat2);
            }
            else{
                echangeMapper.createMatch(cip,idtutorat1,infoTuto.IdTutorat2);
            }
        }

        return;
    }
}
