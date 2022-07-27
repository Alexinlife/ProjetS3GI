package ca.usherbrooke.fgen.api.persistence;

import ca.usherbrooke.fgen.api.business.ListeTutoExclu;

import java.sql.Date;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ListeTutoExcluMapper {
    List<ListeTutoExclu> selectTuto(Date date, String app, String session);
}
