return {
    name="VEH kick",
    help="kicks the player of the vehicle",
    applicable_to={"PLAYER"},
    execute=function(target)
        if IS_PED_IN_ANY_VEHICLE(GET_PLAYER_PED_SCRIPT_INDEX(target.player_id), false) then
            menu.trigger_commands("vehkick"..target.name)
            util.toast("veh kick")
        else
            util.toast("no vehicle found")
        end
    end
}