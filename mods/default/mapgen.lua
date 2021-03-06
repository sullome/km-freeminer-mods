--
-- Aliases for map generator outputs
--

minetest.register_alias("mapgen_stone", "default:stone")
minetest.register_alias("mapgen_dirt", "default:dirt")
minetest.register_alias("mapgen_dirt_with_grass", "default:dirt_with_grass")
minetest.register_alias("mapgen_sand", "default:sand")
minetest.register_alias("mapgen_water_source", "default:water_source")
minetest.register_alias("mapgen_river_water_source", "default:river_water_source")
minetest.register_alias("mapgen_lava_source", "default:lava_source")
minetest.register_alias("mapgen_gravel", "default:gravel")
minetest.register_alias("mapgen_desert_sand", "default:desert_sand")
minetest.register_alias("mapgen_dirt_with_snow", "default:dirt_with_snow")
minetest.register_alias("mapgen_snowblock", "default:snowblock")
minetest.register_alias("mapgen_snow", "default:snow")
minetest.register_alias("mapgen_ice", "default:ice")
minetest.register_alias("mapgen_sandstone", "default:sandstone")

-- Flora

minetest.register_alias("mapgen_tree", "default:tree")
minetest.register_alias("mapgen_leaves", "default:leaves")
minetest.register_alias("mapgen_apple", "default:apple")
minetest.register_alias("mapgen_jungletree", "default:jungletree")
minetest.register_alias("mapgen_jungleleaves", "default:jungleleaves")
minetest.register_alias("mapgen_junglegrass", "default:junglegrass")
minetest.register_alias("mapgen_pine_tree", "default:pine_tree")
minetest.register_alias("mapgen_pine_needles", "default:pine_needles")

-- Dungeons

minetest.register_alias("mapgen_cobble", "default:cobble")
minetest.register_alias("mapgen_stair_cobble", "stairs:stair_cobble")
minetest.register_alias("mapgen_mossycobble", "default:mossycobble")
minetest.register_alias("mapgen_sandstonebrick", "default:sandstonebrick")
minetest.register_alias("mapgen_stair_sandstonebrick", "stairs:stair_sandstonebrick")


--freeminer:
minetest.register_alias("mapgen_ice", "default:ice")
minetest.register_alias("mapgen_dirt_with_snow", "default:dirt_with_snow")


-- freeminer layers
local mg_params = {
    layer_default_thickness = 1,
    layer_thickness_multiplier = 1,
    layers= {
        { name = "default:stone",              thickness  = 25, },
        --{ name = "default:stone_with_coal",    y_max = -1000, },
        { name = "default:water_source",       y_min = -3000, y_max = -70, thickness  = 3},
        { name = "default:stone",              y_min = -3000, y_max = -70, }, -- stone after water
        { name = "default:dirt",               y_min = -500,  y_max = 50, },
        --{ name = "default:stone_with_iron",    y_max = -2000, },
        { name = "default:gravel",             y_max = -1, },
        --{ name = "default:stone_with_copper",  y_max = -3000, },
        { name = "default:clay",               thickness  = 4, },
        --{ name = "default:stone_with_gold",    y_max = -5000, },
        { name = "default:lava_source",        y_max = -3000, },
        --{ name = "default:stone_with_diamond", y_max = -7000, },
        { name = "default:obsidian",           y_max = -5000, thickness  = 5 },
        { name = "default:stone",              thickness  = 20, },
        --{ name = "default:stone_with_mese",    y_max = -10000, },
        { name = "air",                        thickness  = 20, y_max = -500, y_min = -20000, }, --caves
        { name = "default:lava_source",        y_max = -20000, thickness  = 15,},
        --{ name = "default:mese",               y_max = -15000, },
        { name = "air",                        thickness  = 2 },
    }
}

if core.setting_get("mg_params") == "" then
    core.setting_set("mg_params", core.write_json(mg_params))
end

-- All mapgens except singlenode
-- Blob ore first to avoid other ores inside blobs

