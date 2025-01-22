local var_srid = 3948
local var_schema = 'osm_import'

local zone_activite = osm2pgsql.define_area_table('zone_activite', {
    { column = 'id', sql_type = 'serial', create_only = true },
    { column = 'geom', type = 'polygon', not_null = true },
    { column = 'landuse', sql_type = 'text' },
    { column = 'tags',    type = 'jsonb' },
}, { indexes = {
    { column = 'id', method = 'btree', unique = true },
    { column = 'geom', method = 'gist' }
}})

local get_landuse_value = osm2pgsql.make_check_values_func({
    'commercial', 'industrial', 'retail'
})

function osm2pgsql.process_way(object)
    local landuse_type = get_landuse_value(object.tags.landuse)
    if not landuse_type then
        return
    end
    if object.is_closed then
        zone_activite:insert({
            tags    = object.tags,
            geom = object:as_polygon(),
            landuse = landuse_type
        })
    end
end

function osm2pgsql.process_relation(object)
    local landuse_type = get_landuse_value(object.tags.landuse)
    if not landuse_type then
        return
    end
    if object.tags.type == 'multipolygon' then
        local mp = object:as_multipolygon()
        for geom in mp:geometries() do
            zone_activite:insert({
                tags    = object.tags,
                geom = geom,
                landuse = landuse_type
            })
        end
    end
end