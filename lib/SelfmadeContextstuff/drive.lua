return {
    name="Drive",
    help="Attempt to drive the selected vehicle",
    applicable_to={"VEHICLE"},
    execute=function(target)
        pedinveh = GET_PED_IN_VEHICLE_SEAT(target.handle, -1, true)
        if pedinveh and DOES_ENTITY_EXIST(pedinveh) and not IS_PED_A_PLAYER(pedinveh) then
            CLEAR_PED_TASKS_IMMEDIATELY(pedinveh)
        end
        SET_PED_INTO_VEHICLE(players.user_ped(), target.handle, -1)
        util.toast("Driving "..target.name)
    end
}