function default.register_ores()

    -- Clay

    minetest.register_ore({ 
        ore_type         = "blob",
        ore              = "default:clay",
        wherein          = {"default:sand"},
        clust_scarcity   = 16 * 16 * 16,
        clust_size       = 5,
        y_min            = -15,
        y_max            = 0,
        noise_threshold = 0.0,
        noise_params     = {
            offset = 0.5,
            scale = 0.2,
            spread = {x = 5, y = 5, z = 5},
            seed = -316,
            octaves = 1,
            persist = 0.0
        },
    })

    -- Sand

    minetest.register_ore({ 
        ore_type         = "blob",
        ore              = "default:sand",
        wherein          = {"default:stone"},
        clust_scarcity   = 16 * 16 * 16,
        clust_size       = 5,
        y_min            = -31,
        y_max            = 4,
        noise_threshold = 0.0,
        noise_params     = {
            offset = 0.5,
            scale = 0.2,
            spread = {x = 5, y = 5, z = 5},
            seed = 2316,
            octaves = 1,
            persist = 0.0
        },
    })

    -- Dirt

    minetest.register_ore({
        ore_type         = "blob",
        ore              = "default:dirt",
        wherein          = {"default:stone"},
        clust_scarcity   = 16 * 16 * 16,
        clust_size       = 5,
        y_min            = -31,
        y_max            = 31000,
        noise_threshold = 0.0,
        noise_params     = {
            offset = 0.5,
            scale = 0.2,
            spread = {x = 5, y = 5, z = 5},
            seed = 17676,
            octaves = 1,
            persist = 0.0
        },
    })

    -- Gravel

    minetest.register_ore({
        ore_type         = "blob",
        ore              = "default:gravel",
        wherein          = {"default:stone"},
        clust_scarcity   = 16 * 16 * 16,
        clust_size       = 5,
        y_min            = -31000,
        y_max            = 31000,
        noise_threshold = 0.0,
        noise_params     = {
            offset = 0.5,
            scale = 0.2,
            spread = {x = 5, y = 5, z = 5},
            seed = 766,
            octaves = 1,
            persist = 0.0
        },
    })

--if minetest.setting_get("mg_name") == "indev" then
    -- Floatlands and high mountains springs
    minetest.register_ore({
        ore_type       = "scatter",
        ore            = "default:water_source",
        ore_param2     = 128,
        wherein        = "default:stone",
        clust_scarcity = 40*40*40,
        clust_num_ores = 8,
        clust_size     = 3,
        y_min          = 0,
        y_max          = 31000,
    })

    minetest.register_ore({
        ore_type       = "scatter",
        ore            = "default:lava_source",
        ore_param2     = 128,
        wherein        = "default:stone",
        clust_scarcity = 50*50*50,
        clust_num_ores = 5,
        clust_size     = 2,
        y_min          = 10000,
        y_max          = 31000,
    })

    minetest.register_ore({
        ore_type       = "scatter",
        ore            = "default:lava_source",
        ore_param2     = 128,
        wherein        = "default:stone",
        clust_scarcity = 80*80*80,
        clust_num_ores = 35,
        clust_size     = 4,
        y_min          = -31000,
        y_max          = 10000,
    })

    minetest.register_ore({
        ore_type       = "scatter",
        ore            = "default:sand",
        wherein        = "default:stone",
        clust_scarcity = 20*20*20,
        clust_num_ores = 5*5*4,
        clust_size     = 6,
        y_min          = -31000,
        y_max          = 31000,
    })

    minetest.register_ore({
        ore_type       = "scatter",
        ore            = "default:gravel",
        wherein        = "default:stone",
        clust_scarcity = 25*25*25,
        clust_num_ores = 5*5*4,
        clust_size     = 5,
        y_min          = -31000,
        y_max          = 31000,
    })

    minetest.register_ore({
        ore_type       = "scatter",
        ore            = "default:dirt",
        wherein        = "default:stone",
        clust_scarcity = 30*30*30,
        clust_num_ores = 5*5*5,
        clust_size     = 5,
        y_min          = -31000,
        y_max          = 31000,
    })

    -- Underground springs
    minetest.register_ore({
        ore_type       = "scatter",
        ore            = "default:water_source",
        ore_param2     = 128,
        wherein        = "default:stone",
        clust_scarcity = 25*25*25,
        clust_num_ores = 12,
        clust_size     = 3,
        y_min          = -10000,
        y_max          = 7,
    })

    minetest.register_ore({
        ore_type       = "scatter",
        ore            = "default:lava_source",
        ore_param2     = 128,
        wherein        = "default:stone",
        clust_scarcity = 35*35*35,
        clust_num_ores = 5,
        clust_size     = 2,
        y_min          = -31000,
        y_max          = -100,
    })
