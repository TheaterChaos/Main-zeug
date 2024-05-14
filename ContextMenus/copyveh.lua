function setVehiclePlate(vehicle, text)
    if text and text:len() > 0 then
        SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle, text)
    end
end

local minimum = memory.alloc()
	local maximum = memory.alloc()
	function getDimensions(entity)
	    GET_MODEL_DIMENSIONS(GET_ENTITY_MODEL(entity), minimum, maximum)
	    local minimum_vec = v3.new(minimum)
	    local maximum_vec = v3.new(maximum)
	    local dimensions = {
	        x = maximum_vec.y - minimum_vec.y,
	        y = maximum_vec.x - minimum_vec.x,
	        z = maximum_vec.z - minimum_vec.z
	    }
	    return dimensions
	end

    local colorR, colorG, colorB = memory.alloc(1), memory.alloc(1), memory.alloc(1)
function copyVehicleData(vehicle, cloneVehicle)
    SET_VEHICLE_MOD_KIT(cloneVehicle, 0)
    for i = 17, 22 do
        TOGGLE_VEHICLE_MOD(cloneVehicle, i, IS_TOGGLE_MOD_ON(vehicle, i))
    end
    for i = 0, 49 do
        local modValue = GET_VEHICLE_MOD(vehicle, i)
        SET_VEHICLE_MOD(cloneVehicle, i, modValue)
    end
    if GET_IS_VEHICLE_PRIMARY_COLOUR_CUSTOM(vehicle) then
        GET_VEHICLE_CUSTOM_PRIMARY_COLOUR(vehicle, colorR, colorG, colorB)
        SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(cloneVehicle, memory.read_ubyte(colorR), memory.read_ubyte(colorG), memory.read_ubyte(colorB))
    else
        GET_VEHICLE_MOD_COLOR_1(vehicle, colorR, colorG, colorB)
        SET_VEHICLE_MOD_COLOR_1(cloneVehicle, memory.read_ubyte(colorR), memory.read_ubyte(colorG), memory.read_ubyte(colorB))
    end
    if GET_IS_VEHICLE_SECONDARY_COLOUR_CUSTOM(vehicle) then
        GET_VEHICLE_CUSTOM_SECONDARY_COLOUR(vehicle, colorR, colorG, colorB)
        SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(cloneVehicle, memory.read_ubyte(colorR), memory.read_ubyte(colorG), memory.read_ubyte(colorB))
    else
        GET_VEHICLE_MOD_COLOR_2(vehicle, colorR, colorG)
        SET_VEHICLE_MOD_COLOR_2(cloneVehicle, memory.read_ubyte(colorR), memory.read_ubyte(colorG))
    end
    GET_VEHICLE_COLOURS(vehicle, colorR, colorG)
    SET_VEHICLE_COLOURS(cloneVehicle, memory.read_ubyte(colorR), memory.read_ubyte(colorG))
    GET_VEHICLE_EXTRA_COLOURS(vehicle, colorR, colorG)
    SET_VEHICLE_EXTRA_COLOURS(cloneVehicle, memory.read_ubyte(colorR), memory.read_ubyte(colorG))
    GET_VEHICLE_EXTRA_COLOUR_5(vehicle, colorR)
    GET_VEHICLE_EXTRA_COLOUR_6(vehicle, colorG)
    SET_VEHICLE_EXTRA_COLOUR_5(cloneVehicle, memory.read_ubyte(colorR))
    SET_VEHICLE_EXTRA_COLOUR_6(cloneVehicle, memory.read_ubyte(colorG))
    GET_VEHICLE_TYRE_SMOKE_COLOR(vehicle, colorR, colorG, colorB)
    SET_VEHICLE_TYRE_SMOKE_COLOR(cloneVehicle, memory.read_ubyte(colorR), memory.read_ubyte(colorG), memory.read_ubyte(colorB))
    GET_VEHICLE_NEON_COLOUR(vehicle, colorR, colorG, colorB)
    SET_VEHICLE_NEON_COLOUR(cloneVehicle, memory.read_ubyte(colorR), memory.read_ubyte(colorG), memory.read_ubyte(colorB))
    for i = 0, 3 do
        SET_VEHICLE_NEON_ENABLED(cloneVehicle, i, GET_VEHICLE_NEON_ENABLED(vehicle, i))
    end
    local windowTint = GET_VEHICLE_WINDOW_TINT(vehicle)
    SET_VEHICLE_WINDOW_TINT(cloneVehicle, windowTint)
    local lightsColor = GET_VEHICLE_XENON_LIGHT_COLOR_INDEX(vehicle)
    SET_VEHICLE_XENON_LIGHT_COLOR_INDEX(cloneVehicle, lightsColor)
    SET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(cloneVehicle, GET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(vehicle))
    setVehiclePlate(cloneVehicle, GET_VEHICLE_NUMBER_PLATE_TEXT(vehicle))
    SET_VEHICLE_TYRES_CAN_BURST(cloneVehicle, GET_VEHICLE_TYRES_CAN_BURST(vehicle))
    SET_VEHICLE_DIRT_LEVEL(cloneVehicle, GET_VEHICLE_DIRT_LEVEL(vehicle))
    for i = 1, 14 do
        SET_VEHICLE_EXTRA(cloneVehicle, i, not IS_VEHICLE_EXTRA_TURNED_ON(vehicle, i))
    end
    local roofState = GET_CONVERTIBLE_ROOF_STATE(vehicle)
    if roofState == 1 or roofState == 2 then
        LOWER_CONVERTIBLE_ROOF(cloneVehicle, true)
    end
    SET_VEHICLE_ENGINE_ON(cloneVehicle, GET_IS_VEHICLE_ENGINE_RUNNING(vehicle), true, true)
end
function Vehicleclone(vehicle)
    local vehicleHeading = GET_ENTITY_HEADING(vehicle)
    local vehicleHash = GET_ENTITY_MODEL(vehicle)
    local coords = GET_ENTITY_COORDS(vehicle)
    SET_ENTITY_AS_MISSION_ENTITY(vehicle)
    local rot = GET_ENTITY_ROTATION(vehicle, 2):toDir()
    v3.mul(rot, -getDimensions(vehicle).x - 2)
    v3.add(coords, rot)
    local cloneVehicle = entities.create_vehicle(vehicleHash, coords, vehicleHeading)
    copyVehicleData(vehicle, cloneVehicle)
    return cloneVehicle
end

return {
    name="Copy Veh",
    help="Copy the selected vehicle",
    applicable_to={"VEHICLE"},
    execute=function(target)
        util.toast("Copy VEH "..target.name)
        local mypos = players.get_position(players.user())
        local clonedvehicle = Vehicleclone(target.handle)
        SET_ENTITY_COORDS(clonedvehicle, mypos.x, mypos.y, mypos.z)
		SET_PED_INTO_VEHICLE(players.user_ped(), clonedvehicle, -1)
    end
}