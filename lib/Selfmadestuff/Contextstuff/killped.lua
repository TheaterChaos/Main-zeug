return {
    name="Kill",
    help="Kill this ped",
    applicable_to={"PED", "PLAYER"},
    execute=function(target)
        if IS_PED_A_PLAYER(target.handle) then
            menu.trigger_commands("kill"..target.name)
            util.toast("Killed "..target.name)
        else    
            if entities.request_control(target.handle) then
                SET_ENTITY_HEALTH(target.handle, 0, 0, 0)
			    FORCE_PED_MOTION_STATE(target.handle, 0x0DBB071C, 0,0,0)
                util.toast("Killed "..target.name)
            end
        end
    end
}