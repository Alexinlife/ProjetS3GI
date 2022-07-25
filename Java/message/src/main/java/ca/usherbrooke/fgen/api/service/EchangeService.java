package ca.usherbrooke.fgen.api.service;

import ca.usherbrooke.fgen.api.business.Echange;
import ca.usherbrooke.fgen.api.persistence.EchangeMapper;

import javax.inject.Inject;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import java.util.List;


@Path("/api")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)

public class EchangeService {

    @Inject
    EchangeMapper echangeMapper;

    @GET
    @Path("echange-rapide/{cip}/{cip2}/{app}/{session}/{idtutorat1}/{idtutorat2}")
    public void EchangeRapide(
            @PathParam("cip") String cip1,
            @PathParam("cip2") String cip2,
            @PathParam("app") String app,
            @PathParam("session") String session,
            @PathParam("idtutorat1") int idtutorat1,
            @PathParam("idtutorat2") int idtutorat2
    )
    {
        Echange echanges = echangeMapper.getValidation(cip1, cip2, app, session, idtutorat1, idtutorat2);
        if(echanges.valid)
        {
            System.out.println("true");
            System.out.println(echangeMapper.getValidation(cip1, cip2, app, session, idtutorat1, idtutorat2));
            return;
        }
        else {
            System.out.println(echanges.valid);
            System.out.println("trash");
            return;
        }
    }

    @GET
    @Path("Matchmaking/{cip1}/{cip2}/{app}/{session}/{idtutorat1}/{idtutorat2}")
    public void Matchmaking(
            @PathParam("cip1") String cip1,
            @PathParam("cip2") String cip2,
            @PathParam("app") String app,
            @PathParam("session") String session,
            @PathParam("idtutorat1") int idtutorat1,
            @PathParam("idtutorat2") int idtutorat2
    )
    {
        Echange echanges = echangeMapper.getValidation(cip1, cip2, app, session, idtutorat1, idtutorat2);
        if(echanges.valid)
        {
            Echange echange = echangeMapper.Matchmaking();
            return;
        }
        else {
            System.out.println("sauce");
            return;
        }
    }
}
