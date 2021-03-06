--{{{ Sounds
function default.node_sound_defaults(table)
    table = table or {}
    table.footstep = table.footstep or
            {name="", gain=1.0}
    table.dug = table.dug or
            {name="default_dug_node", gain=0.25}
    table.place = table.place or
            {name="default_place_node_hard", gain=1.0}
    return table
end

function default.node_sound_stone_defaults(table)
    table = table or {}
    table.footstep = table.footstep or
            {name="default_hard_footstep", gain=0.5}
    table.dug = table.dug or
            {name="default_hard_footstep", gain=1.0}
    default.node_sound_defaults(table)
    return table
end

function default.node_sound_dirt_defaults(table)
    table = table or {}
    table.footstep = table.footstep or
            {name="default_dirt_footstep", gain=1.0}
    table.dug = table.dug or
            {name="default_dirt_footstep", gain=1.5}
    table.place = table.place or
            {name="default_place_node", gain=1.0}
    default.node_sound_defaults(table)
    return table
end

function default.node_sound_sand_defaults(table)
    table = table or {}
    table.footstep = table.footstep or
            {name="default_sand_footstep", gain=0.2}
    table.dug = table.dug or
            {name="default_sand_footstep", gain=0.4}
    table.place = table.place or
            {name="default_place_node", gain=1.0}
    default.node_sound_defaults(table)
    return table
end

function default.node_sound_wood_defaults(table)
    table = table or {}
    table.footstep = table.footstep or
            {name="default_wood_footstep", gain=0.5}
    table.dug = table.dug or
            {name="default_wood_footstep", gain=1.0}
    default.node_sound_defaults(table)
    return table
end

function default.node_sound_leaves_defaults(table)
    table = table or {}
    table.footstep = table.footstep or
            {name="default_grass_footstep", gain=0.35}
    table.dug = table.dug or
            {name="default_grass_footstep", gain=0.7}
    table.dig = table.dig or
            {name="default_dig_crumbly", gain=0.4}
    table.place = table.place or
            {name="default_place_node", gain=1.0}
    default.node_sound_defaults(table)
    return table
end

function default.node_sound_glass_defaults(table)
    table = table or {}
    table.footstep = table.footstep or
            {name="default_glass_footstep", gain=0.5}
    table.dug = table.dug or
            {name="default_break_glass", gain=1.0}
    default.node_sound_defaults(table)
    return table
end
--}}}

--{{{ Lavacooling ABM
minetest.register_abm({
    nodenames = {"default:lava_source", "default:lava_flowing"},
    neighbors = {"group:water"},
    interval = 3,
    chance = 3,
    action =
    function(pos, node, active_object_count, active_object_count_wider)
        core.freeze_melt(pos, -1);
        minetest.sound_play("default_cool_lava", {
            pos = pos,
            max_hear_distance = 16,
            gain = 0.25
        })
    end,
})

minetest.register_abm({
    nodenames = {"default:lava_source", "default:lava_flowing"},
    interval = 100,
    chance = 10,
    action =
    function(pos, node, active_object_count, active_object_count_wider)
        -- bad place: to not freeze lava in caves
        if not pos.y or pos.y < -100 then return end
        -- skip springs
        if node.param2 >= 128 then return end
        local light = core.get_node_light({x=pos.x,y=pos.y+1, z=pos.z}, 0.5)
        if not light or light < default.LIGHT_MAX then return end
        core.freeze_melt(pos, -1);
    end,
})
--}}}

--{{{ Papyrus and cactus growing
minetest.register_abm({
    nodenames = {"default:cactus"},
    neighbors = {"group:sand"},
    interval = 50,
    chance = 20,
    action = function(pos, node)
        pos.y = pos.y-1
        local name = minetest.get_node(pos).name
        if minetest.get_item_group(name, "sand") ~= 0 then
            pos.y = pos.y+1
            local height = 0
            while minetest.get_node(pos).name == "default:cactus" and height < 4 do
                height = height+1
                pos.y = pos.y+1
            end
            if height < 4 then
                if minetest.get_node(pos).name == "air" then
                    minetest.set_node(pos, {name="default:cactus"})
                end
            end
        end
    end,
})

minetest.register_abm({
    nodenames = {"default:papyrus"},
    neighbors = {"default:dirt", "default:dirt_with_grass"},
    interval = 50,
    chance = 20,
    action = function(pos, node)
        pos.y = pos.y-1
        local name = minetest.get_node(pos).name
        if name == "default:dirt" or name == "default:dirt_with_grass" then
            if minetest.find_node_near(pos, 3, {"group:water"}) == nil then
                return
            end
            pos.y = pos.y+1
            local height = 0
            while minetest.get_node(pos).name == "default:papyrus" and height < 4 do
                height = height+1
                pos.y = pos.y+1
            end
            if height < 4 then
                if minetest.get_node(pos).name == "air" then
                    minetest.set_node(pos, {name="default:papyrus"})
                end
            end
        end
    end,
})
--}}}

