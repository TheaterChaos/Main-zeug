
return {
    name="Mission Entity",
    help="Set it to mission entity or to normal back",
    applicable_to={"VEHICLE", "PED", "OBJECT"},
    execute=function(target)
        if IS_ENTITY_A_MISSION_ENTITY(target.handle) then
            local ent_ptr = memory.alloc_int()
		    memory.write_int(ent_ptr, target.handle)
            if entities.request_control(target.handle, 200) then
			    SET_ENTITY_AS_NO_LONGER_NEEDED(ent_ptr)
                util.toast("Is no longer a mission entity")
            end
        else
            if entities.request_control(target.handle, 200) then
                SET_ENTITY_AS_MISSION_ENTITY(target.handle)
                util.toast("Is now a mission entity")
            end
        end
    end,
    on_open=function(target, option)
        if IS_ENTITY_A_MISSION_ENTITY(target.handle) then
            option.help = "Set it to mission entity or to normal back. Mission Entity = TRUE"
        else
            option.help = "Set it to mission entity or to normal back. Mission Entity = FALSE"
        end
    end,
}