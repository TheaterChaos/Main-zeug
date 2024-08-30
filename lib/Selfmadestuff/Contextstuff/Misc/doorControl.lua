local items = {}

local doorids = {
	[0]= "Front Left",
	[1]= "Front Right",
	[2]= "Back left",
	[3]= "Back Right",
	[4]= "Engine Hood",
	[5]= "Trunk",
	[6]= "Back",
	[7]= "Back 2",
}

function is_door_valid(handle, doorid)
    if not GET_IS_DOOR_VALID(handle, doorid) or IS_VEHICLE_DOOR_DAMAGED(handle, doorid) then
        return false
    end
    return true
end

local function open_Door_func(target)
    local item = target.selected_option
    if is_door_valid(target.handle, item.doorid) then
        if entities.request_control(target.handle, 100) then
            SET_VEHICLE_DOOR_OPEN(target.handle, item.doorid, false, false)
        else
            util.toast("No Control")
        end
    else
        util.toast("door is not valid")
    end
end
local function close_Door_func(target)
    local item = target.selected_option
    if is_door_valid(target.handle, item.doorid) then
        if entities.request_control(target.handle, 100) then
            SET_VEHICLE_DOOR_SHUT(target.handle, item.doorid, false)
        else
            util.toast("No Control")
        end
    else
        util.toast("door is not valid")
    end
end

local function delete_Door_func(target)
    local item = target.selected_option
    if is_door_valid(target.handle, item.doorid) then
        if entities.request_control(target.handle, 100) then
            SET_VEHICLE_DOOR_BROKEN(target.handle, item.doorid, true)
        else
            util.toast("No Control")
        end
    else
        util.toast("door is not valid")
    end
end

local function destroy_Door_func(target)
    local item = target.selected_option
    if is_door_valid(target.handle, item.doorid) then
        if entities.request_control(target.handle, 100) then
            SET_VEHICLE_DOOR_BROKEN(target.handle, item.doorid, false)
        else
            util.toast("No Control")
        end
    else
        util.toast("door is not valid")
    end
end

local function make_unbreakable_Door_func(target)
    local item = target.selected_option
    if is_door_valid(target.handle, item.doorid) then
        if entities.request_control(target.handle, 100) then
            SET_DOOR_ALLOWED_TO_BE_BROKEN_OFF(target.handle, item.doorid, false)
        else
            util.toast("No Control")
        end
    else
        util.toast("door is not valid")
    end
end

local function make_breakable_Door_func(target)
    local item = target.selected_option
    if is_door_valid(target.handle, item.doorid) then
        if entities.request_control(target.handle, 100) then
            SET_DOOR_ALLOWED_TO_BE_BROKEN_OFF(target.handle, item.doorid, true)
        else
            util.toast("No Control")
        end
    else
        util.toast("door is not valid")
    end
end

function create_execute(doorid, doorname, table)
    if table == nil then table = {} end
    local item = {
        name = "Open Door",
        help = "Opens door: "..doorname,
        applicable_to={"VEHICLE"},
        doorid = doorid,
        doorname = doorname,
        execute = open_Door_func,
    }
    table.insert(table, item)
    local item = {
        name = "Close Door",
        help = "Closes door: "..doorname,
        applicable_to={"VEHICLE"},
        doorid = doorid,
        doorname = doorname,
        execute = close_Door_func,
    }
    table.insert(table, item)
    local item = {
        name = "Destroy Door",
        help = "Destroys door: "..doorname,
        applicable_to={"VEHICLE"},
        doorid = doorid,
        doorname = doorname,
        execute = destroy_Door_func,
    }
    table.insert(table, item)
    local item = {
        name = "Delete Door",
        help = "Deletes door: "..doorname,
        applicable_to={"VEHICLE"},
        doorid = doorid,
        doorname = doorname,
        execute = delete_Door_func,
    }
    table.insert(table, item)
    local item = {
        name = "Make Door unbreakable",
        help = "Makes the door unbreakable: "..doorname,
        applicable_to={"VEHICLE"},
        doorid = doorid,
        doorname = doorname,
        execute = make_unbreakable_Door_func,
    }
    table.insert(table, item)
    local item = {
        name = "Make Door breakable",
        help = "Makes the door unbreakable: "..doorname,
        applicable_to={"VEHICLE"},
        doorid = doorid,
        doorname = doorname,
        execute = make_breakable_Door_func,
    }
    table.insert(table, item)
    return table
end

function create_door_root(doorid, doorname, table, priority)
    if table == nil then table = {} end
        local folder_item = {
            name = doorname,
            help = "Browse actions for "..doorname,
            priority=priority,
            items = create_execute(doorid, doorname),
        }
        table.insert(table, folder_item)
    return table
end


-- Avoid locking up GTA when reading files by running in os thread
local function get_active_doors()
    local priority = 10
    for doorid, doorname in pairs(doorids) do
        create_door_root(doorid, doorname, items, priority)
        priority -= 1
    end
end
get_active_doors()


return {
    name="Doors Control",
    help="Control the doors of the vehicle",
    applicable_to={"VEHICLE"},
    items=items,
}
