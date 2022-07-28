package ca.usherbrooke.fgen.api.service;

import ca.usherbrooke.fgen.api.business.ListeTuto;
import ca.usherbrooke.fgen.api.persistence.ListeTutoMapper;

import javax.inject.Inject;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;

import java.util.List;



@Path("/api")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)

public class ListeTutoService {

    @Inject
    ListeTutoMapper ListeTutoMapper;

    @GET
    @Path("getTuto/{numTuto}/{appId}")

    public List<ListeTuto> getTuto(
            @PathParam("numTuto") Integer numTuto,
            @PathParam("appId") Integer appId
            ) {
        List<ListeTuto> tutos = ListeTutoMapper.listerTuto(numTuto, appId);
        System.out.print(tutos);
        return (tutos);
    }
}


