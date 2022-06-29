package ca.usherbrooke.fgen.api.service;

import ca.usherbrooke.fgen.api.business.Notification;
import ca.usherbrooke.fgen.api.persistence.MessageMapper;
import ca.usherbrooke.fgen.api.persistence.NotificationMapper;

import javax.inject.Inject;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import java.util.Date;
import java.util.List;

@Path("/api")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)

public class NotificationService {

    @Inject
    NotificationMapper notificationMapper;

    @GET
    @Path("getnotification/{Notification}/{Heure}")
    public List<Notification> getNotifications(
            @PathParam("Notification") String Notification,
            @PathParam("Heure") Date Heure
    )
    {
        List<Notification> notifications = notificationMapper.selectNotifications(Notification, Heure);
        return notifications;
    }
}
