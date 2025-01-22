local var_srid = 3948
local var_schema = 'osm_import'

local surface_eau = osm2pgsql.define_area_table('surface_eau', {
    { column = 'id', sql_type = 'serial', create_only = true },
    { column = 'geom', type = 'polygon', not_null = true },
    { column = 'natural', sql_type = 'text' },
    { column = 'waterway', sql_type = 'text' },
    { column = 'tags',    type = 'jsonb' },
}, { indexes = {
    { column = 'id', method = 'btree', unique = true },
    { column = 'geom', method = 'gist' }
}})

function osm2pgsql.process_way(object)
    if object.is_closed and (object.tags.natural == 'water' or object.tags.waterway) then
        surface_eau:insert({
            tags    = object.tags,
            geom = object:as_polygon(),
            natural = object.tags.natural,
            waterway = object.tags.waterway
        })
    end
end

function osm2pgsql.process_relation(object)
    if object.tags.type == 'multipolygon' and (object.tags.natural == 'water' or object.tags.waterway) then
        local mp = object:as_multipolygon()
        for geom in mp:geometries() do
            surface_eau:insert({
                tags    = object.tags,
                geom = geom,
                natural = object.tags.natural,
                waterway = object.tags.waterway
            })
        end
    end
end