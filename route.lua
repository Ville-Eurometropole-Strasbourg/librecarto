local var_srid = 3857
local var_schema = 'osm_import'

local route = osm2pgsql.define_way_table('route', {
    { column = 'type',    type = 'text' },
    { column = 'name',    type = 'text' },
    { column = 'name_gsw', type = 'text' },
    { column = 'tags',    type = 'jsonb' },
    { column = 'geom',    type = 'linestring' },
})

local get_highway_value = osm2pgsql.make_check_values_func({
    'motorway', 'trunk', 'primary', 'secondary', 'tertiary',
    'motorway_link', 'trunk_link', 'primary_link', 'secondary_link', 'tertiary_link',
    'unclassified', 'residential', 'pedestrian','service','pedestrian','living_street'
})

function osm2pgsql.process_way(object)
    local highway_type = get_highway_value(object.tags.highway)

    if not highway_type then
        return
    end

    if object.tags.area == 'yes' then
        return
    end

    route:insert({
        type    = highway_type,
        tags    = object.tags,
        name    = object.tags.name,
        name_gsw = object.tags['name:gsw'],
        geom    = object:as_linestring(),
    })
end

