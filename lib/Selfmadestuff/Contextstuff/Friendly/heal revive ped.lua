return {
    name="Heal/Revive",
    help="Heal/Revive this ped",
    applicable_to={"PED"},
    execute=function(target)
        local ispeddead = IS_PED_DEAD_OR_DYING(target.handle)
        if entities.request_control(target.handle) then
            maxhealth = GET_PED_MAX_HEALTH(target.handle)
			SET_ENTITY_HEALTH(target.handle, maxhealth, 0)
			STOP_ENTITY_FIRE(target.handle)
			if ispeddead then
				CLEAR_PED_TASKS_IMMEDIATELY(target.handle)
			end
            util.toast("Healed / Revived "..target.name)
        end
    end
}