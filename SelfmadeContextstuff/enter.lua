function getfreevehseat(vehicle)
	if IS_VEHICLE_SEAT_FREE(vehicle, -1, false) then
		if not DOES_ENTITY_EXIST(GET_PED_IN_VEHICLE_SEAT(vehicle, -1, true)) then
			return -1
		end
	end
	local maxPassengers = GET_VEHICLE_MAX_NUMBER_OF_PASSENGERS(vehicle)
	for i = 0, maxPassengers do
		if IS_VEHICLE_SEAT_FREE(vehicle, i, false) then
			if not DOES_ENTITY_EXIST(GET_PED_IN_VEHICLE_SEAT(vehicle, i, true)) then
				return i
			end
		end
	end
	return false
end

return {
    name="Enter",
    help="Attempt to ride in any available seat of the selected vehicle",
    applicable_to={"VEHICLE"},
    execute=function(target)
        seat = getfreevehseat(target.handle)
        if seat then
            SET_PED_INTO_VEHICLE(players.user_ped(), target.handle, seat)
            util.toast("Entering "..target.name)
        else
            util.toast("all seats full")
        end
    end
}