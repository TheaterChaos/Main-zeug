return {
    name="TP to me",
    help="Teleport player to you",
    applicable_to={"PLAYER"},
    execute=function(target)
        menu.trigger_commands("summon"..target.name)
        util.toast(target.name.." is getting telepoted")
    end
}