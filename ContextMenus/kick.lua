return {
    name="Kick Player",
    help="kicks this Player",
    applicable_to={"PLAYER"},
    execute=function(target)
        menu.trigger_commands("kick"..target.name)
    end
}