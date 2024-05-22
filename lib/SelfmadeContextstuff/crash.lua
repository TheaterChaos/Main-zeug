return {
    name="Crash Player",
    help="Crash this Player",
    applicable_to={"PLAYER"},
    execute=function(target)
        menu.trigger_commands("steamroll"..target.name)
        menu.trigger_commands("steamroll"..target.name)
        menu.trigger_commands("slaughter"..target.name)
        menu.trigger_commands("slaughter"..target.name)
        menu.trigger_commands("footlettuce"..target.name)
        menu.trigger_commands("footlettuce"..target.name)
    end
}