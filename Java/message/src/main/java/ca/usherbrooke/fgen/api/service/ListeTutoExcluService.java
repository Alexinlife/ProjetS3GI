package ca.usherbrooke.fgen.api.service;

import ca.usherbrooke.fgen.api.business.ListeTutoExclu;
import ca.usherbrooke.fgen.api.persistence.ListeTutoExcluMapper;
import javax.inject.Inject;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import java.sql.Date;
import java.util.List;

@Path("/api")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)

public class ListeTutoExcluService {

    @Inject
    ListeTutoExcluMapper excluMapper;

    @GET
    @Path("get-plage/{idTutorat}")

    public List<ListeTutoExclu> getListeExclu(
            @PathParam("idTutorat") int tutoID
            ) {
        List<ListeTutoExclu> exclu = excluMapper.selectTuto(tutoID);
        return (exclu);
    }
}
