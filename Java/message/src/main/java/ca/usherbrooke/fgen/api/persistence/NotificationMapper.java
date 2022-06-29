package ca.usherbrooke.fgen.api.persistence;


import ca.usherbrooke.fgen.api.business.Horaire;
import ca.usherbrooke.fgen.api.business.Notification;
import org.apache.ibatis.annotations.Mapper;

import java.util.Date;
import java.util.List;

@Mapper
public interface NotificationMapper {
    List<Notification> selectNotifications(String notifications, Date heure);
}
