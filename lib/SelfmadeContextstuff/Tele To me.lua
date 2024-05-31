return {
    name="Tele to me",
    help="Teleports to you",
    applicable_to={"PED", "VEHICLE", "OBJECT"},
    execute=function(target)
        pPos = players.get_position(players.user())
        if entities.request_control(target.handle) then
            SET_ENTITY_COORDS_NO_OFFSET(target.handle, pPos.x,pPos.y,pPos.z,false,false,false)
            util.toast("Teleportet to you "..target.name)
        end
    end
}