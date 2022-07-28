package ca.usherbrooke.fgen.api.service;

import ca.usherbrooke.fgen.api.business.Notification;
import ca.usherbrooke.fgen.api.persistence.NotificationMapper;

import javax.inject.Inject;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import java.util.List;

@Path("/api")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)

public class NotificationService {

    @Inject
    NotificationMapper notificationMapper;

    @GET
    @Path("getnotification/{cip}")
    public List<Notification> getNotifications(
            @PathParam("cip") String cip
    )
    {
        List<Notification> notifications = notificationMapper.selectNotifications(cip);
        return notifications;
    }
}
