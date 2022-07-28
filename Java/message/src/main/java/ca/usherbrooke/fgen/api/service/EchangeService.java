package ca.usherbrooke.fgen.api.service;

import ca.usherbrooke.fgen.api.business.Echange;
import ca.usherbrooke.fgen.api.persistence.EchangeMapper;

import javax.inject.Inject;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;


@Path("/api")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)

public class EchangeService {

    @Inject
    EchangeMapper echangeMapper;

    @GET
    @Path("echange-rapide/{cip}/{cip2}/{idtutorat1}")
    public void EchangeRapide(
            @PathParam("cip") String cip1,
            @PathParam("cip2") String cip2,
            @PathParam("idtutorat1") int idtutorat1
    )
    {
        Echange infoCip2 = echangeMapper.getInfoCip2(cip1, cip2, idtutorat1);

        Echange valid = echangeMapper.getValidation(cip1, cip2, infoCip2.app, infoCip2.session, idtutorat1, infoCip2.idtutorat2);
        if(valid.valid)
        {
            System.out.println("true");
            echangeMapper.EchangeRapide(cip1, cip2, infoCip2.app, infoCip2.session);
        }
        else {
            System.out.println(valid.valid);
            return;
        }
    }

    @GET
    @Path("matchmaking/{cip1}/{cip2}/{app}/{session}/{idtutorat1}/{idtutorat2}/{etat}")
    public void Matchmaking(
            @PathParam("cip1") String cip1,
            @PathParam("cip2") String cip2,
            @PathParam("app") String app,
            @PathParam("session") String session,
            @PathParam("idtutorat1") int idtutorat1,
            @PathParam("idtutorat2") int idtutorat2
    )
    {
        Echange valid = echangeMapper.getValidation(cip1, cip2, app, session, idtutorat1, idtutorat2);
        if(valid.valid)
        {
            Echange echange = echangeMapper.Matchmaking();
            return;
        }
        else {
            System.out.println("Erreur");
            return;
        }
    }
}
