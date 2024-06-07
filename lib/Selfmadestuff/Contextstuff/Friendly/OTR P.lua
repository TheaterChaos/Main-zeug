return {
    name="OTR",
    help="activates Out of radar on player",
    applicable_to={"PLAYER"},
    execute=function(target)
        if menu.get_value(menu.ref_by_command_name("giveotr"..target.name)) then
            menu.trigger_commands("giveotr"..target.name.. " off")
            util.toast("OTR OFF")
        else
            menu.trigger_commands("giveotr"..target.name.. " on")
            util.toast("OTR ON")
        end
    end
}