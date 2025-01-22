local var_srid = 3857
local var_schema = 'osm_import'

local tram_voie = osm2pgsql.define_way_table('train_voie', {
    { column = 'name', type = 'text' },
    { column = 'railway', type = 'text' },
    { column = 'geom', type = 'linestring', projection = var_srid }
})

function osm2pgsql.process_way(object)
    if (object.tags.railway == 'rail') then
        tram_voie:insert({
            name = object.tags.name,
            railway = object.tags.railway,
            geom = object:as_linestring()
        })
    end
end