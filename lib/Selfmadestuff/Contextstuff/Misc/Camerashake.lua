return {
    name="camera forward",
    help="toggle camera forward on this player",
    applicable_to={"PLAYER"},
    execute=function(target)
        if menu.get_value(menu.ref_by_command_name("confuse"..target.name)) then
            menu.trigger_commands("confuse"..target.name.. " off")
            util.toast("camera forward OFF")
        else
            menu.trigger_commands("confuse"..target.name.. " on")
            util.toast("camera forward ON")
        end
    end
}