return {
    name="Detach wheels",
    help="Detach all wheels of the vehicle",
    applicable_to={"VEHICLE"},
    execute=function(target)
        if entities.request_control(target.handle, 200) then
            for i=0, 7 do
				SET_VEHICLE_TYRE_BURST(target.handle, i, true, 0)
				entities.detach_wheel(target.handle, i)
			end
        end
    end,
}