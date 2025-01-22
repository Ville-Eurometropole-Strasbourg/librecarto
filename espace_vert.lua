local var_srid = 3948
local var_schema = 'osm_import'

local espace_vert = osm2pgsql.define_area_table('espace_vert', {
    { column = 'id', sql_type = 'serial', create_only = true },
    { column = 'geom', type = 'polygon', not_null = true },
    { column = 'natural', sql_type = 'text' },
    { column = 'leisure', sql_type = 'text' },
    { column = 'landuse', sql_type = 'text' },
    { column = 'tags',    type = 'jsonb' },
}, { indexes = {
    { column = 'id', method = 'btree', unique = true },
    { column = 'geom', method = 'gist' }
}})

local get_leisure_value = osm2pgsql.make_check_values_func({
    'park', 'pitch', 'track', 'garden'
})

local get_landuse_value = osm2pgsql.make_check_values_func({
    'forest', 'cemetery', 'allotments', 'grass', 'meadow'
})

local get_natural_value = osm2pgsql.make_check_values_func({
    'wood'
})

function osm2pgsql.process_way(object)
    local leisure_type = get_leisure_value(object.tags.leisure)
    local landuse_type = get_landuse_value(object.tags.landuse)
    local natural_type = get_natural_value(object.tags.natural)
    if not (leisure_type or landuse_type or natural_type) then
        return
    end
    if object.is_closed then
        espace_vert:insert({
            tags    = object.tags,
            geom = object:as_polygon(),
            natural = natural_type,
            leisure = leisure_type,
            landuse = landuse_type
        })
    end
end

function osm2pgsql.process_relation(object)
    local leisure_type = get_leisure_value(object.tags.leisure)
    local landuse_type = get_landuse_value(object.tags.landuse)
    local natural_type = get_natural_value(object.tags.natural)
    if not (leisure_type or landuse_type or natural_type) then
        return
    end
    if object.tags.type == 'multipolygon' then
        local mp = object:as_multipolygon()
        for geom in mp:geometries() do
            espace_vert:insert({
                tags    = object.tags,
                geom = geom,
                natural = natural_type,
                leisure = leisure_type,
                landuse = landuse_type
            })
        end
    end
end