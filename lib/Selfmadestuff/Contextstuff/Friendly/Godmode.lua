return {
    name="Godmode",
    help="Toggle the godmode of the Entity",
    applicable_to={"VEHICLE", "PED"},
    execute=function(target)
        if entities.is_invulnerable(target.handle) then
            SET_ENTITY_INVINCIBLE(target.handle, false)
            util.toast("Godmode OFF")
        else
            SET_ENTITY_INVINCIBLE(target.handle, true)
            util.toast("Godmode ON")
        end
    end,
    on_open=function(target, option)
        if entities.is_invulnerable(target.handle) then
            option.help = "Toggle the godmode of the Entity. GODMODE = ON"
        else
            option.help = "Toggle the godmode of the Entity. GODMODE = OFF"
        end
    end,
}