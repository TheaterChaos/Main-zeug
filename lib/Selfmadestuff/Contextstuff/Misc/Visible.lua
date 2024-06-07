return {
    name="Visible",
    help="Set the entity visible / invisible",
    applicable_to={"VEHICLE", "PED", "OBJECT"},
    execute=function(target)
        if IS_ENTITY_VISIBLE(target.handle) then
            SET_ENTITY_VISIBLE(target.handle, false)
            util.toast("ist jetzt unsichtbar")
        else
            SET_ENTITY_VISIBLE(target.handle, true)
            util.toast("ist jetzt sichtbar")
        end
    end
}