--end

end

--
-- Register biomes
--

-- All mapgens except mgv6 and singlenode

function default.register_biomes()
    minetest.clear_registered_biomes()

    -- Permanent ice

    minetest.register_biome({
        name = "glacier",
        node_dust = "default:snowblock",
        node_top = "default:snowblock",
        depth_top = 1,
        node_filler = "default:snowblock",
        depth_filler = 3,
        node_stone = "default:ice",
        node_water_top = "default:ice",
        depth_water_top = 10,
        --node_water = "",
        node_river_water = "default:ice",
        y_min = -8,
        y_max = 31000,
        heat_point = -5,
        humidity_point = 50,
    })

    minetest.register_biome({
        name = "glacier_ocean",
        node_dust = "default:snowblock",
        node_top = "default:sand",
        depth_top = 1,
        node_filler = "default:sand",
        depth_filler = 2,
        --node_stone = "",
        --node_water_top = "",
        --depth_water_top = ,
        --node_water = "",
        --node_river_water = "",
        y_min = -112,
        y_max = -9,
        heat_point = -5,
        humidity_point = 50,
    })

    -- Cold

    minetest.register_biome({
        name = "tundra",
        node_dust = "default:snow",
        node_top = "default:dirt_with_snow",
        depth_top = 1,
        node_filler = "default:dirt",
        depth_filler = 0,
        --node_stone = "",
        --node_water_top = "",
        --depth_water_top = ,
        --node_water = "",
        --node_river_water = "",
        y_min = 2,
        y_max = 31000,
        heat_point = 20,
        humidity_point = 25,
    })

    minetest.register_biome({
        name = "tundra_ocean",
        --node_dust = "",
        node_top = "default:sand",
        depth_top = 1,
        node_filler = "default:sand",
        depth_filler = 2,
        --node_stone = "",
        --node_water_top = "",
        --depth_water_top = ,
        --node_water = "",
        --node_river_water = "",
        y_min = -112,
        y_max = 1,
        heat_point = 20,
        humidity_point = 25,
    })


    minetest.register_biome({
        name = "taiga",
        node_dust = "default:snow",
        node_top = "default:snowblock",
        depth_top = 1,
        node_filler = "default:dirt",
        depth_filler = 2,
        --node_stone = "",
        --node_water_top = "",
        --depth_water_top = ,
        --node_water = "",
        --node_river_water = "",
        y_min = 2,
        y_max = 31000,
        heat_point = 20,
        humidity_point = 75,
    })

    minetest.register_biome({
        name = "taiga_ocean",
        --node_dust = "",
        node_top = "default:sand",
        depth_top = 1,
        node_filler = "default:sand",
        depth_filler = 2,
        --node_stone = "",
        --node_water_top = "",
        --depth_water_top = ,
        --node_water = "",
        --node_river_water = "",
        y_min = -112,
        y_max = 1,
        heat_point = 20,
        humidity_point = 75,
    })

    -- Temperate

    minetest.register_biome({
        name = "stone_grassland",
        --node_dust = "",
        node_top = "default:dirt_with_grass",
        depth_top = 1,
        node_filler = "default:dirt",
        depth_filler = 0,
        --node_stone = "",
        --node_water_top = "",
        --depth_water_top = ,
        --node_water = "",
        --node_river_water = "",
        y_min = 5,
        y_max = 31000,
        heat_point = 45,
        humidity_point = 25,
    })

    minetest.register_biome({
        name = "stone_grassland_ocean",
        --node_dust = "",
        node_top = "default:sand",
        depth_top = 1,
        node_filler = "default:sand",
        depth_filler = 2,
        --node_stone = "",
        --node_water_top = "",
        --depth_water_top = ,
        --node_water = "",
        --node_river_water = "",
        y_min = -112,
        y_max = 4,
        heat_point = 45,
        humidity_point = 25,
    })


    minetest.register_biome({
        name = "coniferous_forest",
        --node_dust = "",
        node_top = "default:dirt_with_grass",
        depth_top = 1,
        node_filler = "default:dirt",
        depth_filler = 2,
        --node_stone = "",
        --node_water_top = "",
        --depth_water_top = ,
        --node_water = "",
        --node_river_water = "",
        y_min = 5,
        y_max = 31000,
        heat_point = 45,
        humidity_point = 75,
    })

    minetest.register_biome({
        name = "coniferous_forest_ocean",
        --node_dust = "",
        node_top = "default:sand",
        depth_top = 1,
        node_filler = "default:sand",
        depth_filler = 2,
        --node_stone = "",
        --node_water_top = "",
        --depth_water_top = ,
        --node_water = "",
        --node_river_water = "",
        y_min = -112,
        y_max = 4,
        heat_point = 45,
        humidity_point = 75,
    })


    minetest.register_biome({
        name = "sandstone_grassland",
        --node_dust = "",
        node_top = "default:dirt_with_grass",
        depth_top = 1,
        node_filler = "default:dirt",
        depth_filler = 0,
        node_stone = "default:sandstone",
        --node_water_top = "",
        --depth_water_top = ,
        --node_water = "",
        --node_river_water = "",
        y_min = 5,
        y_max = 31000,
        heat_point = 70,
        humidity_point = 25,
    })

    minetest.register_biome({
        name = "sandstone_grassland_ocean",
        --node_dust = "",
        node_top = "default:sand",
        depth_top = 1,
        node_filler = "default:sand",
        depth_filler = 2,
        node_stone = "default:sandstone",
        --node_water_top = "",
        --depth_water_top = ,
        --node_water = "",
        --node_river_water = "",
        y_min = -112,
        y_max = 4,
        heat_point = 70,
        humidity_point = 25,
    })


    minetest.register_biome({
        name = "deciduous_forest",
        --node_dust = "",
        node_top = "default:dirt_with_grass",
        depth_top = 1,
        node_filler = "default:dirt",
        depth_filler = 2,
        --node_stone = "",
        --node_water_top = "",
        --depth_water_top = ,
        --node_water = "",
        --node_river_water = "",
        y_min = 1,
        y_max = 31000,
        heat_point = 70,
        humidity_point = 75,
    })

    minetest.register_biome({
        name = "deciduous_forest_swamp",
        --node_dust = "",
        node_top = "default:dirt",
        depth_top = 1,
        node_filler = "default:dirt",
        depth_filler = 2,
        --node_stone = "",
        --node_water_top = "",
        --depth_water_top = ,
        --node_water = "",
        --node_river_water = "",
        y_min = -3,
        y_max = 0,
        heat_point = 70,
        humidity_point = 75,
    })

    minetest.register_biome({
        name = "deciduous_forest_ocean",
        --node_dust = "",
        node_top = "default:sand",
        depth_top = 1,
        node_filler = "default:sand",
        depth_filler = 2,
        --node_stone = "",
        --node_water_top = "",
        --depth_water_top = ,
        --node_water = "",
        --node_river_water = "",
        y_min = -112,
        y_max = -4,
        heat_point = 70,
        humidity_point = 75,
    })

    -- Hot

    minetest.register_biome({
        name = "desert",
        --node_dust = "",
        node_top = "default:desert_sand",
        depth_top = 1,
        node_filler = "default:desert_sand",
        depth_filler = 1,
        --node_stone = "default:desert_stone",
        --node_water_top = "",
        --depth_water_top = ,
        --node_water = "",
        --node_river_water = "",
        y_min = 5,
        y_max = 31000,
        heat_point = 95,
        humidity_point = 10,
    })

    minetest.register_biome({
        name = "desert_ocean",
        --node_dust = "",
        node_top = "default:sand",
        depth_top = 1,
        node_filler = "default:sand",
        depth_filler = 2,
        --node_stone = "default:desert_stone",
        --node_water_top = "",
        --depth_water_top = ,
        --node_water = "",
        --node_river_water = "",
        y_min = -112,
        y_max = 4,
        heat_point = 95,
        humidity_point = 10,
    })


    minetest.register_biome({
        name = "savanna",
        --node_dust = "",
        node_top = "default:dirt_with_dry_grass",
        depth_top = 1,
        node_filler = "default:dirt",
        depth_filler = 1,
        --node_stone = "",
        --node_water_top = "",
        --depth_water_top = ,
        --node_water = "",
        --node_river_water = "",
        y_min = 1,
        y_max = 31000,
        heat_point = 95,
        humidity_point = 50,
    })

    minetest.register_biome({
        name = "savanna_swamp",
        --node_dust = "",
        node_top = "default:dirt",
        depth_top = 1,
        node_filler = "default:dirt",
        depth_filler = 2,
        --node_stone = "",
        --node_water_top = "",
        --depth_water_top = ,
        --node_water = "",
        --node_river_water = "",
        y_min = -3,
        y_max = 0,
        heat_point = 95,
        humidity_point = 50,
    })

    minetest.register_biome({
        name = "savanna_ocean",
        --node_dust = "",
        node_top = "default:sand",
        depth_top = 1,
        node_filler = "default:sand",
        depth_filler = 2,
        --node_stone = "",
        --node_water_top = "",
        --depth_water_top = ,
        --node_water = "",
        --node_river_water = "",
        y_min = -112,
        y_max = -4,
        heat_point = 95,
        humidity_point = 50,
    })


    minetest.register_biome({
        name = "rainforest",
        --node_dust = "",
        node_top = "default:dirt_with_grass",
        depth_top = 1,
        node_filler = "default:dirt",
        depth_filler = 2,
        --node_stone = "",
        --node_water_top = "",
        --depth_water_top = ,
        --node_water = "",
        --node_river_water = "",
        y_min = 1,
        y_max = 31000,
        heat_point = 95,
        humidity_point = 90,
    })

    minetest.register_biome({
        name = "rainforest_swamp",
        --node_dust = "",
        node_top = "default:dirt",
        depth_top = 1,
        node_filler = "default:dirt",
        depth_filler = 2,
        --node_stone = "",
        --node_water_top = "",
        --depth_water_top = ,
        --node_water = "",
        --node_river_water = "",
        y_min = -3,
        y_max = 0,
        heat_point = 95,
        humidity_point = 90,
    })

    minetest.register_biome({
        name = "rainforest_ocean",
        --node_dust = "",
        node_top = "default:sand",
        depth_top = 1,
        node_filler = "default:sand",
        depth_filler = 2,
        --node_stone = "",
        --node_water_top = "",
        --depth_water_top = ,
        --node_water = "",
        --node_river_water = "",
        y_min = -112,
        y_max = -4,
        heat_point = 95,
        humidity_point = 90,
    })

    -- Underground

    minetest.register_biome({
        name = "underground",
        --node_dust = "",
        --node_top = "",
        --depth_top = ,
        --node_filler = "",
        --depth_filler = ,
        --node_stone = "",
        --node_water_top = "",
        --depth_water_top = ,
        --node_water = "",
        --node_river_water = "",
        y_min = -31000,
        y_max = -113,
        heat_point = 50,
        humidity_point = 50,
    })
