local var_srid = 3857
local var_schema = 'osm_import'

local tram_voie = osm2pgsql.define_way_table('tram_voie', {
    { column = 'name', type = 'text' },
    { column = 'railway', type = 'text' },
    { column = 'usage', type = 'text' },
    { column = 'construction', type = 'text' },
    { column = 'proposed', type = 'text' },
    { column = 'tags',    type = 'jsonb' },
    { column = 'geom', type = 'linestring', projection = var_srid }
})

-- Define table for tram stops
local tram_stops = osm2pgsql.define_node_table('tram_stops', {
    { column = 'name', type = 'text' },
    { column = 'railway', type = 'text' },
    { column = 'tags',    type = 'jsonb' },
    { column = 'geom', type = 'point', projection = var_srid }
})

function osm2pgsql.process_way(object)
    if (object.tags.railway == 'tram' and object.tags.usage == 'main') or
       (object.tags.railway == 'construction' and object.tags.construction == 'tram') or
       (object.tags.railway == 'proposed' and object.tags.proposed == 'tram') then
        tram_voie:insert({
            name = object.tags.name,
            railway = object.tags.railway,
            usage = object.tags.usage,
            construction = object.tags.construction,
            proposed = object.tags.proposed,
            tags    = object.tags,
            geom = object:as_linestring()
        })
    end
end

function osm2pgsql.process_node(object)
    if object.tags.railway == 'tram_stop' then
        tram_stops:insert({
            name = object.tags.name,
            railway = object.tags.railway,
            tags    = object.tags,
            geom = object:as_point()
        })
    end
end
