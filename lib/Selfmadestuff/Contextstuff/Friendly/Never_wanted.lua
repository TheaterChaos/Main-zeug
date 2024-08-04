return {
    name="never wanted",
    help="activates never wanted on player",
    applicable_to={"PLAYER"},
    execute=function(target)
        if menu.get_value(menu.ref_by_command_name("bail"..target.name)) then
            menu.trigger_commands("bail"..target.name.. " off")
            util.toast("never wanted OFF")
        else
            menu.trigger_commands("bail"..target.name.. " on")
            util.toast("never wanted ON")
        end
    end
}