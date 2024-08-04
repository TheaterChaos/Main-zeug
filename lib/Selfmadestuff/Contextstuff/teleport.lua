return {
    name="Teleport",
    help="Teleport to location",
    priority=10,
    --applicable_to={"COORDS"},
    execute=function(target)
        if IS_PED_IN_ANY_VEHICLE(players.user_ped()) and GET_PED_IN_VEHICLE_SEAT(GET_VEHICLE_PED_IS_IN(players.user_ped(), true), -1, true) == players.user_ped() then
            SET_ENTITY_COORDS(GET_VEHICLE_PED_IS_IN(players.user_ped()), target.pos.x, target.pos.y, target.pos.z)
        else
            SET_ENTITY_COORDS(players.user_ped(), target.pos.x, target.pos.y, target.pos.z)
        end
    end
}