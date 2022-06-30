package ca.usherbrooke.fgen.api.service;

import ca.usherbrooke.fgen.api.business.Message;
import ca.usherbrooke.fgen.api.persistence.MessageMapper;
import ca.usherbrooke.fgen.api.persistence.ValidationMapper;
import org.jsoup.parser.Parser;

import javax.inject.Inject;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import java.util.List;
import java.util.stream.Collectors;




@Path("/api")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)

public class ValidationService {

    @Inject
    ValidationMapper validationMapper;

    @GET
    @Path("getValidation/{cip1}/{cip2}/{cours}/{tutorat}")
    public boolean validerEchangeRapide(
            @PathParam("cip1") String cip1,
            @PathParam("cip2") String cip2,
            @PathParam("cours") String cours,
            @PathParam("tutorat") String tutorat

    ) {

        String tmp_cip1 = "marp0501";
        String tmp_cip2 = "pelf1504";
        String tmp_cours = "S3APP2";
        String tmp_tutorat1 = "t1";

        if (tmp_cip1 == cip1) {
            if (tmp_cip2 == cip2) {
                if (tmp_cours == cours) {
                    if (tmp_tutorat1 == tutorat) {
                        boolean answer = validationMapper.getValidation();
                        return answer;
                    }
                }
            }
        }
        return false;
    }
}