end


--
-- Register decorations
--

-- Mgv6

function default.register_mgv6_decorations()
    minetest.clear_registered_decorations()

    -- Papyrus

    minetest.register_decoration({
        deco_type = "simple",
        place_on = {"default:dirt_with_grass"},
        sidelen = 8,
        noise_params = {
            offset = -0.3,
            scale = 0.7,
            spread = {x = 100, y = 100, z = 100},
            seed = 354,
            octaves = 3,
            persist = 0.7
        },
        y_min = 1,
        y_max = 1,
        decoration = "default:papyrus",
        height = 2,
        height_max = 4,
        spawn_by = "default:water_source",
        num_spawn_by = 1,
    })

    -- Cacti

    minetest.register_decoration({
        deco_type = "simple",
        place_on = {"default:desert_sand"},
        sidelen = 16,
        noise_params = {
            offset = -0.012,
            scale = 0.024,
            spread = {x = 100, y = 100, z = 100},
            seed = 230,
            octaves = 3,
            persist = 0.6
        },
        y_min = 1,
        y_max = 30,
        decoration = "default:cactus",
        height = 3,
            height_max = 4,
    })

    -- Long grasses

    for length = 1, 5 do
        minetest.register_decoration({
            deco_type = "simple",
            place_on = {"default:dirt_with_grass"},
            sidelen = 16,
            noise_params = {
                offset = 0,
                scale = 0.007,
                spread = {x = 100, y = 100, z = 100},
                seed = 329,
                octaves = 3,
                persist = 0.6
            },
            y_min = 1,
            y_max = 30,
            decoration = "default:grass_"..length,
        })
    end

    -- Dry shrubs

    minetest.register_decoration({
        deco_type = "simple",
        place_on = {"default:desert_sand", "default:dirt_with_snow"},
        sidelen = 16,
        noise_params = {
            offset = 0,
            scale = 0.035,
            spread = {x = 100, y = 100, z = 100},
            seed = 329,
            octaves = 3,
            persist = 0.6
        },
        y_min = 1,
        y_max = 30,
        decoration = "default:dry_shrub",
    })
