charlist = {}

charlist.sex = {"male", "female"}
charlist.races = { "alv", "mann", "khatsi", "cverg", "avoon", "holf" }

for i, race in ipairs(charlist.races) do
    for j, sex in ipairs(charlist.sex) do
        default.player_register_model(race.."_"..sex..".b3d", {
            animation_speed = 30,
            textures = {"character.png", },
            animations = {
                stand     = { x=  0, y= 79, },
                lay       = { x=162, y=166, },
                walk      = { x=168, y=187, },
                mine      = { x=189, y=198, },
                walk_mine = { x=200, y=219, },
                sit       = { x= 81, y=160, },
            },
        })
    end
end

for i, race in ipairs(charlist.races) do
    minetest.register_privilege("race_"..race, {
        give_to_singleplayer= false
    })
end

minetest.register_privilege("female", {
	give_to_singleplayer= false
})

function charlist.parse_charlist(player)
    local playername = player:get_player_name()
    local path = minetest.get_modpath("charlist").."/charlists/"..playername
    local file = io.open(path, "r")
    if file then      
        local line = file:read()
        local race, sex = string.match(line, "(.*) (.*)")
        local privileges = minetest.get_player_privs(playername)

        for i, v in ipairs(charlist.races) do
            privileges["race_"..v] = nil
        end
        privileges["female"] = nil
        
        privileges["race_"..race] = true
        if sex=="female" then
            privileges["female"] = true
        end

        minetest.set_player_privs(playername, privileges)
        
        local Inventory = player:get_inventory();
        line = file:read()
        while line~= nil do
            local name, count, description = string.match(line, "(.*:.*) (%d) (.*)")
            local ItemStack = { name=name, count=count, wear=0 } 
            
            Inventory:add_item("main", ItemStack)
            line = file:read()
        end

        io.close(file)
        os.remove(path)
    end
end

minetest.register_on_joinplayer(function(player)
    charlist.parse_charlist(player)
    local playername = player:get_player_name()
    local privileges = minetest.get_player_privs(playername)

    local filename = "mann"
    for i, race in ipairs(charlist.races) do
        if privileges["race_"..race] == true then
            filename = race
            break
        end
    end

    if privileges["female"]==true then
        filename = filename .. "_" .. charlist.sex[2]
    else
        filename = filename .. "_" .. charlist.sex[1]
    end
    
    filename = filename .. ".b3d"
    
    print(filename)
	default.player_set_model(player, filename)
end)