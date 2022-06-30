package ca.usherbrooke.fgen.api.service;

import ca.usherbrooke.fgen.api.business.Horaire;
import ca.usherbrooke.fgen.api.persistence.horaireMapper;


import javax.inject.Inject;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import java.util.List;


@Path("/tutorats")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)

public class HoraireService {

    @Inject
    horaireMapper horaireMapper;

    @GET
    @Path("gethoraire")

    public List<Horaire> getHoraire(
    )

    {
        List<Horaire> horaires = horaireMapper.selectHoraire();
        return (horaires);
    }
}


