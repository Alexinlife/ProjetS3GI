package ca.usherbrooke.fgen.api.persistence;


import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ValidationMapper {

    boolean getValidation();

}
