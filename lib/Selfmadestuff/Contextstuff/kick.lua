return {
    name="Kick",
    help="kicks this Player",
    applicable_to={"PLAYER"},
    execute=function(target)
        menu.trigger_commands("kick"..target.name)
    end
}