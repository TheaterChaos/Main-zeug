return {
    name="Kill",
    help="Kill this ped",
    applicable_to={"PED"},
    execute=function(target)
        if entities.request_control(target.handle) then
            SET_ENTITY_HEALTH(target.handle, 0, 0, 0)
			FORCE_PED_MOTION_STATE(target.handle, 0x0DBB071C, 0,0,0)
            util.toast("Killed "..target.name)
        end
    end
}