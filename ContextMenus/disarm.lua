return {
    name="disarm Player",
    help="disarm on/off this Player",
    applicable_to={"PLAYER"},
    execute=function(target)
        if menu.get_value(menu.ref_by_command_name("disarm"..target.name)) then
            menu.trigger_commands("disarm"..target.name.. " off")
            util.toast("disarm off")
        else
            menu.trigger_commands("disarm"..target.name.. " on")
            util.toast("disarm on")
        end
    end
}