function getpedsinvehicle(vehicle)
	local pedstable = {}
	if not IS_VEHICLE_SEAT_FREE(vehicle, -1, false) then
		table.insert(pedstable, GET_PED_IN_VEHICLE_SEAT(vehicle, -1, true))
	end
	local maxPassengers = GET_VEHICLE_MAX_NUMBER_OF_PASSENGERS(vehicle)
	for i = 0, maxPassengers do
		if not IS_VEHICLE_SEAT_FREE(vehicle, i, false) then
			local pedinveh = GET_PED_IN_VEHICLE_SEAT(vehicle, i, true)
			table.insert(pedstable, pedinveh)
		end
	end
	if pedstable == {} then
		return 0
	else
		return pedstable
	end
end

return {
    name="open entity",
    help="open the entity in near enitiys",
    applicable_to={"VEHICLE", "PED", "OBJECT"},
    execute=function(target)
        local found = false
        local ref
        if IS_ENTITY_A_PED(target.handle) then
            ref = "Stand>Lua Scripts>"..SCRIPT_NAME..">Entity Manager>Near Entitys>Peds"
        elseif IS_ENTITY_A_VEHICLE(target.handle) then
            ref = "Stand>Lua Scripts>"..SCRIPT_NAME..">Entity Manager>Near Entitys>vehicles"
        elseif IS_ENTITY_AN_OBJECT(target.handle) then
            if IS_OBJECT_A_PICKUP(target.handle) then
                ref = "Stand>Lua Scripts>"..SCRIPT_NAME..">Entity Manager>Near Entitys>Pickups"
            else
                ref = "Stand>Lua Scripts>"..SCRIPT_NAME..">Entity Manager>Near Entitys>Objects"
            end
        end
        for _, refinlist in pairs(menu.get_children(menu.ref_by_path(ref))) do
            if _ == 1 then
                menu.trigger_command(refinlist, "")
                break
            end
        end
        local pPos = players.get_position(players.user())
		local ePos = target.pos
		local dist = math.floor(pPos:distance(ePos)) + 100
        if dist < 200 then
            dist = 200
        end
        if IS_ENTITY_A_VEHICLE(target.handle) then
            local pedsinveh = getpedsinvehicle(target.handle)
            if pedsinveh != 0 then
                for _, ped in pairs(pedsinveh) do
                    if IS_PED_A_PLAYER(ped) then
                        menu.set_value(menu.ref_by_path("Stand>Lua Scripts>"..SCRIPT_NAME..">Entity Manager>Near Entitys>Show players"), true)
                        break
                    end
                end
            end
        end
        menu.set_value(menu.ref_by_path("Stand>Lua Scripts>"..SCRIPT_NAME..">Entity Manager>Near Entitys>Only Mission entitys"), false)
        menu.set_value(menu.ref_by_path("Stand>Lua Scripts>"..SCRIPT_NAME..">Entity Manager>Near Entitys>Range to load"), dist)
        menu.trigger_command(menu.ref_by_path(ref))
        util.yield(300)
        for _, refinlist in pairs(menu.get_children(menu.ref_by_path(ref))) do
            if _ > 2 then
                local helptext = menu.get_help_text(refinlist)
                helptext = helptext:lower()
                local handle = string.strip(helptext, "[]")
                if string.contains(handle, target.handle) then
                    menu.trigger_command(refinlist)
                    util.toast("send to list")
                    found = true
                    break
                end
            end
        end
        if not found then
            util.toast("not found")
            menu.trigger_command(menu.ref_by_path("Stand>Lua Scripts>"..SCRIPT_NAME))
        end
    end
}