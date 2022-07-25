package ca.usherbrooke.fgen.api.service;

import ca.usherbrooke.fgen.api.business.ListeTuto;
import ca.usherbrooke.fgen.api.persistence.ListeTutoMapper;
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

public class ListeTutoService {

    @Inject
    ListeTutoMapper ListeTutoMapper;

    @GET
    @Path("getTuto/{numero-tuto}/{app-id}")

    public List<ListeTuto> getTuto(
            @PathParam("numero-tuto") Integer numTuto,
            @PathParam("app-id") Integer appId
            ) {
        List<ListeTuto> tutos = ListeTutoMapper.listerTuto(numTuto, appId);
        System.out.print(tutos);
        return (tutos);
    }
}


