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


@Path("/tutorats")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)

public class HoraireService {

    @Inject
    horaireMapper horaireMapper;

    @GET
    @Path("gethoraire")

    public List<Horaire> getHoraire(
            ) {
        List<Horaire> horaires = horaireMapper.selectHoraire();
        System.out.print(horaires);
        return (horaires);
    }





    public static Horaire unescapeEntities(Horaire horaire) {
        horaire.description = Parser.unescapeEntities(horaire.description, true);
        return horaire;
    }

    public List<Horaire> unescapeEntities(List<Horaire> horaire) {
        return horaire
                .stream()
                .map(HoraireService::unescapeEntities)
                .collect(Collectors.toList());
    }
}


