local config = {
    delete=false
}

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

function emptyvehicle(vehicle)
    local pedsinveh = getpedsinvehicle(vehicle)
    if pedsinveh != 0 then
        for _, ped in pairs(pedsinveh) do
            if IS_PED_A_PLAYER(ped) then
                menu.trigger_commands("vehkick"..players.get_name(NETWORK_GET_PLAYER_INDEX_FROM_PED(ped)))
            else
                if config.delete then
                    entities.delete(ped)
                else
                    entities.request_control(ped, 200)
                    CLEAR_PED_TASKS_IMMEDIATELY(ped)
                end
            end
        end
    end
end

return {
    name="Empty veh",
    help="Empty the veh of NPCS",
    applicable_to={"VEHICLE"},
    execute=function(target)
        emptyvehicle(target.handle)
        util.toast("Vehicle is gettings cleared")
    end,
    config_menu=function(menu_root)
        menu_root:toggle("Delete", {}, "NO = Delete the NPCs in car \nOFF = kicks the NPCs in car\nplayers will also be kicked", function(value)
            config.delete = value
        end, config.delete)
    end
}