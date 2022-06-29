package ca.usherbrooke.fgen.api.service;

import ca.usherbrooke.fgen.api.business.Horaire;
import ca.usherbrooke.fgen.api.persistence.horaireMapper;

import javax.inject.Inject;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import java.util.List;


@Path("/api")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)

public class HoraireService {

    @Inject
    horaireMapper horaireMapper;

    @GET
    @Path("gethoraire/{HeureDebut}/{HeureFin}/{Date}/{Local}/{Description}/{nomCours}")
    public List<Horaire> getHoraire(
            @PathParam("HeureDebut") String HeureDebut,
            @PathParam("HeureFin") String HeureFin,
            @PathParam("Date") String Date,
            @PathParam("Local") String local,
            @PathParam("Description") String Description,
            @PathParam("nomCours") String nomCours
    )

    {
        List<Horaire> horaires = horaireMapper.selectHoraire(HeureDebut, HeureFin, Date, local, Description, nomCours);
        return horaires;
    }
}


