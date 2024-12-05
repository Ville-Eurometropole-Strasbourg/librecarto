local var_srid = 3948
local var_schema = 'osm_import'

local batiment = osm2pgsql.define_area_table('batiment', {
    -- Define an autoincrementing id column, QGIS likes a unique id on the table
    { column = 'id', sql_type = 'serial', create_only = true },
    { column = 'geom', type = 'polygon', not_null = true },
    { column = 'building', sql_type = 'text' },
    { column = 'amenity', sql_type = 'text' },
    { column = 'office', sql_type = 'text' },
    { column = 'tourism', sql_type = 'text' },
    { column = 'leisure', sql_type = 'text' },
}, { indexes = {
    -- So we get an index on the id column
    { column = 'id', method = 'btree', unique = true },
    -- If we define any indexes we don't get the default index on the geometry
    -- column, so we add it here.
    { column = 'geom', method = 'gist' }
}})

function osm2pgsql.process_way(object)
    if object.is_closed and object.tags.building then
        batiment:insert({
            geom = object:as_polygon(),
            building = object.tags.building,
            amenity = object.tags.amenity,
            office = object.tags.office,
            tourism = object.tags.tourism,
            leisure = object.tags.leisure
        })
    end
end

function osm2pgsql.process_relation(object)
    if object.tags.type == 'multipolygon' and object.tags.building then
        -- A partir de la relation, nous obtenons des multipolygones...
        local mp = object:as_multipolygon()
        -- ...et les divisons en polygones que nous insérons dans la table
        for geom in mp:geometries() do
            batiment:insert({
                geom = geom,
                building = object.tags.building,
                amenity = object.tags.amenity,
                office = object.tags.office,
                tourism = object.tags.tourism,
                leisure = object.tags.leisure
            })
        end
    end
end

