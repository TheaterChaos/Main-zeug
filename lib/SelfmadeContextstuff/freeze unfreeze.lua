return {
    name="Freeze/unfreeze Player",
    help="Freeze/unfreeze this Player",
    applicable_to={"PLAYER"},
    execute=function(target)
        if menu.get_value(menu.ref_by_command_name("freeze"..target.name)) then
            menu.trigger_commands("freeze"..target.name.. " off")
            util.toast("Freeze off")
        else
            menu.trigger_commands("freeze"..target.name.. " on")
            util.toast("Freeze on")
        end
    end
}