--{{{ Leafdecay
default.leafdecay_trunk_cache = {}
default.leafdecay_enable_cache = true
-- Spread the load of finding trunks
default.leafdecay_trunk_find_allow_accumulator = 0

minetest.register_globalstep(function(dtime)
    local finds_per_second = 5000
    default.leafdecay_trunk_find_allow_accumulator =
            math.floor(dtime * finds_per_second)
end)

default.after_place_leaves = function(pos, placer, itemstack, pointed_thing)
    local node = minetest.get_node(pos)
    node.param2 = 1
    minetest.set_node(pos, node)
end

minetest.register_abm({
    nodenames = {"group:leafdecay"},
    neighbors = {"air", "group:liquid"},
    -- A low interval and a high inverse chance spreads the load
    interval = 10,
    chance = 3,

    action = function(p0, node, _, _)
        --print("leafdecay ABM at "..p0.x..", "..p0.y..", "..p0.z..")")
        local do_preserve = false
        local d = minetest.registered_nodes[node.name].groups.leafdecay
        if not d or d == 0 then
            --print("not groups.leafdecay")
            return
        end
        local n0 = minetest.get_node(p0)
        if n0.param2 ~= 0 then
            --print("param2 ~= 0")
            return
        end
        local p0_hash = nil
        if default.leafdecay_enable_cache then
            p0_hash = minetest.hash_node_position(p0)
            local trunkp = default.leafdecay_trunk_cache[p0_hash]
            if trunkp then
                local n = minetest.get_node(trunkp)
                local reg = minetest.registered_nodes[n.name]
                -- Assume ignore is a trunk, to make the thing
                -- work at the border of the active area
                if n.name == "ignore" or (reg and reg.groups.tree and
                        reg.groups.tree ~= 0) then
                    --print("cached trunk still exists")
                    return
                end
                --print("cached trunk is invalid")
                -- Cache is invalid
                table.remove(default.leafdecay_trunk_cache, p0_hash)
            end
        end
        if default.leafdecay_trunk_find_allow_accumulator <= 0 then
            return
        end
        default.leafdecay_trunk_find_allow_accumulator =
                default.leafdecay_trunk_find_allow_accumulator - 1
        -- Assume ignore is a trunk, to make the thing
        -- work at the border of the active area
        local p1 = minetest.find_node_near(p0, d, {"ignore", "group:tree"})
        if p1 then
            do_preserve = true
            if default.leafdecay_enable_cache then
                --print("caching trunk")
                -- Cache the trunk
                default.leafdecay_trunk_cache[p0_hash] = p1
            end
        end
        if not do_preserve then
            -- Drop stuff other than the node itself
            local itemstacks = minetest.get_node_drops(n0.name)
            for _, itemname in ipairs(itemstacks) do
                if minetest.get_item_group(n0.name, "leafdecay_drop") ~= 0 or
                        itemname ~= n0.name then
                    local p_drop = {
                        x = p0.x - 0.5 + math.random(),
                        y = p0.y - 0.5 + math.random(),
                        z = p0.z - 0.5 + math.random(),
                    }
                    minetest.add_item(p_drop, itemname)
                end
            end
            -- Remove node
            minetest.remove_node(p0)
            nodeupdate(p0)
        end
    end
})
--}}}

--{{{ Grass growing on well-lit dirt
if not default.weather then
    minetest.register_abm({
        nodenames = {"default:dirt"},
        interval = 2,
        chance = 200,
        action = function(pos, node)
            local above = {x = pos.x, y = pos.y + 1, z = pos.z}
            local name = minetest.get_node(above).name
            local nodedef = minetest.registered_nodes[name]
            if nodedef
            and (nodedef.sunlight_propagates or nodedef.paramtype == "light")
            and nodedef.liquidtype == "none"
            and (minetest.get_node_light(above) or 0) >= 13
            then
                if name == "default:snow" or name == "default:snowblock" then
                    minetest.set_node(pos, {name = "default:dirt_with_snow"})
                else
                    minetest.set_node(pos, {name = "default:dirt_with_grass"})
                end
            end
        end
    })

    -- Grass and dry grass removed in darkness
    minetest.register_abm({
        nodenames = {"default:dirt_with_grass", "default:dirt_with_dry_grass"},
        interval = 2,
        chance = 20,
        action = function(pos, node)
            local above = {x = pos.x, y = pos.y + 1, z = pos.z}
            local name = minetest.get_node(above).name
            local nodedef = minetest.registered_nodes[name]
            if name ~= "ignore"
            and nodedef
            and not (
                (nodedef.sunlight_propagates or nodedef.paramtype == "light")
                and nodedef.liquidtype == "none"
            )
            then
                minetest.set_node(pos, {name = "default:dirt"})
            end
        end
    })
end
--}}}