end

-- All mapgens except mgv6 and singlenode

local function register_grass_decoration(offset, scale, length)
    minetest.register_decoration({
        deco_type = "simple",
        place_on = {"default:dirt_with_grass", "default:sand"},
        sidelen = 16,
        noise_params = {
            offset = offset,
            scale = scale,
            spread = {x = 200, y = 200, z = 200},
            seed = 329,
            octaves = 3,
            persist = 0.6
        },
        biomes = {"stone_grassland", "sandstone_grassland",
            "deciduous_forest", "coniferous_forest"},
        y_min = 1,
        y_max = 31000,
        decoration = "default:grass_"..length,
    })
end

local function register_dry_grass_decoration(offset, scale, length)
    minetest.register_decoration({
        deco_type = "simple",
        place_on = {"default:dirt_with_dry_grass"},
        sidelen = 16,
        noise_params = {
            offset = offset,
            scale = scale,
            spread = {x = 200, y = 200, z = 200},
            seed = 329,
            octaves = 3,
            persist = 0.6
        },
        biomes = {"savanna"},
        y_min = 1,
        y_max = 31000,
        decoration = "default:dry_grass_"..length,
    })
end

function default.register_decorations()
    minetest.clear_registered_decorations()

    -- Apple tree

    minetest.register_decoration({
        deco_type = "schematic",
        place_on = {"default:dirt_with_grass"},
        sidelen = 16,
        noise_params = {
            offset = 0.04,
            scale = 0.02,
            spread = {x = 250, y = 250, z = 250},
            seed = 2,
            octaves = 3,
            persist = 0.66
        },
        biomes = {"deciduous_forest"},
        y_min = 1,
        y_max = 31000,
        schematic = minetest.get_modpath("default").."/schematics/apple_tree.mts",
        flags = "place_center_x, place_center_z",
    })

    -- Jungle tree

    minetest.register_decoration({
        deco_type = "schematic",
        place_on = {"default:dirt_with_grass", "default:dirt"},
        sidelen = 80,
        fill_ratio = 0.09,
        biomes = {"rainforest", "rainforest_swamp"},
        y_min = 0,
        y_max = 31000,
        schematic = minetest.get_modpath("default").."/schematics/jungle_tree.mts",
        flags = "place_center_x, place_center_z",
        rotation = "random",
    })

    -- Taiga and temperate forest pine tree

    minetest.register_decoration({
        deco_type = "schematic",
        place_on = {"default:snowblock", "default:dirt_with_grass"},
        sidelen = 16,
        noise_params = {
            offset = 0.04,
            scale = 0.02,
            spread = {x = 250, y = 250, z = 250},
            seed = 2,
            octaves = 3,
            persist = 0.66
        },
        biomes = {"taiga", "coniferous_forest"},
        y_min = 2,
        y_max = 31000,
        schematic = minetest.get_modpath("default").."/schematics/pine_tree.mts",
        flags = "place_center_x, place_center_z",
    })

    -- Acacia tree

    minetest.register_decoration({
        deco_type = "schematic",
        place_on = {"default:dirt_with_dry_grass"},
        sidelen = 80,
        noise_params = {
            offset = 0,
            scale = 0.003,
            spread = {x = 250, y = 250, z = 250},
            seed = 2,
            octaves = 3,
            persist = 0.66
        },
        biomes = {"savanna"},
        y_min = 1,
        y_max = 31000,
        schematic = minetest.get_modpath("default").."/schematics/acacia_tree.mts",
        flags = "place_center_x, place_center_z",
        rotation = "random",
    })

    -- Large cactus

    minetest.register_decoration({
        deco_type = "schematic",
        place_on = {"default:desert_sand"},
        sidelen = 80,
        noise_params = {
            offset = -0.0005,
            scale = 0.0015,
            spread = {x = 200, y = 200, z = 200},
            seed = 230,
            octaves = 3,
            persist = 0.6
        },
        biomes = {"desert"},
        y_min = 5,
        y_max = 31000,
        schematic = minetest.get_modpath("default").."/schematics/large_cactus.mts",
        flags = "place_center_x",
        rotation = "random",
    })

    -- Cactus

    minetest.register_decoration({
        deco_type = "simple",
        place_on = {"default:desert_sand"},
        sidelen = 80,
        noise_params = {
            offset = -0.0005,
            scale = 0.0015,
            spread = {x = 200, y = 200, z = 200},
            seed = 230,
            octaves = 3,
            persist = 0.6
        },
        biomes = {"desert"},
        y_min = 5,
        y_max = 31000,
        decoration = "default:cactus",
        height = 2,
        height_max = 5,
    })

    -- Papyrus

    minetest.register_decoration({
        deco_type = "schematic",
        place_on = {"default:dirt"},
        sidelen = 16,
        noise_params = {
            offset = -0.3,
            scale = 0.7,
            spread = {x = 200, y = 200, z = 200},
            seed = 354,
            octaves = 3,
            persist = 0.7
        },
        biomes = {"savanna_swamp"},
        y_min = 0,
        y_max = 0,
        schematic = minetest.get_modpath("default").."/schematics/papyrus.mts",
    })

    -- Grasses

    register_grass_decoration(-0.03,  0.09,  5)
    register_grass_decoration(-0.015, 0.075, 4)
    register_grass_decoration(0,      0.06,  3)
    register_grass_decoration(0.015,  0.045, 2)
    register_grass_decoration(0.03,   0.03,  1)

    -- Dry grasses

    register_dry_grass_decoration(0.01, 0.05,  5)
    register_dry_grass_decoration(0.03, 0.03,  4)
    register_dry_grass_decoration(0.05, 0.01,  3)
    register_dry_grass_decoration(0.07, -0.01, 2)
    register_dry_grass_decoration(0.09, -0.03, 1)

    -- Junglegrass

    minetest.register_decoration({
        deco_type = "simple",
        place_on = {"default:dirt_with_grass"},
        sidelen = 80,
        fill_ratio = 0.1,
        biomes = {"rainforest"},
        y_min = 1,
        y_max = 31000,
        decoration = "default:junglegrass",
    })

    -- Dry shrub

    minetest.register_decoration({
        deco_type = "simple",
        place_on = {"default:desert_sand", "default:dirt_with_snow"},
        sidelen = 16,
        noise_params = {
            offset = 0,
            scale = 0.02,
            spread = {x = 200, y = 200, z = 200},
            seed = 329,
            octaves = 3,
            persist = 0.6
        },
        biomes = {"desert", "tundra"},
        y_min = 2,
        y_max = 31000,
        decoration = "default:dry_shrub",
    })
end

--
-- Detect mapgen to select functions
--

-- Mods using singlenode mapgen can call these functions to enable
-- the use of minetest.generate_ores or minetest.generate_decorations

local mg_params = minetest.get_mapgen_params()
if mg_params.mgname == "v6" or mg_params.mgname == "indev" then
    default.register_ores()
    default.register_mgv6_decorations()
elseif mg_params.mgname ~= "singlenode" then
    default.register_ores()
    default.register_biomes()
    default.register_decorations()
end
