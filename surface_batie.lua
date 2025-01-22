local var_srid = 3948
local var_schema = 'osm_import'

local surface_batie = osm2pgsql.define_area_table('surface_batie', {
    { column = 'id', sql_type = 'serial', create_only = true },
    { column = 'geom', type = 'polygon', not_null = true },
    { column = 'landuse', sql_type = 'text' },
    { column = 'tags',    type = 'jsonb' },
}, { indexes = {
    { column = 'id', method = 'btree', unique = true },
    { column = 'geom', method = 'gist' }
}})

function osm2pgsql.process_way(object)
    if object.is_closed and object.tags.landuse == 'residential' then
        surface_batie:insert({
            tags    = object.tags,
            geom = object:as_polygon(),
            landuse = object.tags.landuse
        })
    end
end

function osm2pgsql.process_relation(object)
    if object.tags.type == 'multipolygon' and object.tags.landuse == 'residential' then
        local mp = object:as_multipolygon()
        for geom in mp:geometries() do
            surface_batie:insert({
                tags    = object.tags,
                geom = geom,
                landuse = object.tags.landuse
            })
        end
    end
end