--{{{ Moss growth on cobble near water
minetest.register_abm({
    nodenames = {"default:cobble"},
    neighbors = {"group:water"},
    interval = 17,
    chance = 200,
    neighbors_range = 2,
    --catch_up = false,
    action = function(pos, node)
        minetest.set_node(pos, {name = "default:mossycobble"})
    end
})
--}}}

--{{{ Modname getting and stripping
function default.get_modname (name)
    if name:sub(1,1) ~= ":" then
        return name:sub(1, name:find(":") - 1)
    else
        return name:sub(2, name:find(":") - 1)
    end
end

function default.strip_modname (name)
    if name:sub(1,1) ~= ":" then
        return name:sub(name:find(":") + 1)
    else
        return name:sub(name:find(":", 2) + 1)
    end
end
--}}}

--{{{ Cyrillic lower
string.CYRILLIC_LOWER = {
    ["А"] = "а",
    ["Б"] = "б",
    ["В"] = "в",
    ["Г"] = "г",
    ["Д"] = "д",
    ["Е"] = "е",
    ["Ё"] = "ё",
    ["Ж"] = "ж",
    ["З"] = "з",
    ["И"] = "и",
    ["Й"] = "й",
    ["К"] = "к",
    ["Л"] = "л",
    ["М"] = "м",
    ["Н"] = "н",
    ["О"] = "о",
    ["П"] = "п",
    ["Р"] = "р",
    ["С"] = "с",
    ["Т"] = "т",
    ["У"] = "у",
    ["Ф"] = "ф",
    ["Х"] = "х",
    ["Ц"] = "ц",
    ["Ч"] = "ч",
    ["Ш"] = "ш",
    ["Щ"] = "щ",
    ["Ъ"] = "ъ",
    ["Ы"] = "ы",
    ["Ь"] = "ь",
    ["Э"] = "э",
    ["Ю"] = "ю",
    ["Я"] = "я",
}

function string.lower_cyr (str)
    for upper, lower in pairs(string.CYRILLIC_LOWER) do
        str = str:gsub(upper, lower)
    end
    return str
end
--}}}

--{{{ Cyrillic string index fix
function string.cyr_index (s, index)
    local new_index = index
    local step_index = index

    local function increase_index()
        new_index = new_index + 1
    end

    repeat
        step_index = new_index
        new_index = index
        local sub = s:sub(1, step_index)
        for upper, lower in pairs(string.CYRILLIC_LOWER) do
            sub:gsub(upper, increase_index)
            sub:gsub(lower, increase_index)
        end
    until step_index == new_index

    return step_index
end
--}}}

--{{{ string: Find nearest
function string.find_nearest(s, pattern, index, range)
    local i = s:cyr_index(index)

    local before = s:sub(1, i - 1)
    local after = s:sub(i + 1)

    if range then
        before = before:sub(before:cyr_index(index - range))
        after = after:sub(1, after:cyr_index(range))
    end

    local first_before = before:reverse():find(pattern)
    local first_after = after:find(pattern)

    if first_before == nil and first_after ~= nil then
        return i + first_after
    elseif first_before ~=nil and first_after == nil then
        return i - first_before
    elseif first_before ~= nil and first_after ~= nil then
        if first_before < first_after then
            return i - first_before
        else
            return i + first_after
        end
    else
        return
    end
end
--}}}

--{{{ Child attachments
function default.get_attached(parent, bone, position, rotation)
    local result = {}

    for _, entity in pairs(minetest.luaentities) do
        local object = entity.object
        local o_parent, o_bone, o_pos, o_rot = object:get_attach()

        if o_parent ~= nil and o_parent == parent
        and (bone == nil or o_bone == bone)
        and (position == nil or vector.equals(o_pos, position))
        and (rotation == nil or vector.equals(o_rot, rotation))
        then
            table.insert(result, object)
        end
    end

    return result
end
--}}}

--{{{ Delete table elemet
function table.delete(t, value, all)
    if value == nil then return end
    local all = all or false

    for k,v in pairs(table) do
        if v == value then
            t[k] = nil

            if not all then return true end
        end
    end
    return true
end
--}}}
