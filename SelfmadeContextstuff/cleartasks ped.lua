return {
    name="Clear Tasks",
    help="Clear the tasks are running for this ped",
    applicable_to={"PED"},
    execute=function(target)
        if entities.request_control(target.handle) then
            CLEAR_PED_TASKS_IMMEDIATELY(target.handle)
            util.toast("Clear tasks "..target.name)
        end
    end
}