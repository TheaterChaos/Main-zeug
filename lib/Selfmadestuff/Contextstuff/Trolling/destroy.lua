return {
    name="Destroy",
    help="Explode the vehicle",
    applicable_to={"VEHICLE"},
    execute=function(target)
        local car = GET_ENTITY_COORDS(target.handle)
        ADD_EXPLOSION(car.x, car.y, car.z, 7, 5000, false, true, 0.0, false)
    end
}