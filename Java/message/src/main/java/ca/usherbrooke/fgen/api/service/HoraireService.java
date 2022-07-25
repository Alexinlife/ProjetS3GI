package ca.usherbrooke.fgen.api.service;

import ca.usherbrooke.fgen.api.business.Horaire;
import ca.usherbrooke.fgen.api.persistence.horaireMapper;
import org.jsoup.parser.Parser;


import javax.inject.Inject;
import javax.print.DocPrintJob;
import javax.print.PrintService;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.List;
import java.awt.print.*;
import java.util.stream.Collectors;


@Path("/api")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)

public class HoraireService {

    @Inject
    horaireMapper horaireMapper;

    @GET
    @Path("gethoraire/{cip}")

    public List<Horaire> getHoraire(
            @PathParam("cip") String cip
            ) {
        List<Horaire> horaires = horaireMapper.selectHoraire(cip);
        System.out.print(horaires);
        return (horaires);
    }
}


