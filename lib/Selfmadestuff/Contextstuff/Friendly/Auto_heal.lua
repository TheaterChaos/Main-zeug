return {
    name="Auto heal",
    help="activates auto heal on player",
    applicable_to={"PLAYER"},
    execute=function(target)
        if menu.get_value(menu.ref_by_command_name("autoheal"..target.name)) then
            menu.trigger_commands("autoheal"..target.name.. " off")
            util.toast("Auto heal OFF")
        else
            menu.trigger_commands("autoheal"..target.name.. " on")
            util.toast("Auto heal ON")
        end
    end
}