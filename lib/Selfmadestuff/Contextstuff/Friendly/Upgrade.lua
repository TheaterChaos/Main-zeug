local config = {
    upgrade=1
}

function upgrade_vehicle(vehicle)
	if entities.request_control(vehicle, 200) then
		SET_VEHICLE_MOD_KIT(vehicle, 0)
    	for i = 0, 49 do
       		local num = entities.get_upgrade_max_value(vehicle, i)
       		entities.set_upgrade_value(vehicle, i, num)
   		end
	end
end

function randomupgrade_vehicle(vehicle)
	if entities.request_control(vehicle, 200) then
		SET_VEHICLE_MOD_KIT(vehicle, 0)
    	for i = 0, 49 do
       		local num = entities.get_upgrade_max_value(vehicle, i)
			if num < 0 then
				num = -1
			end
				numupgrade = math.random( -1, num )
       			entities.set_upgrade_value(vehicle, i, numupgrade)
   		end
	end
end

function downggrade_vehicle(vehicle)
	if entities.request_control(vehicle, 200) then
    	for i = 0, 49 do
       		--local num = entities.get_upgrade_max_value(vehicle, i)
			   REMOVE_VEHICLE_MOD(vehicle, i)
       		--entities.set_upgrade_value(vehicle, i, num)
   		end
	end
end

return {
    name="Upgrade",
    help="Upgrade to the state what in settings is standard full",
    applicable_to={"VEHICLE"},
    execute=function(target)
        if config.upgrade == 1 then
            upgrade_vehicle(target.handle)
        elseif config.upgrade == 2 then
            randomupgrade_vehicle(target.handle)
        elseif config.upgrade == 3 then
            downggrade_vehicle(target.handle)
        end
    end,
    config_menu=function(menu_root)
        menu.list_select(menu_root, "Upgrade", {}, "", {"full", "random", "down"}, 1, function(index)
            config.upgrade = index
        end)
    end,
}

