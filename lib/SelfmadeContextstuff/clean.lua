
local config = {
    vehicles = true,
    peds = true,
    objects = true,
    range = 10,
}

local function get_player_vehicle_handles()
    local player_vehicle_handles = {}
    for _, pid in pairs(players.list()) do
        local player_ped = GET_PLAYER_PED(pid)
        local veh
        if IS_PED_IN_ANY_VEHICLE(player_ped) then
            veh = GET_VEHICLE_PED_IS_IN(player_ped, true)
        else
            veh = 0
        end
        if veh then
            player_vehicle_handles[pid] = veh
        end
    end
    return player_vehicle_handles
end

local function is_entity_occupied(entity, player_vehicle_handles)
    if IS_ENTITY_A_VEHICLE(entity) then
        for _, vehicle_handle in pairs(player_vehicle_handles) do
            if entity == vehicle_handle then
                return true
            end
        end
    end
    return false
end

local function delete_entities_by_range(my_entities, origin_pos, range)
    local player_vehicle_handles = get_player_vehicle_handles()
    local count = 0
    for _, entity in ipairs(my_entities) do
        local entity_pos = GET_ENTITY_COORDS(entity, 1)
        local dist = VDIST(origin_pos.x, origin_pos.y, origin_pos.z, entity_pos.x, entity_pos.y, entity_pos.z)
        if dist <= range then
            if not is_entity_occupied(entity, player_vehicle_handles) then
                entities.delete_by_handle(entity)
                count = count + 1
            end
        end
    end
    return count
end

return {
    name="Clean Up",
    help="Clear area of all vehicles, objects and peds by deleting them",
    applicable_to={"COORDS"},
    hotkey="BACKSPACE",
    execute=function(target)
        if config.objects then
            local num_deleted_objects = delete_entities_by_range(entities.get_all_objects_as_handles(), target.pos, config.range)
            util.toast("Deleted "..num_deleted_objects.." Objects")
        end
        if config.peds then
            local num_deleted_peds = delete_entities_by_range(entities.get_all_peds_as_handles(), target.pos, config.range)
            util.toast("Deleted "..num_deleted_peds.." Peds")
        end
        if config.vehicles then
            local num_deleted_vehicles = delete_entities_by_range(entities.get_all_vehicles_as_handles(), target.pos, config.range)
            util.toast("Deleted "..num_deleted_vehicles.." vehicles")
        end
    end,
    config_menu=function(menu_root)
        menu_root:toggle("Vehicles", {}, "Clear area of vehicles", function(value)
            config.vehicles = value
        end, config.vehicles)
        menu_root:toggle("Ped/Npcs", {}, "Clear area of Ped/Npcs", function(value)
            config.peds = value
        end, config.peds)
        menu_root:toggle("Objects", {}, "Clear area of Objects", function(value)
            config.objects = value
        end, config.objects)
        menu_root:slider("Range", {"contextsetrangetoclear"}, "Set the range to delete", 0, 1000, config.range, 10, function(value)
            config.range = value
        end, config.range)
    end
}