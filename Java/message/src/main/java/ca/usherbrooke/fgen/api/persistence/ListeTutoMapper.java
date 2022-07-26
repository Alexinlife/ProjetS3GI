package ca.usherbrooke.fgen.api.persistence;

import ca.usherbrooke.fgen.api.business.ListeTuto;
import org.apache.ibatis.annotations.Mapper;

import java.sql.Timestamp;
import java.util.List;

@Mapper
public interface ListeTutoMapper {
    List<ListeTuto> listerTuto(Integer numTuto, Integer appId);

}
