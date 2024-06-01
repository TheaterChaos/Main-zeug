util.require_natives("natives-1681379138", "g-uno")
util.require_natives("2944b", "g")
util.keep_running()
--local response = false


local SCRIPT_VERSION = "0.65"


local auto_update_config = {
    source_url="https://raw.githubusercontent.com/TheaterChaos/Mein-zeug/main/Selfmade.lua",
    script_relpath=SCRIPT_RELPATH,
    project_url="https://github.com/TheaterChaos/Mein-zeug",
    branch="main",
    dependencies={
		"lib/Selfmadestuff/tables.lua",
        "lib/Selfmadestuff/Contextstuff/Tele To me.lua",
        "lib/Selfmadestuff/Contextstuff/boost.lua",
		"lib/Selfmadestuff/Contextstuff/clean.lua",
        "lib/Selfmadestuff/Contextstuff/cleartasks ped.lua",
        "lib/Selfmadestuff/Contextstuff/copyveh.lua",
        "lib/Selfmadestuff/Contextstuff/crash.lua",
        "lib/Selfmadestuff/Contextstuff/delete.lua",
        "lib/Selfmadestuff/Contextstuff/destroy.lua",
        "lib/Selfmadestuff/Contextstuff/disarm.lua",
        "lib/Selfmadestuff/Contextstuff/drive.lua",
        "lib/Selfmadestuff/Contextstuff/enter.lua",
        "lib/Selfmadestuff/Contextstuff/freeze unfreeze.lua",
        "lib/Selfmadestuff/Contextstuff/heal revive ped.lua",
		"lib/Selfmadestuff/Contextstuff/kick.lua",
		"lib/Selfmadestuff/Contextstuff/killped.lua",
		"lib/Selfmadestuff/Contextstuff/player_menu.lua",
		"lib/Selfmadestuff/Contextstuff/repair.lua",
		"lib/Selfmadestuff/Contextstuff/spawn.lua",
		"lib/Selfmadestuff/Contextstuff/teleport.lua",
    },
}

util.ensure_package_is_installed('lua/auto-updater')
local auto_updater = require('auto-updater')
if auto_updater == true then
    auto_updater.run_auto_update(auto_update_config)
end

local tables = require("Selfmadestuff/tables")


--require ('resources/Alltabels')

--local resource_dir = filesystem.resources_dir()
--if not filesystem.exists(resource_dir) then
--	util.toast("resource directory not found. notification system will be less of a bruh")
--else
--	util.register_file(resource_dir .. "bruhzowski.ytd")
--end

-- Functions and infos

local a = 1
local bba = 10
local abb = 10
local playertable = {}


selectedplayer = {}
for b = 0, 31 do
    selectedplayer[b] = false
end
excludeselected = false

cmd_id = {}
for i = 0, 31 do
	cmd_id[i] = 0
end

playerid = {}
for i = 0, 32 do
	table.insert(playerid, i)
end

listkicken = {}

listfriendly = {}

listtp = {}

listtrolling = {}

listgenerel = {}

veh = {}

antivehactiontablelist = {}

vehinfotab = {}
for i = 0, 300 do
	vehinfotab[i] = 0
end


vehenterstealnpc = false
vehentersteal = false

local minimumbox = memory.alloc()
local maximumbox = memory.alloc()
local upVector_pointer = memory.alloc()
local rightVector_pointer = memory.alloc()
local forwardVector_pointer = memory.alloc()
local position_pointer = memory.alloc()

-- From GridSpawn
draw_bounding_box = function(entity, colour)
    if colour == nil then
        colour = {r=255,g=0,b=0,a=255}
    end

    GET_MODEL_DIMENSIONS(GET_ENTITY_MODEL(entity), minimumbox, maximumbox)
    local minimum_vec = v3.new(minimumbox)
    local maximum_vec = v3.new(maximumbox)
    draw_bounding_box_with_dimensions(entity, colour, minimum_vec, maximum_vec)
end

draw_bounding_box_with_dimensions = function(entity, colour, minimum_vec, maximum_vec)

    local dimensions = {x = maximum_vec.y - minimum_vec.y, y = maximum_vec.x - minimum_vec.x, z = maximum_vec.z - minimum_vec.z}

    GET_ENTITY_MATRIX(entity, rightVector_pointer, forwardVector_pointer, upVector_pointer, position_pointer);
    local forward_vector = v3.new(forwardVector_pointer)
    local right_vector = v3.new(rightVector_pointer)
    local up_vector = v3.new(upVector_pointer)

    local top_right =           GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(entity,       maximum_vec.x, maximum_vec.y, maximum_vec.z)
    local top_right_back =      {x = forward_vector.x * -dimensions.y + top_right.x,        y = forward_vector.y * -dimensions.y + top_right.y,         z = forward_vector.z * -dimensions.y + top_right.z}
    local bottom_right_back =   {x = up_vector.x * -dimensions.z + top_right_back.x,        y = up_vector.y * -dimensions.z + top_right_back.y,         z = up_vector.z * -dimensions.z + top_right_back.z}
    local bottom_left_back =    {x = -right_vector.x * dimensions.x + bottom_right_back.x,  y = -right_vector.y * dimensions.x + bottom_right_back.y,   z = -right_vector.z * dimensions.x + bottom_right_back.z}
    local top_left =            {x = -right_vector.x * dimensions.x + top_right.x,          y = -right_vector.y * dimensions.x + top_right.y,           z = -right_vector.z * dimensions.x + top_right.z}
    local bottom_right =        {x = -up_vector.x * dimensions.z + top_right.x,             y = -up_vector.y * dimensions.z + top_right.y,              z = -up_vector.z * dimensions.z + top_right.z}
    local bottom_left =         {x = forward_vector.x * dimensions.y + bottom_left_back.x,  y = forward_vector.y * dimensions.y + bottom_left_back.y,   z = forward_vector.z * dimensions.y + bottom_left_back.z}
    local top_left_back =       {x = up_vector.x * dimensions.z + bottom_left_back.x,       y = up_vector.y * dimensions.z + bottom_left_back.y,        z = up_vector.z * dimensions.z + bottom_left_back.z}

    DRAW_LINE(
            top_right.x, top_right.y, top_right.z,
            top_right_back.x, top_right_back.y, top_right_back.z,
            colour.r, colour.g, colour.b, colour.a
    )
    DRAW_LINE(
            top_right.x, top_right.y, top_right.z,
            top_left.x, top_left.y, top_left.z,
            colour.r, colour.g, colour.b, colour.a
    )
    DRAW_LINE(
            top_right.x, top_right.y, top_right.z,
            bottom_right.x, bottom_right.y, bottom_right.z,
            colour.r, colour.g, colour.b, colour.a
    )
    DRAW_LINE(
            bottom_left_back.x, bottom_left_back.y, bottom_left_back.z,
            bottom_right_back.x, bottom_right_back.y, bottom_right_back.z,
            colour.r, colour.g, colour.b, colour.a
    )
    DRAW_LINE(
            bottom_left_back.x, bottom_left_back.y, bottom_left_back.z,
            bottom_left.x, bottom_left.y, bottom_left.z,
            colour.r, colour.g, colour.b, colour.a
    )
    DRAW_LINE(
            bottom_left_back.x, bottom_left_back.y, bottom_left_back.z,
            top_left_back.x, top_left_back.y, top_left_back.z,
            colour.r, colour.g, colour.b, colour.a
    )
    DRAW_LINE(
            top_left_back.x, top_left_back.y, top_left_back.z,
            top_right_back.x, top_right_back.y, top_right_back.z,
            colour.r, colour.g, colour.b, colour.a
    )
    DRAW_LINE(
            top_left_back.x, top_left_back.y, top_left_back.z,
            top_left.x, top_left.y, top_left.z,
            colour.r, colour.g, colour.b, colour.a
    )
    DRAW_LINE(
            bottom_right_back.x, bottom_right_back.y, bottom_right_back.z,
            top_right_back.x, top_right_back.y, top_right_back.z,
            colour.r, colour.g, colour.b, colour.a
    )
    DRAW_LINE(
            bottom_left.x, bottom_left.y, bottom_left.z,
            top_left.x, top_left.y, top_left.z,
            colour.r, colour.g, colour.b, colour.a
    )
    DRAW_LINE(
            bottom_left.x, bottom_left.y, bottom_left.z,
            bottom_right.x, bottom_right.y, bottom_right.z,
            colour.r, colour.g, colour.b, colour.a
    )
    DRAW_LINE(
            bottom_right_back.x, bottom_right_back.y, bottom_right_back.z,
            bottom_right.x, bottom_right.y, bottom_right.z,
            colour.r, colour.g, colour.b, colour.a
    )
end

local menus = {}


function getVehicle(ped)
	return IS_PED_SITTING_IN_ANY_VEHICLE(ped) and GET_VEHICLE_PED_IS_IN(ped, false)
end

function IS_PLAYER_PED(ped)
	if GET_PED_TYPE(ped) < 4 then
		return true
	else
		return false
	end
end

function getTargetVehicleData(entity)
	local vehicle = GET_VEHICLE_INDEX_FROM_ENTITY_INDEX(entity)
	local driver = GET_PED_IN_VEHICLE_SEAT(vehicle, -1, true)
	local driverlast = GET_LAST_PED_IN_VEHICLE_SEAT(vehicle, -1)
	local player = NETWORK_GET_PLAYER_INDEX_FROM_PED(driver)
	if player == -1 then
		player = NETWORK_GET_PLAYER_INDEX_FROM_PED(driverlast)
	end
	local result = {}
	result.vehicle = vehicle
	result.driver = driver
	result.player = player
	return result
end

function setVehiclePlate(vehicle, text)
	if text and text:len() > 0 then
		SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle, text)
	end
end

function isentitiyaenemie(entity)
	if IS_ENTITY_A_PED(entity) then
		if IS_PED_IN_COMBAT(entity, players.user_ped()) then
			return true
		end
	end
	if not IS_ENTITY_A_PED(entity) then
		local colbliip2 = GET_BLIP_COLOUR(GET_BLIP_FROM_ENTITY(entity))
		if colbliip2 == 1 or colbliip2 == 49 or colbliip2 == 59 or colbliip2 == 75 then
			return true
		end
	end
	if IS_ENTITY_A_PED(entity) then
		if not IS_PED_IN_ANY_VEHICLE(entity) then
			local colbliip = GET_BLIP_COLOUR(GET_BLIP_FROM_ENTITY(entity))
			if colbliip == 1 or colbliip == 49 or colbliip == 59 or colbliip == 75 then
				return true
			end
		else
			local colbliip = GET_BLIP_COLOUR(GET_BLIP_FROM_ENTITY(entity))
			local colbliip2 = GET_BLIP_COLOUR(GET_BLIP_FROM_ENTITY(GET_VEHICLE_PED_IS_IN(entity)))
			if (colbliip == 1 or colbliip == 49 or colbliip == 59 or colbliip == 75) or (colbliip2 == 1 or colbliip2 == 49 or colbliip2 == 59 or colbliip2 == 75) then
				return true
			end
		end
	end
	return false
end

function savevehicleingarage(vehhandle, input)
	vehname = getmodelnamebyhash(entities.get_model_hash(vehhandle))
	freeseat = getfreevehseat(vehhandle)
	if GET_VEHICLE_PED_IS_IN(players.user_ped()) == vehhandle then
		menu.trigger_commands("savevehicle "..input)
		util.toast("VEH: ".. vehname.. " Saved as ".. input)
		goto end
	end
	if freeseat then
		if IS_PED_IN_ANY_VEHICLE(players.user_ped()) then
			local vehicleofped = GET_VEHICLE_PED_IS_IN(players.user_ped())
			local seatofplayer = getseatofplayer(vehicleofped)
			SET_PED_INTO_VEHICLE(players.user_ped(), vehhandle, freeseat)
			util.yield(20)
			menu.trigger_commands("savevehicle "..input)
			util.toast("VEH: ".. vehname.. " Saved as ".. input)
			util.yield(20)
			if DOES_ENTITY_EXIST(vehicleofped) then
				if IS_VEHICLE_SEAT_FREE(vehicleofped, seatofplayer, false) then
					SET_PED_INTO_VEHICLE(players.user_ped(), vehicleofped, seatofplayer)
				else
					getfreesetincar = getfreevehseat(vehicleofped)
					if getfreesetincar ~= number then
						SET_PED_INTO_VEHICLE(players.user_ped(), vehicleofped, getfreesetincar)
					else
						SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), mypos, false, false, false)
					end
				end
			end
		else
			SET_PED_INTO_VEHICLE(players.user_ped(), vehhandle, freeseat)
			util.yield(20)
			menu.trigger_commands("savevehicle "..input)
			util.toast("VEH: ".. vehname.. " Saved as ".. input)
			util.yield(10)
			SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), mypos, false, false, false)
		end
	else
		util.toast("Es gibt kein sitzplatz für dich")
		return false
	end
	::end::
	return true
end

function getcurrentweaponofped(ped)
	local currentWpMem = memory.alloc()
	local junk = GET_CURRENT_PED_WEAPON(ped, currentWpMem, 1)
	local holdingnweapon = memory.read_int(currentWpMem)
	if holdingnweapon ~= number then
		return holdingnweapon
	end
end

local minimumdim = memory.alloc()
local maximumdim = memory.alloc()
function getDimensions(entity)
	GET_MODEL_DIMENSIONS(GET_ENTITY_MODEL(entity), minimumdim, maximumdim)
	local minimum_vec = v3.new(minimumdim)
	local maximum_vec = v3.new(maximumdim)
	local dimensions = {
		x = maximum_vec.y - minimum_vec.y,
		y = maximum_vec.x - minimum_vec.x,
		z = maximum_vec.z - minimum_vec.z
	}
	return dimensions
end

local colorR, colorG, colorB = memory.alloc(1), memory.alloc(1), memory.alloc(1)
function copyVehicleData(vehicle, cloneVehicle)
	SET_VEHICLE_MOD_KIT(cloneVehicle, 0)
	for i = 17, 22 do
		TOGGLE_VEHICLE_MOD(cloneVehicle, i, IS_TOGGLE_MOD_ON(vehicle, i))
	end
	for i = 0, 49 do
		local modValue = GET_VEHICLE_MOD(vehicle, i)
		SET_VEHICLE_MOD(cloneVehicle, i, modValue)
	end
	if GET_IS_VEHICLE_PRIMARY_COLOUR_CUSTOM(vehicle) then
		GET_VEHICLE_CUSTOM_PRIMARY_COLOUR(vehicle, colorR, colorG, colorB)
		SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(cloneVehicle, memory.read_ubyte(colorR), memory.read_ubyte(colorG), memory.read_ubyte(colorB))
	else
		GET_VEHICLE_MOD_COLOR_1(vehicle, colorR, colorG, colorB)
		SET_VEHICLE_MOD_COLOR_1(cloneVehicle, memory.read_ubyte(colorR), memory.read_ubyte(colorG), memory.read_ubyte(colorB))
	end
	if GET_IS_VEHICLE_SECONDARY_COLOUR_CUSTOM(vehicle) then
		GET_VEHICLE_CUSTOM_SECONDARY_COLOUR(vehicle, colorR, colorG, colorB)
		SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(cloneVehicle, memory.read_ubyte(colorR), memory.read_ubyte(colorG), memory.read_ubyte(colorB))
	else
		GET_VEHICLE_MOD_COLOR_2(vehicle, colorR, colorG)
		SET_VEHICLE_MOD_COLOR_2(cloneVehicle, memory.read_ubyte(colorR), memory.read_ubyte(colorG))
	end
	GET_VEHICLE_COLOURS(vehicle, colorR, colorG)
	SET_VEHICLE_COLOURS(cloneVehicle, memory.read_ubyte(colorR), memory.read_ubyte(colorG))
	GET_VEHICLE_EXTRA_COLOURS(vehicle, colorR, colorG)
	SET_VEHICLE_EXTRA_COLOURS(cloneVehicle, memory.read_ubyte(colorR), memory.read_ubyte(colorG))
	GET_VEHICLE_EXTRA_COLOUR_5(vehicle, colorR)
	GET_VEHICLE_EXTRA_COLOUR_6(vehicle, colorG)
	SET_VEHICLE_EXTRA_COLOUR_5(cloneVehicle, memory.read_ubyte(colorR))
	SET_VEHICLE_EXTRA_COLOUR_6(cloneVehicle, memory.read_ubyte(colorG))
	GET_VEHICLE_TYRE_SMOKE_COLOR(vehicle, colorR, colorG, colorB)
	SET_VEHICLE_TYRE_SMOKE_COLOR(cloneVehicle, memory.read_ubyte(colorR), memory.read_ubyte(colorG), memory.read_ubyte(colorB))
	GET_VEHICLE_NEON_COLOUR(vehicle, colorR, colorG, colorB)
	SET_VEHICLE_NEON_COLOUR(cloneVehicle, memory.read_ubyte(colorR), memory.read_ubyte(colorG), memory.read_ubyte(colorB))
	for i = 0, 3 do
		SET_VEHICLE_NEON_ENABLED(cloneVehicle, i, GET_VEHICLE_NEON_ENABLED(vehicle, i))
	end
	local windowTint = GET_VEHICLE_WINDOW_TINT(vehicle)
	SET_VEHICLE_WINDOW_TINT(cloneVehicle, windowTint)
	local lightsColor = GET_VEHICLE_XENON_LIGHT_COLOR_INDEX(vehicle)
	SET_VEHICLE_XENON_LIGHT_COLOR_INDEX(cloneVehicle, lightsColor)
	SET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(cloneVehicle, GET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(vehicle))
	setVehiclePlate(cloneVehicle, GET_VEHICLE_NUMBER_PLATE_TEXT(vehicle))
	SET_VEHICLE_TYRES_CAN_BURST(cloneVehicle, GET_VEHICLE_TYRES_CAN_BURST(vehicle))
	SET_VEHICLE_DIRT_LEVEL(cloneVehicle, GET_VEHICLE_DIRT_LEVEL(vehicle))
	for i = 1, 14 do
		SET_VEHICLE_EXTRA(cloneVehicle, i, not IS_VEHICLE_EXTRA_TURNED_ON(vehicle, i))
	end
	local roofState = GET_CONVERTIBLE_ROOF_STATE(vehicle)
	if roofState == 1 or roofState == 2 then
		LOWER_CONVERTIBLE_ROOF(cloneVehicle, true)
	end
	SET_VEHICLE_ENGINE_ON(cloneVehicle, GET_IS_VEHICLE_ENGINE_RUNNING(vehicle), true, true)
end
function clonevehicle(vehicle)
	local vehicleHeading = GET_ENTITY_HEADING(vehicle)
	local vehicleHash = GET_ENTITY_MODEL(vehicle)
	local coords = GET_ENTITY_COORDS(vehicle)
	SET_ENTITY_AS_MISSION_ENTITY(vehicle)
	local rot = GET_ENTITY_ROTATION(vehicle, 2):toDir()
	v3.mul(rot, -getDimensions(vehicle).x - 2)
	v3.add(coords, rot)
	local cloneVehicle = entities.create_vehicle(vehicleHash, coords, vehicleHeading)
	copyVehicleData(vehicle, cloneVehicle)
	return cloneVehicle
end

function reclaimVehicles()
	for k, v in menu.get_children(menu.ref_by_path("Vehicle>Personal Vehicles")) do
			for k1, v1 in v.command_names do
				if (v1 ~= "findpv")
				then
					menu.trigger_commands(v1.."request")
				end
			end
		end
	end

function Streamptfx(lib)
    REQUEST_NAMED_PTFX_ASSET(lib)
    while not HAS_NAMED_PTFX_ASSET_LOADED(lib) do
        util.yield()
    end
    USE_PARTICLE_FX_ASSET(lib)
end

--[[local function is_user_a_stand_user(pid)
    if players.exists(pid) and pid != players.user() then
        for menu.player_root(pid):getChildren() as cmd do
            if cmd:getType() == COMMAND_LIST_CUSTOM_SPECIAL_MEANING and (cmd:refByRelPath("Stand Nutzer"):isValid() or cmd:refByRelPath("Stand User (Co-Loading)"):isValid() or cmd:refByRelPath("Stand user"):isValid() or cmd:refByRelPath("Stand Nutzer (Mit Co-Load)"):isValid()) then
				return true
            end
        end
    end
    return false
end]]


function levideaktivate()
	if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
		menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
	end
end

function PlayerisFriend(player)
	for _, pid in players.list(false, true, false) do
		if player == pid then
			return true
		end
	end
	return false
end

function loadsphereninrangered(range, pos)
	if pos == nil or (not pos) then
		pos = players.get_position(players.user())
	end
	DRAW_MARKER_SPHERE(pos.x, pos.y, pos.z, range, 255, 0, 0, 0.3)
end

function getcontrole(entity)
	local time = os.time()
		repeat
		--time += 1
		--util.draw_debug_text("GETTING CONTROLE")
		NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
			if os.time() - time >= 2 then
				time = 0
				return false
			end
		util.yield()
		until NETWORK_HAS_CONTROL_OF_ENTITY(entity)
	return true
end

function getfreevehseat(vehicle)
	if IS_VEHICLE_SEAT_FREE(vehicle, -1, false) then
		if not DOES_ENTITY_EXIST(GET_PED_IN_VEHICLE_SEAT(vehicle, -1, true)) then
			return -1
		end
	end
	local maxPassengers = GET_VEHICLE_MAX_NUMBER_OF_PASSENGERS(vehicle)
	for i = 0, maxPassengers do
		if IS_VEHICLE_SEAT_FREE(vehicle, i, false) then
			if not DOES_ENTITY_EXIST(GET_PED_IN_VEHICLE_SEAT(vehicle, i, true)) then
				return i
			end
		end
	end
	return false
end

function getpedsinvehicle(vehicle)
	local pedstable = {}
	if not IS_VEHICLE_SEAT_FREE(vehicle, -1, false) then
		table.insert(pedstable, GET_PED_IN_VEHICLE_SEAT(vehicle, -1, true))
	end
	local maxPassengers = GET_VEHICLE_MAX_NUMBER_OF_PASSENGERS(vehicle)
	for i = 0, maxPassengers do
		if not IS_VEHICLE_SEAT_FREE(vehicle, i, false) then
			local pedinveh = GET_PED_IN_VEHICLE_SEAT(vehicle, i, true)
			table.insert(pedstable, pedinveh)
		end
	end
	if pedstable == {} then
		return 0
	else
		return pedstable
	end
end

function send_script_event(first_arg, receiver, args)
	table.insert(args, 1, first_arg)
	util.trigger_script_event(1 << receiver, args)
end

function roundDecimals(float, decimals)
	decimals = 10 ^ decimals
	return math.floor(float * decimals) / decimals
end

local justPressed = {}
local lastPressMS = {}

local loadthigson = true

function getKeyCode(string_or_int)
    local lookup = tables.keyLookupTable[string_or_int]
    return (lookup and lookup or string_or_int)
end

function is_key_down(string_or_int)
    local keyCode = getKeyCode(string_or_int)
    return util.is_key_down(keyCode)
end

function is_key_just_down(string_or_int)
    local keyCode = getKeyCode(string_or_int)
    local isDown = util.is_key_down(keyCode)

    if isDown and not justPressed[keyCode] then
        justPressed[keyCode] = true
        return true
    elseif not isDown then
        justPressed[keyCode] = false
    end
    return false
end

function get_ground_z(coords)
    local start_time = os.time()
    while true do
        local success, est = util.get_ground_z(coords['x'], coords['y'], coords['z'])
        if success then
            return est
        end
        util.yield()
    end
end

function getpidtoattach(pid)
	for i = 32,0,-1 do
		if i < pid then
			if players.exists(i) then
				return i
			end
		end
	end
	return -1
end

function createparents_in_custom(pid, textline)
	local Pname = players.get_name(pid)
	listgenerel[pid] = menu.action(actionlistcustomselection, Pname, {}, textline, function()
		local pid = pid
		deleteparents_in_custom(pid)
		menu.set_value(playertable[pid], false)
	end)
	listtp[pid] = menu.action(actionlistcustomselectionteleport, Pname, {}, textline, function()
		local pid = pid
		deleteparents_in_custom(pid)
		menu.set_value(playertable[pid], false)
	end)
	listfriendly[pid] = menu.action(actionlistcustomselectionfriendly, Pname, {}, textline, function()
		local pid = pid
		deleteparents_in_custom(pid)
		menu.set_value(playertable[pid], false)
	end)
	listtrolling[pid] = menu.action(actionlistcustomselectiontrolling, Pname, {}, textline, function()
		local pid = pid
		deleteparents_in_custom(pid)
		menu.set_value(playertable[pid], false)
	end)
	listkicken[pid] = menu.action(actionlistcustomselectionkickcrash, Pname, {}, textline, function()
		local pid = pid
		deleteparents_in_custom(pid)
		menu.set_value(playertable[pid], false)
	end)
end

function deleteparents_in_custom(pid)
	if listgenerel[pid] != nil then
		if menu.is_ref_valid(listgenerel[pid]) then
			menu.delete(listgenerel[pid])
		end
	end
	if listtp[pid] != nil then
		if menu.is_ref_valid(listtp[pid]) then
			menu.delete(listtp[pid])
		end
	end
	if listfriendly[pid] != nil then
		if menu.is_ref_valid(listfriendly[pid]) then
			menu.delete(listfriendly[pid])
		end
	end
	if listtrolling[pid] != nil then
		if menu.is_ref_valid(listtrolling[pid]) then
			menu.delete(listtrolling[pid])
		end
	end
	if listkicken[pid] != nil then
		if menu.is_ref_valid(listkicken[pid]) then
			menu.delete(listkicken[pid])
		end
	end
end

function get_ms_since_last_press(string_or_int)
    local keyCode = getKeyCode(string_or_int)
    local isDown = util.is_key_down(keyCode)
    if lastPressMS[keyCode] == nil then
        if isDown then
            lastPressMS[keyCode] = util.current_time_millis()
        end
        return -1
    end
    local prevPress = lastPressMS[keyCode]
    if isDown then
        lastPressMS[keyCode] = util.current_time_millis()
        return prevPress != nil and util.current_time_millis() - prevPress or -1
    end
    return util.current_time_millis() - lastPressMS[keyCode]
end

function isanykeypressed()
	for tables.keyLookupTable as key do
		local keydown = is_key_down(key)
		if keydown then
			return true
		end
	end
	return false
end

function upgrade_vehicle(vehicle)
	if getcontrole then
		SET_VEHICLE_MOD_KIT(vehicle, 0)
    	for i = 0, 49 do
       		local num = entities.get_upgrade_max_value(vehicle, i)
       		entities.set_upgrade_value(vehicle, i, num)
   		end
	end
end

function randomupgrade_vehicle(vehicle)
	if getcontrole then
		SET_VEHICLE_MOD_KIT(vehicle, 0)
    	for i = 0, 49 do
       		local num = entities.get_upgrade_max_value(vehicle, i)
			if num < 0 then
				num = -1
			end
				numupgrade = math.random( -1, num )
       			entities.set_upgrade_value(vehicle, i, numupgrade)
   		end
	end
end

function downggrade_vehicle(vehicle)
	if getcontrole then
    	for i = 0, 49 do
       		--local num = entities.get_upgrade_max_value(vehicle, i)
			   REMOVE_VEHICLE_MOD(vehicle, i)
       		--entities.set_upgrade_value(vehicle, i, num)
   		end
	end
end

function isMoving(ped)
	if not IS_PED_IN_ANY_VEHICLE(ped, true) and GET_ENTITY_SPEED(ped) > 5 then return true end
	if GET_ENTITY_SPEED(GET_VEHICLE_PED_IS_IN(ped, false)) > 5 then return true end
end

function getseatofplayer(vehicle)
	if not IS_VEHICLE_SEAT_FREE(vehicle, -1, false) then
		if GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false) == players.user_ped() then
			return -1
		end
	end
	local maxPassengers = GET_VEHICLE_MAX_NUMBER_OF_PASSENGERS(vehicle)
	for i = -1, maxPassengers do
		if not IS_VEHICLE_SEAT_FREE(vehicle, i, false) then
			if GET_PED_IN_VEHICLE_SEAT(vehicle, i, false) == players.user_ped() then
				return i
			end
		end
	end
	return -2
end

function get_ip_data(ip)
    local data = {city = "unknown", state = "unknown", country = "unknown"}
    if util.is_soup_netintel_inited() then
        if (loc := soup.netIntel.getLocationByIp(ip)):isValid() then
            data.city = loc.city
            data.state = loc.state
            data.country = soup.getCountryName(loc.country_code, "EN")
        end
    end
    return data
end


timer1 = 0

function getClosestVehicle(myPos)
	local closestDist = 999999999999
	local closestVeh = nil
	for _, veh in pairs(entities.get_all_vehicles_as_pointers()) do--use pointers because handles take more time
	      local vehpos = entities.get_position(veh) --takes pointer
	      local dist = myPos:distance(vehpos)
	      if (dist < closestDist) then
	    	closestDist = dist
	    	closestVeh = veh
	      end
    end
    if closestVeh ~= nil then
        return entities.pointer_to_handle(closestVeh)
    end
end

function pidlanguage(pid)
	local IP = tostring(soup.IpAddr(players.get_connect_ip(pid)))
	local ip_data = get_ip_data(tostring(IP))
	languages = ip_data.country
	return languages
end

function playerjoinmassge(pid)
	if player_join then
		playername = players.get_name(pid)
		rockstarid = players.get_rockstar_id(pid)
		connectetip = players.get_connect_port(pid)
		ranklevel = players.get_rank(pid)
		money = players.get_money(pid)
		languagesname = pidlanguage(pid)
		local textline = ""
		if languagesname == nil then
			goto end
		end
		textline = textline.. "Spieler Gejoint\n"
		textline = textline.. playername.."   {"..rockstarid.."} / Land: "..languagesname
		if ranklevel != 0 then
			textline = textline.."\nLevel: "..ranklevel.."   "
		end
		if money != 0 then
			textline = textline.. "Geld: "..comma_value(money)
		end
		if util.is_session_started() then
			util.toast(textline, TOAST_ALL)
		else
			util.toast(textline, TOAST_CONSOLE)
		end
		::end::
	end
end

function getvehtype(hashveh)
	if IS_THIS_MODEL_A_BOAT(hashveh) then
		return "BOAT"
	elseif IS_THIS_MODEL_A_PLANE(hashveh) then
		return "PLANE"
	elseif IS_THIS_MODEL_A_HELI(hashveh) then
		return "HELI"
	elseif IS_THIS_MODEL_A_CAR(hashveh) then
		return "CAR"
	elseif IS_THIS_MODEL_A_TRAIN(hashveh) then
		return "TRAIN"
	elseif IS_THIS_MODEL_A_BIKE(hashveh) then
		return "BIKE"
	elseif IS_THIS_MODEL_A_BICYCLE(hashveh) then
		return "BICYCLE"
	elseif IS_THIS_MODEL_A_QUADBIKE(hashveh) then
		return "QUADBIKE"
	elseif util.is_this_model_a_trailer(hashveh) then
		return "TRAILER"
	else
		return "NOT FOUND"
	end
end

function getorganisationplayers(pid)
	local orgmembers = {}
	local bossofpid = players.get_boss(pid)
	if bossofpid == -1 then
		return false
	end
		for players.list(false, true, true) as pid1 do
			local bossofpid1 = players.get_boss(pid1)
			if bossofpid1 != -1 then
				if bossofpid == bossofpid1 then
					table.insert(orgmembers,pid1)
				end
			end
		end
		return orgmembers
end

function getorgtype(pid)
	local orgtype = players.get_org_type(pid)
	if orgtype == -1 then
		return "NONE"
	elseif orgtype == 0 then
		return "CEO"
	elseif orgtype == 1 then
		return "Bike Club"
	end
end

function tableremove(table, removel)
	for a, msg in ipairs(table) do
		if msg == removel then
			table.remove(table, a)
		end
	end
end

function getHealth(ped)
	local hp = GET_ENTITY_HEALTH(ped)
	local maxHp = GET_PED_MAX_HEALTH(ped)
	local armor = GET_PED_ARMOUR(ped)
	local total = hp
	if maxHp == 0 then
		total = 0
	elseif armor > 0 then
		total = math.floor((total + armor) / (maxHp + 50) * 100)
	else
		total = math.floor(total / maxHp * 100)
	end
	return {
		health = hp,
		armor = armor,
		maxHealth = maxHp,
		total = total .. "%"
	}
end

function getKD(pid)
    pid = pid or players.user()
    return math.floor(players.get_kd(pid) * 100) / 100	
end

function getMoney(pid, shorten)
	pid = pid or players.user()
	local money = players.get_money(pid)
	if not shorten then
		return money
	end
	local length = string.len(tostring(money))
	if length < 4 then
		return money
	elseif length < 7 then
		return string.format("%.2fK", money / 1000)
	elseif length < 10 then
		return string.format("%.2fM", money / 1000000)
	end
	return string.format("%.2fB", money / 1000000000)
end


local weapons = util.get_weapons()
local weaponHash = memory.alloc_int()
function getWeapon(ped)
	GET_CURRENT_PED_WEAPON(ped, weaponHash, true)
	local readWeaponHash = memory.read_int(weaponHash)
	local weaponName
	for _, wep in weapons do
		if wep.hash == readWeaponHash then
			weaponName = util.get_label_text(wep.label_key)
			break
		end
	end
	return weaponName
end

function getSpeed(entity, onlyValue)
	local speed = GET_ENTITY_SPEED(entity)
	local localSpeed
	localSpeed = math.floor(speed * 3.6)
	if onlyValue then
		return localSpeed
	end
	return localSpeed .. " " .. "kmh"
end

function getPlayerPosition(pid)
    pid = pid or players.user()
    return players.get_position(pid)
end

function getmodelnamebyhash(hash)
	if util.get_label_text(hash) ~= "NULL" then
		return util.get_label_text(hash)
	end
	return util.reverse_joaat(hash)
end

function getLanguage(pid)
	pid = pid or Player.getUserPlayer()
	return tables.LANGUAGES[players.get_language(pid)]
end


function getInterior(pid)
	pid = pid or players.user()
	local pos = players.get_position(pid)
	local interior = GET_INTERIOR_FROM_COLLISION(pos.x, pos.y, pos.z)
	if interior > 0 then
		for name, val in tables.INTERIOR_IDS do
			if val == interior then
				local hasNumber = string.find(name, "%d")
				if hasNumber then
					return name:gsub('%d', '')
				end
				return name
			end
		end
	end	    local function checkCoordsFor(name)
		if name == "kosatka" and checkCoordsFor("kosatkaMissile") then
			return "kosatkaMissile"
		end
		local coords = tables.INTERIOR_COORDS[name]
		if pos.x >= coords[1] and pos.x <= coords[2] and pos.y >= coords[3] and pos.y <= coords[4] then
			if not coords[5] or (pos.z >= coords[5] and pos.z <= coords[6]) then
				local hasNumber = string.find(name, "%d")
				if hasNumber then
					return name:gsub('%d', '')
				end
				return name
			end
		end
	end
	for name in tables.INTERIOR_COORDS do
		local interiorName = checkCoordsFor(name)
		if interiorName then
			return interiorName
		end
	end
	if players.is_in_interior(pid) then
		return "interior"
	end
	return nil
end

local options <const> = {"zu Meinem", "zu Seinem"}


-- player options

local function player(pid)
    menu.divider(menu.player_root(pid), "Selfmade")
	main = menu.list(menu.player_root(pid), "Selfmade", {"PlMein"}, "")
    bozo = menu.list(main, "Notizen", {"Notizen"}, "")
	anderes = menu.list(main, "anderes zeug", {"anderes"}, "")
	orgthings = menu.list(main, "org zeug", {"orgthings"}, "wenn du im org bist wird nichts davon auf dich gemacht")
	orgthingsteleport = menu.list(orgthings, "Teleportieren", {"orgtele"}, "")
	orgthingsfriendly = menu.list(orgthings, "Freundlich", {"orgfriendlys"}, "")
	orgthingsfriendlyvehicle = menu.list(orgthingsfriendly, "Vehicle", {"orgfriendlysvehicle"}, "")
	orgthingsweapons = menu.list(orgthings, "Waffen", {"orgweapons"}, "")
	orgthingstrolling = menu.list(orgthings, "Trolling", {"orgtrolling"}, "")
	orgthingstrollingvehicle = menu.list(orgthingstrolling, "Vehicle", {"orgtrollingvehicle"}, "")
	orgthingscrash = menu.list(orgthings, "Crash", {"orgcrash"}, "")

	-- org teleport menu
	menu.action(orgthingsteleport, "Zu Mir Teleportieren", {}, "", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				menu.trigger_commands("summon".. playername)
				util.toast("org wird zu dir teleportiert")
			end
		end
 	end)
	menu.action(orgthingsteleport, "Zu Meinem Wegpunkt Teleportieren", {}, "", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				menu.trigger_commands("wpsummon".. playername)
				util.toast("org wird zum wegpunkt teleportiert")
			end
		end
 	end)
	menu.action(orgthingsteleport, "Zu Meinem Missionsziel Teleportieren", {}, "", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				menu.trigger_commands("summonobj".. playername)
				util.toast("org wird zum Missionziehl teleportiert")
			end
		end
 	end)

	--org Freundlich menu vehicle
	menu.action(orgthingsfriendlyvehicle, "Komplett Verbessern", {}, "", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				menu.trigger_commands("upgradeveh".. playername)
				util.toast("Fahrzeuge wurde upgegraded")
			end
		end
 	end)
	menu.action(orgthingsfriendlyvehicle, "Fahrzeug Reparieren", {}, "", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				menu.trigger_commands("repairveh".. playername)
				util.toast("org Fahrzeuge wurde Repariert")
			end
		end
 	end)
	menu.action(orgthingsfriendlyvehicle, "Unzerstörbar", {}, "AN / AUS", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				local check = menu.get_value(menu.ref_by_command_name("givevehgod".. playername))
				if check then
					menu.trigger_commands("givevehgod".. playername.. " off")
					util.toast("Godmode vehicle wurde für org ausgeschaltet")
				else
					menu.trigger_commands("givevehgod".. playername.. " on")
					util.toast("Godmode vehicle für org eingeschaltet")
				end
			end
		end
 	end)

	--freundlich menu main
	menu.action(orgthingsfriendly, "CEO Geld-Schleife", {}, "wird nicht dem boss gegeben\nAN / AUS", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local bossofceo = players.get_boss(pid1)
				if bossofceo == pid1 then
				else
					local playername = players.get_name(pid1)
					local check = menu.get_value(menu.ref_by_command_name("ceopay".. playername))
					if check then
						menu.trigger_commands("ceopay".. playername.. " off")
						util.toast("CEO Geld-Schleife wurde für org mitglieder ausgeschaltet")
					else
						menu.trigger_commands("ceopay".. playername.. " on")
						util.toast("CEO Geld-Schleife wurde für org mitglieder eingeschaltet")
					end
				end
			end
		end
 	end)
	menu.action(orgthingsfriendly, "Kasino-Figuren Geben", {}, "AN / AUS", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				local check = menu.get_value(menu.ref_by_command_name("figurines".. playername))
				if check then
					menu.trigger_commands("figurines".. playername.. " off")
					util.toast("Kasino-Figuren wurde für org ausgeschaltet")
				else
					menu.trigger_commands("figurines".. playername.. " on")
					util.toast("Kasino-Figuren wurde für org eingeschaltet")
				end
			end
		end
 	end)
	menu.action(orgthingsfriendly, "Spielkarten Geben", {}, "AN / AUS", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				local check = menu.get_value(menu.ref_by_command_name("cards".. playername))
				if check then
					menu.trigger_commands("cards".. playername.. " off")
					util.toast("Spielkarten wurde für org ausgeschaltet")
				else
					menu.trigger_commands("cards".. playername.. " on")
					util.toast("Spielkarten wurde für org eingeschaltet")
				end
			end
		end
 	end)
	menu.action(orgthingsfriendly, "Automatische Heilung", {}, "AN / AUS", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				local check = menu.get_value(menu.ref_by_command_name("autoheal".. playername))
				if check then
					menu.trigger_commands("autoheal".. playername.. " off")
					util.toast("autoheal wurde für org ausgeschaltet")
				else
					menu.trigger_commands("autoheal".. playername.. " on")
					util.toast("autoheal wurde für org eingeschaltet")
				end
			end
		end
 	end)
	menu.action(orgthingsfriendly, "Nie Gefahndet", {}, "AN / AUS", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				local check = menu.get_value(menu.ref_by_command_name("bail".. playername))
				if check then
					menu.trigger_commands("bail".. playername.. " off")
					util.toast("Nie Gefahndet wurde für org ausgeschaltet")
				else
					menu.trigger_commands("bail".. playername.. " on")
					util.toast("Nie Gefahndet wurde für org eingeschaltet")
				end
			end
		end
 	end)
	menu.action(orgthingsfriendly, "Vom Radar Verschwinden", {}, "AN / AUS", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				local check = menu.get_value(menu.ref_by_command_name("giveotr".. playername))
				if check then
					menu.trigger_commands("giveotr".. playername.. " off")
					util.toast("Vom Radar Verschwinden für org ausgeschaltet")
				else
					menu.trigger_commands("giveotr".. playername.. " on")
					util.toast("Vom Radar Verschwinden wurde für org eingeschaltet")
				end
			end
		end
 	end)
	menu.action(orgthingsfriendly, "P's & Q's Geben", {}, "AN / AUS", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				local check = menu.get_value(menu.ref_by_command_name("snack".. playername))
				if check then
					menu.trigger_commands("snack".. playername.. " off")
					util.toast("P's & Q's für org ausgeschaltet")
				else
					menu.trigger_commands("snack".. playername.. " on")
					util.toast("P's & Q's wurde für org eingeschaltet")
				end
			end
		end
 	end)

	--org weapons
	menu.action(orgthingsweapons, "Alle Waffen Geben", {}, "", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				menu.trigger_commands("arm".. playername)
				util.toast("alle Waffen wurde an org gegeben")
			end
		end
 	end)
	menu.action(orgthingsweapons, "Munition Geben", {}, "gibt nur für die ausgerüstete waffe munition", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				menu.trigger_commands("ammo".. playername)
				menu.trigger_commands("ammo".. playername)
				menu.trigger_commands("ammo".. playername)
				menu.trigger_commands("ammo".. playername)
				menu.trigger_commands("ammo".. playername)
				menu.trigger_commands("ammo".. playername)
				menu.trigger_commands("ammo".. playername)
				menu.trigger_commands("ammo".. playername)
				menu.trigger_commands("ammo".. playername)
				menu.trigger_commands("ammo".. playername)
				util.toast("Munition wurde allen gegeben")
			end
		end
 	end)
	menu.action(orgthingsweapons, "Fallschirm Geben", {}, "", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				menu.trigger_commands("paragive".. playername)
				util.toast("Fallschirm wurde an org gegeben")
			end
		end
 	end)
	menu.action(orgthingsweapons, "Unbewaffnen", {}, "AN / AUS", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				local check = menu.get_value(menu.ref_by_command_name("disarm".. playername))
				if check then
					menu.trigger_commands("disarm".. playername.. " off")
					util.toast("Unbewaffnen für org ausgeschaltet")
				else
					menu.trigger_commands("disarm".. playername.. " on")
					util.toast("Unbewaffnen wurde für org eingeschaltet")
				end
			end
		end
 	end)

	--org trolling vehicle
	menu.action(orgthingstrollingvehicle, "Töten", {}, "", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				menu.trigger_commands("killveh".. playername)
				util.toast("autos von org wurden getötet")
			end
		end
 	end)
	menu.action(orgthingstrollingvehicle, "EMP", {}, "", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				menu.trigger_commands("empveh".. playername)
				util.toast("autos von org wurden mit emp versetzt")
			end
		end
 	end)
	menu.action(orgthingstrollingvehicle, "Löschen", {}, "", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				menu.trigger_commands("delveh".. playername)
				util.toast("autos von org wurden gelöscht")
			end
		end
 	end)

	--org trolling
	menu.click_slider(orgthingstrolling, "Fahndungslevel Setzen", {}, "", 0 ,5, 0, 1, function(s)
		local level = s
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				if level == 0 then
					menu.trigger_commands("pwanted".. playername.. " " ..level)
					util.toast("Fahnungslevel von org wurde auf ".. level.. " gesetzt")
				elseif level == 1 then
					menu.trigger_commands("pwanted".. playername.. " " ..level)
					util.toast("Fahnungslevel von org wurde auf ".. level.. " gesetzt")
				elseif level == 2 then
					menu.trigger_commands("pwanted".. playername.. " " ..level)
					util.toast("Fahnungslevel von org wurde auf ".. level.. " gesetzt")
				elseif level == 3 then
					menu.trigger_commands("pwanted".. playername.. " " ..level)
					util.toast("Fahnungslevel von org wurde auf ".. level.. " gesetzt")
				elseif level == 4 then
					menu.trigger_commands("pwanted".. playername.. " " ..level)
					util.toast("Fahnungslevel von org wurde auf ".. level.. " gesetzt")
				elseif level == 5 then
					menu.trigger_commands("pwanted".. playername.. " " ..level)
					util.toast("Fahnungslevel von org wurde auf ".. level.. " gesetzt")
				end
			end
		end
 	end)
	menu.action(orgthingstrolling, "Einfrieren", {}, "AN / AUS", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				local check = menu.get_value(menu.ref_by_command_name("freeze".. playername))
				if check then
					menu.trigger_commands("freeze".. playername.. " off")
					util.toast("Einfrieren wurde für org ausgeschaltet")
				else
					menu.trigger_commands("freeze".. playername.. " on")
					util.toast("Einfrieren wurde für org eingeschaltet")
				end
			end
		end
 	end)
	menu.action(orgthingstrolling, "Kamera Nach Vorne Zwingen", {}, "AN / AUS", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				local check = menu.get_value(menu.ref_by_command_name("confuse".. playername))
				if check then
					menu.trigger_commands("confuse".. playername.. " off")
					util.toast("Kamera Nach Vorne Zwingen wurde für org ausgeschaltet")
				else
					menu.trigger_commands("confuse".. playername.. " on")
					util.toast("Kamera Nach Vorne Zwingen wurde für org eingeschaltet")
				end
			end
		end
 	end)
	menu.action(orgthingstrolling, "Ragdoll", {}, "AN / AUS", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				local check = menu.get_value(menu.ref_by_command_name("ragdoll".. playername))
				if check then
					menu.trigger_commands("ragdoll".. playername.. " off")
					util.toast("Ragdoll wurde für org ausgeschaltet")
				else
					menu.trigger_commands("ragdoll".. playername.. " on")
					util.toast("Ragdoll wurde für org eingeschaltet")
				end
			end
		end
 	end)
	menu.action(orgthingstrolling, "Kamera Verwackeln", {}, "AN / AUS", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				local check = menu.get_value(menu.ref_by_command_name("shakecam".. playername))
				if check then
					menu.trigger_commands("shakecam".. playername.. " off")
					util.toast("Kamera Verwackeln wurde für org ausgeschaltet")
				else
					menu.trigger_commands("shakecam".. playername.. " on")
					util.toast("Kamera Verwackeln wurde für org eingeschaltet")
				end
			end
		end
 	end)
	menu.action(orgthingstrolling, "Töten", {}, "", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				menu.trigger_commands("kill".. playername)
				util.toast("Töten wurde für og angewendet")
			end
		end
 	end)
	menu.action(orgthingstrolling, "Explodieren", {}, "", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				menu.trigger_commands("explode".. playername)
				util.toast("Explodieren wurde für og angewendet")
			end
		end
 	end)
	menu.action(orgthingstrolling, "Benachrichtigungs-Spam", {}, "AN / AUS", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				local check = menu.get_value(menu.ref_by_command_name("notifyspam".. playername))
				if check then
					menu.trigger_commands("notifyspam".. playername.. " off")
					util.toast("Benachrichtigungs-Spam wurde für org ausgeschaltet")
				else
					menu.trigger_commands("notifyspam".. playername.. " on")
					util.toast("Benachrichtigungs-Spam wurde für org eingeschaltet")
				end
			end
		end
 	end)
	menu.action(orgthingstrolling, "Kick Vom Fahrzeug", {}, "", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				menu.trigger_commands("vehkick".. playername)
				util.toast("Kick Vom Fahrzeug wurde für og angewendet")
			end
		end
 	end)
	menu.action(orgthingstrolling, "Kick Vom Innenraum", {}, "", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				menu.trigger_commands("interiorkick".. playername)
				util.toast("Kick Vom Innenraum wurde für og angewendet")
			end
		end
 	end)
	menu.action(orgthingstrolling, "Kick Vom CEO/MC", {}, "kickt den boss raus damit ist die org aufgelöst", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local bossofceo = players.get_boss(pid1)
				if bossofceo == players.user() then
					util.toast("du kickst dich damit selber du depp")
				else
					if bossofceo == pid1 then
						local playername = players.get_name(bossofceo)
						menu.trigger_commands("ceokick".. playername)
						util.toast("Kick Vom CEO/MC wurde für "..playername.. " angewendet")
					end
				end
			end
		end
 	end)
	menu.action(orgthingstrolling, "Unedlicher Ladebildschirm", {}, "", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				menu.trigger_commands("infiniteloading".. playername)
				util.toast("Unedlicher Ladebildschirm wurde für og angewendet")
			end
		end
 	end)
	menu.action(orgthingstrolling, "In Freemode-Mission Zwingen", {}, "", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				menu.trigger_commands("mission".. playername)
				util.toast("In Freemode-Mission Zwingen wurde für og angewendet")
			end
		end
 	end)

	--org crashen
	menu.action(orgthingscrash, "Elegant", {}, "", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				menu.trigger_commands("crash".. playername)
				util.toast("Elegant (crash) wurde für og angewendet")
			end
		end
 	end)
	menu.action(orgthingscrash, "Burger King Fußsalat", {}, "", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				menu.trigger_commands("footlettuce".. playername)
				util.toast("Burger King Fußsalat (crash) wurde für og angewendet")
			end
		end
 	end)
	menu.action(orgthingscrash, "Fahrzeug Totschlag", {}, "", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				menu.trigger_commands("slaughter".. playername)
				util.toast("Fahrzeug Totschlag (crash) wurde für og angewendet")
			end
		end
 	end)
	menu.action(orgthingscrash, "Dampfwalze", {}, "", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				menu.trigger_commands("steamroll".. playername)
				util.toast("Dampfwalze (crash) wurde für og angewendet")
			end
		end
 	end)
	menu.action(orgthings, "Kick", {}, "", function()
		local orgmembers = getorganisationplayers(pid)
		if not orgmembers then
			util.toast("spieler ist in keiner organisation")
		else
			for orgmembers as pid1 do
				local playername = players.get_name(pid1)
				menu.trigger_commands("kick".. playername)
				util.toast("Kick wurde für og angewendet")
			end
		end
 	end)
	

	menu.toggle_loop(anderes, "Remove Player Godmode", {}, "Blocked by most menus.", function()
		util.trigger_script_event(1 << pid, {800157557, pid, 225624744, math.random(0, 9999)})
    end)
	
    menu.action(bozo, "kicken", {"notekick"}, "kickt ihn aus der lobby", function()
         menu.trigger_commands("kick" .. players.get_name(pid))
    end)

    menu.action(bozo, "Stand user", {"notestand"}, "Speichert ihn als stand user", function()
         menu.trigger_commands("historynote" .. players.get_name(pid) .. " " .. "Stand user")
         util.toast(players.get_name(pid) .." wurde als Stand user gespeichert ")
    end)

    menu.action(bozo, "Streamer", {"notestreamer"}, "Speichert ihn als Streamer", function()
         menu.trigger_commands("historynote" .. players.get_name(pid) .. " " .. "Streamer")
         util.toast(players.get_name(pid) .." wurde als Streamer gespeichert ")
    end)

    menu.action(bozo, "Wixxer mit direkt block", {"notewixxermitblock"}, "Speichert ihn als Wixxer mit direkt block aber ohne ein notify", function()
         menu.trigger_commands("historynote" .. players.get_name(pid) .. " " .. "Wixxer")
         menu.trigger_commands("historyblock" .. players.get_name(pid) .. " " .. "on")
         util.toast(players.get_name(pid) .." wurde als Wixxer mit Block gespeichert ")
    end)
   
    menu.action(bozo, "Wixxer ohne block", {"notewixxer"}, "Speichert ihn als Wixxer ohne block", function()
         menu.trigger_commands("historynote" .. players.get_name(pid) .. " " .. "Wixxer")
         util.toast(players.get_name(pid) .." wurde als Wixxer ohne block gespeichert ")
    end)

    menu.action(bozo, "Freund", {"notefreund"}, "Speichert ihn als Freund", function()
         menu.trigger_commands("historynote" .. players.get_name(pid) .. " " .. "Freund")
         util.toast(players.get_name(pid) .." wurde als Freund gespeichert ")
    end)

    menu.action(bozo, "Modder", {"notemodder"}, "Speichert ihn als Modder", function()
         menu.trigger_commands("historynote" .. players.get_name(pid) .. " " .. "Modder")
         util.toast(players.get_name(pid) .." wurde als Modder gespeichert ")
    end)

    menu.action(bozo, "Notiz entfernen", {"noteentfernen"}, "Entfernt seine jetzige notiz und wenn blockt dann auch denn block", function()
         menu.trigger_commands("historynote" .. players.get_name(pid) .. " " .. "")
         menu.trigger_commands("historyblock" .. players.get_name(pid) .. " " .. "off")
         util.toast(players.get_name(pid) .." Notiz wurde entfernt ")
    end)

    menu.action(bozo, "Zur history seite", {}, "zur history seite", function()
         menu.trigger_commands("history")
    end)



	--[[if (filesystem.exists(filesystem.scripts_dir() .. "lib/wiriscript/orbital_cannon.lua")) then
		local OrbitalCannon = require "wiriscript.orbital_cannon"

		menu.action(main, "Kill With Orbital Cannon", {}, "", function()
			if players.is_in_interior(pid) then
				util.toast("ist im gebäude")
			elseif is_player_passive(pid) then
				util.toast("ist im passive")
			elseif not OrbitalCannon.exists() and IS_PLAYER_PLAYING(pid) then
				OrbitalCannon.create(pid)
			end
		end)

		util.on_stop(function()
			if OrbitalCannon.exists() then
				OrbitalCannon.destroy()
			end
		end)
		
		while true do
			OrbitalCannon.mainLoop()
			util.yield_once()
		end
	else
		menu.action(main, "Kill With Orbital Cannon", {}, "", function()
			util.toast("du hast bestimmte files nicht")
		end)
	end]]
end

function nearentitiysloadsphere()
	if not nearentitysloadsphererange then
		return false
	end
	if menu.is_focused(maxDistnearentitys, false) then
		loadsphereninrangered(maxDistancenearentitys)
	end
end

players.on_join(player)
players.dispatch_on_join()

--local parents
Self = menu.list(menu.my_root(), "Self zeug", {}, "")
vehicle = menu.list(menu.my_root(), "Vehicle zeug", {}, "")
Entitymanager = menu.list(menu.my_root(), "Entity Manager", {}, "")
Entitymanagercleararea = menu.list(Entitymanager, "Clear Area", {}, "")
Entitymanageresp = menu.list(Entitymanager, "Entity ESP", {}, "")
Entitymanagernearvehicle = menu.list(Entitymanager, "Near Entitys", {}, "", function(on_click)
		nearentitysloadsphererange = true
		util.create_tick_handler(nearentitiysloadsphere)
	end, function(on_back)
		nearentitysloadsphererange = false
end)
Entitymanagercontextmenu = menu.list(Entitymanager, "Context menu", {}, "")
player_zeug = menu.list(menu.my_root(), "Lobby zeug", {}, "")
--streamer = menu.list(player_zeug, "Streamer zeug", {}, "")
Zeugforjob = menu.list(menu.my_root(), "Zeug für jobs/missions", {}, "")
customselection = menu.list(menu.my_root(), "Custom Selection", {}, "")
misc = menu.list(menu.my_root(), "Misc", {}, "")
Menyoveh = menu.list(menu.my_root(), "Menyoo vehicle/maps spawn", {}, "only xml,ini files")


Entitymanagerespvehicle = menu.list(Entitymanageresp, "Vehicles", {}, "")
Entitymanageresppeds = menu.list(Entitymanageresp, "Peds", {}, "")
Entitymanagerespobjects = menu.list(Entitymanageresp, "objects", {}, "")
Entitymanageresppickups = menu.list(Entitymanageresp, "Pickups", {}, "")

local deactivateother = false
menu.toggle(Entitymanageresp, "Deaktivieren andere ESP", {}, "deactiviere andere esp wenn du eine an machst", function(on_toggle)
	if on_toggle then
		deactivateother = true
	else
		deactivateother = false
	end
end)

local enabledveh, showonlymissionveh = false, false
xValueveh, yValueveh, scaleValueveh = 0, 0, 35
colorveh = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 }
local maxDistanceveh = 700
local showDistanceveh, shownameveh, showmyveh, showspeedveh, showdriverveh, showinvehveh, showmissionveh, showownerveh, showentitygroupveh, 
showonlyotherownerveh, getonlyvisibleveh, showdestroyedveh, showidnameveh = true, true, true, true, false, false, false, false, true, false, false, true, true

	function renderESPveh(givedata)
		if not enabledveh then
	        return false
	    end
		if not util.is_session_started() or IS_PAUSE_MENU_ACTIVE() then
			return
		end
		local data = {}
		local gameX, gameY = memory.alloc(1), memory.alloc(1)
	    local myPed = players.user_ped()
	    local myPos = players.get_position(players.user())
	    for _, vehs in pairs(entities.get_all_vehicles_as_pointers()) do
			local vehshandle = entities.pointer_to_handle(vehs)
	        if not IS_ENTITY_ON_SCREEN(vehshandle) and getonlyvisibleveh then
	            goto continue
	        end
			local modelhash = entities.get_model_hash(vehs)
	        local pPos = entities.get_position(vehs)
	        local dist = myPos:distance(pPos)
	        if (dist > maxDistanceveh) then
	            goto continue
	        end
			local driverplayer = false
	        local isMyVehicle = false
			local ispedinveh = IS_PED_IN_ANY_VEHICLE(myPed, false)
			local vehofped = GET_VEHICLE_PED_IS_IN(myPed, false)
	       	local driver = GET_PED_IN_VEHICLE_SEAT(vehshandle, -1)
			local ownerveh =  players.get_name(entities.get_owner(vehshandle))
			local missionentityveh = IS_ENTITY_A_MISSION_ENTITY(vehshandle)
	            if driver == myPed then
	                isMyVehicle = true
	            end
			if not showmyveh and ispedinveh and vehofped == vehshandle then
				goto continue
			end
			if (not missionentityveh) and showonlymissionveh then
				goto continue
			end
			if IS_PED_A_PLAYER(driver) then
				driverplayer = true
				driverplayerindex = players.get_name(NETWORK_GET_PLAYER_INDEX_FROM_PED(driver))
			end
	        local posToUse = pPos
	        GET_SCREEN_COORD_FROM_WORLD_COORD(posToUse.x, posToUse.y, posToUse.z + 1, gameX, gameY)
	        local screenX, screenY = memory.read_float(gameX), memory.read_float(gameY)
	        local valuesToDisplay = {}
	        local playersInVehicle = ""
			if showentitygroupveh then
	            valuesToDisplay[#valuesToDisplay + 1] = "VEHICLE"
	        end
			if showDistanceveh then
	            valuesToDisplay[#valuesToDisplay + 1] = math.floor(dist)
	        end
			if (shownameveh or showspeedveh or showidnameveh) then
	            local textline = ""
	            if shownameveh then
	                textline = getmodelnamebyhash(modelhash) .. " "
	            end
				if showidnameveh then
	                textline = textline .. "["..util.reverse_joaat(modelhash) .. "] "
	            end
	            if showspeedveh and getSpeed(vehshandle, true) > 0 then
	                textline = textline .. getSpeed(vehshandle)
	            end
	            valuesToDisplay[#valuesToDisplay + 1] = textline
	        end
	        if isMyVehicle and showinvehveh then
	            local maxPassengers = GET_VEHICLE_MAX_NUMBER_OF_PASSENGERS(vehshandle)
	            for i = 0, maxPassengers do
	                if not IS_VEHICLE_SEAT_FREE(vehshandle, i, false) then
	                    local vehPed = GET_PED_IN_VEHICLE_SEAT(vehshandle, i)
	                    if IS_PED_A_PLAYER(vehPed) then
	                        playersInVehicle = playersInVehicle .. players.get_name(NETWORK_GET_PLAYER_INDEX_FROM_PED(vehPed)) .. ", "
	                    end
	                end
	            end
			end
			if not isMyVehicle and showinvehveh then
				local maxPassengers = GET_VEHICLE_MAX_NUMBER_OF_PASSENGERS(vehshandle)
				for i = 0, maxPassengers do
	                if not IS_VEHICLE_SEAT_FREE(vehshandle, i, false) then
	                    local vehPed = GET_PED_IN_VEHICLE_SEAT(vehshandle, i)
	                    if IS_PED_A_PLAYER(vehPed) then
	                        playersInVehicle = playersInVehicle .. players.get_name(NETWORK_GET_PLAYER_INDEX_FROM_PED(vehPed)) .. ", "
	                    end
	                end
	            end
	        end
			if driverplayer and showdriverveh then
	            valuesToDisplay[#valuesToDisplay + 1] = "Driver" .. ": " .. driverplayerindex
	        end
	        if playersInVehicle:len() > 0 then
	            valuesToDisplay[#valuesToDisplay + 1] = "in Vehicle" .. ": " .. playersInVehicle:gsub(", $", "")
	        end
			if missionentityveh and showmissionveh then
				valuesToDisplay[#valuesToDisplay + 1] = "Mission Entity"
			end
			if showownerveh then
				if  showonlyotherownerveh and (ownerveh == players.get_name(players.user())) then
				else
					valuesToDisplay[#valuesToDisplay + 1] = "Owner: ".. ownerveh
				end
			end
			if (GET_VEHICLE_ENGINE_HEALTH(vehshandle) <= 0) and not showdestroyedveh then
				goto continue
			end
	        local text = table.concat(valuesToDisplay, "\n")
			if not givedata then
	       		directx.draw_text(screenX + xValueveh, screenY + yValueveh, text, 5, scaleValueveh, colorveh, false)
			end
			if givedata then
				table.insert(data, vehshandle)
			end
			::continue::
		end
		if givedata then
			return data
		end
	end
	
enabledToggleveh = menu.toggle(Entitymanagerespvehicle, "Enable ESP Vehicle", {"ESPveh"}, "", function(on_toggle)
	if on_toggle then
		enabledveh = true
		if deactivateother then
			if menu.get_value(enabledToggleped) then
				menu.set_value(enabledToggleped, false)
			end
			if menu.get_value(enabledToggleobj) then
				menu.set_value(enabledToggleobj, false)
			end
			if menu.get_value(enabledTogglepickup) then
				menu.set_value(enabledTogglepickup, false)
			end
		end
		util.create_tick_handler(renderESPveh)
	else
		enabledveh = false
	end
end)


onlymissionToggleveh = menu.toggle(Entitymanagerespvehicle, "Show Only Mission", {}, "", function(on)
	showonlymissionveh = on
end, showonlymissionveh)
showonlymissionveh = menu.get_value(onlymissionToggleveh)

actionSubmenuveh = menu.list(Entitymanagerespvehicle, "Action", {}, "action für die auf dennen ESP drauf ist")
actionsettingsSubmenuveh = menu.list(actionSubmenuveh, "Settings", {}, "")
explosiontype = 6
explosionsettingveh = menu.list_select(actionsettingsSubmenuveh, "Explosion", {}, "Explosion wie haftbomben oder granaten haben eine grenze also nicht wundern", tables.explosionvariation, explosiontype, function(value)
	explosiontype = value
end)
onlyvisibleToggleveh = menu.toggle(actionSubmenuveh, "get only visible vehs", {}, "", function(on)
	getonlyvisibleveh = on
end, getonlyvisibleveh)
getonlyvisibleveh = menu.get_value(onlyvisibleToggleveh)
menu.action(actionSubmenuveh, "teleport to me", {}, "Nutzen auf eigene gefahr\nignoriert spieler", function()
	local data = renderESPveh(true)
	if data then
		pPos = players.get_position(players.user())
		for data as entity do
			if IS_VEHICLE_SEAT_FREE(entity, -1, false) then
				if entities.request_control(entity, 150) then
					SET_ENTITY_AS_MISSION_ENTITY(entity)
					SET_ENTITY_COORDS(entity, pPos.x, pPos.y, pPos.z)
				end
			else
				pedinseat = GET_PED_IN_VEHICLE_SEAT(entity, -1, true)
				if not IS_PED_A_PLAYER(pedinseat) then
					if entities.request_control(entity, 150) then
						SET_ENTITY_AS_MISSION_ENTITY(entity)
						SET_ENTITY_COORDS(entity, pPos.x, pPos.y, pPos.z)
					end
				end
			end
		end
	else
		util.toast("du musst zuerst das ESP an machen dafür")
	end
end)
menu.action(actionSubmenuveh, "Delete", {}, "", function()
	local data = renderESPveh(true)
	if data then
		for data as entity do
			if IS_VEHICLE_SEAT_FREE(entity, -1, false) then
				if entities.request_control(entity, 150) then
					entities.delete(entity)
				end
			else
				pedofvehicle = GET_PED_IN_VEHICLE_SEAT(entity, -1, true)
				if not IS_PED_A_PLAYER(pedofvehicle) then
					if entities.request_control(pedofvehicle, 150) then
						entities.delete(entity)
					end
				end
			end
		end
	else
		util.toast("du musst zuerst das ESP an machen dafür")
	end
end)
menu.action(actionSubmenuveh, "Explode", {}, "bissel bugi aber mit bissel spamen geht klar", function()
	local time = 0
	local data = renderESPveh(true)
	if data then
		for data as entity do
			--local pointerent = entities.handle_to_pointer(entity)
			--local positon = entities.get_position(pointerent)
			local boneindex = GET_ENTITY_BONE_INDEX_BY_NAME(entity, "engine")
			local position = GET_ENTITY_BONE_POSTION(entity, boneindex)
			if position ~= number then
				if IS_VEHICLE_SEAT_FREE(entity, -1, false) then
					--if entities.request_control(entity, 150) then
						repeat
							util.yield()
							time += 1
							ADD_EXPLOSION(position.x, position.y, position.z, explosiontype, 100, true, false, 0.0, false)
						until (GET_VEHICLE_ENGINE_HEALTH(entity) <= 0) or time == 500 or (not DOES_ENTITY_EXIST(entity))
					--end
				else
					pedofvehicle = GET_PED_IN_VEHICLE_SEAT(entity, -1, true)
					if not IS_PED_A_PLAYER(pedofvehicle) then
						--if entities.request_control(pedofvehicle, 150) then
							repeat
								util.yield()
								time += 1
								ADD_EXPLOSION(position.x, position.y, position.z, explosiontype, 100, true, false, 0.0, false)
							until (GET_VEHICLE_ENGINE_HEALTH(entity) <= 0) or time == 500 or (not DOES_ENTITY_EXIST(entity))
						--end
					end
				end
			end
		end
	else
		util.toast("du musst zuerst das ESP an machen dafür")
	end
end)
menu.action(actionSubmenuveh, "Repair", {}, "", function()
	local data = renderESPveh(true)
	if data then
		pPos = players.get_position(players.user())
		for data as entity do
			if IS_VEHICLE_SEAT_FREE(entity, -1, false) then
				if entities.request_control(entity, 150) then
					STOP_ENTITY_FIRE(entity)
					SET_VEHICLE_FIXED(entity)
					SET_VEHICLE_DIRT_LEVEL(entity, 0)
				end
			else
				pedinseat = GET_PED_IN_VEHICLE_SEAT(entity, -1, true)
				if not IS_PED_A_PLAYER(pedinseat) then
					if entities.request_control(entity, 150) then
						STOP_ENTITY_FIRE(entity)
						SET_VEHICLE_FIXED(entity)
						SET_VEHICLE_DIRT_LEVEL(entity, 0)
					end
				end
			end
		end
	else
		util.toast("du musst zuerst das ESP an machen dafür")
	end
end)
menu.toggle_loop(actionSubmenuveh, "Freeze", {}, "", function()
	local data = renderESPveh(true)
	if data then
		pPos = players.get_position(players.user())
		for data as entity do
			if IS_VEHICLE_SEAT_FREE(entity, -1, false) then
				if entities.request_control(entity, 150) then
					FREEZE_ENTITY_POSITION(entity, true)
				end
			else
				pedinseat = GET_PED_IN_VEHICLE_SEAT(entity, -1, true)
				if not IS_PED_A_PLAYER(pedinseat) then
					if entities.request_control(entity, 150) then
						FREEZE_ENTITY_POSITION(entity, true)
					end
				end
			end
		end
	else
		util.toast("du musst zuerst das ESP an machen dafür")
	end
end)
menu.toggle_loop(actionSubmenuveh, "UN Freeze", {}, "", function()
	local data = renderESPveh(true)
	if data then
		pPos = players.get_position(players.user())
		for data as entity do
			if IS_VEHICLE_SEAT_FREE(entity, -1, false) then
				if entities.request_control(entity, 150) then
					FREEZE_ENTITY_POSITION(entity, false)
				end
			else
				pedinseat = GET_PED_IN_VEHICLE_SEAT(entity, -1, true)
				if not IS_PED_A_PLAYER(pedinseat) then
					if entities.request_control(entity, 150) then
						FREEZE_ENTITY_POSITION(entity, false)
					end
				end
			end
		end
	else
		util.toast("du musst zuerst das ESP an machen dafür")
	end
end)

positionSubmenuveh = menu.list(Entitymanagerespvehicle, "position", {}, "")
xSliderveh = menu.slider(positionSubmenuveh, "XPos", {}, "", -10, 10, xValueveh, 1, function(val)
	xValueveh = val / 200
end)
--xValue = menu.get_value(xSlider) / 100
ySliderveh = menu.slider(positionSubmenuveh, "YPos", {}, "", -10, 10, yValueveh, 1, function(val)
	yValueveh = val / 200
end)
--yValue = menu.get_value(ySlider) / 100
scaleSliderveh = menu.slider(positionSubmenuveh, "scale", {}, "", 1, 200, scaleValueveh, 1, function(val)
	scaleValueveh = val / 100
end)
scaleValueveh = menu.get_value(scaleSliderveh) / 100

colorRefveh = menu.colour(Entitymanagerespvehicle, "color", {}, "", colorveh, true, function(c)
	colorveh = c
end)

maxDistSliderveh = menu.slider(Entitymanagerespvehicle, "max Dist", {"setdisvehicle"}, "", 10, 10000, maxDistanceveh, 10, function(val)
	maxDistanceveh = val
end)
maxDistanceveh = menu.get_value(maxDistSliderveh)

entitygroupToggleveh = menu.toggle(Entitymanagerespvehicle, "show Entity Group", {}, "", function(on)
	showentitygroupveh = on
end, showentitygroupveh)
showentitygroupveh = menu.get_value(entitygroupToggleveh)
distToggleveh = menu.toggle(Entitymanagerespvehicle, "show Distance", {}, "", function(on)
	showDistanceveh = on
end, showDistanceveh)
showDistanceveh = menu.get_value(distToggleveh)
nametoggleveh = menu.toggle(Entitymanagerespvehicle, "show Name", {}, "", function(on)
	shownameveh = on
end, shownameveh)
shownameveh = menu.get_value(nametoggleveh)
idnametoggleveh = menu.toggle(Entitymanagerespvehicle, "show ID Name", {}, "", function(on)
	showidnameveh = on
end, showidnameveh)
showidnameveh = menu.get_value(idnametoggleveh)
speedtoggleveh = menu.toggle(Entitymanagerespvehicle, "show Speed", {}, "", function(on)
	showspeedveh = on
end, showspeedveh)
showspeedveh = menu.get_value(speedtoggleveh)
showdrivertoggleveh = menu.toggle(Entitymanagerespvehicle, "show Driver", {}, "", function(on)
	showdriverveh = on
end, showdriverveh)
showdriverveh = menu.get_value(showdrivertoggleveh)
showinvehtoggleveh = menu.toggle(Entitymanagerespvehicle, "show In vehicle", {}, "", function(on)
	showinvehveh = on
end, showinvehveh)
showinvehveh = menu.get_value(showinvehtoggleveh)
myvehtoggleveh = menu.toggle(Entitymanagerespvehicle, "show My Vehicle", {}, "", function(on)
	showmyveh = on
end, showmyveh)
showmyveh = menu.get_value(myvehtoggleveh)
missiontoggleveh = menu.toggle(Entitymanagerespvehicle, "show Mission Entity", {}, "", function(on)
	showmissionveh = on
end, showmissionveh)
showmissionveh = menu.get_value(missiontoggleveh)
ownertoggleveh = menu.toggle(Entitymanagerespvehicle, "show Owner", {}, "", function(on)
	showownerveh = on
end, showownerveh)
showownerveh = menu.get_value(ownertoggleveh)
onlyotherownertoggleveh = menu.toggle(Entitymanagerespvehicle, "show only other Owners", {}, "", function(on)
	showonlyotherownerveh = on
end, showonlyotherownerveh)
showonlyotherownerveh = menu.get_value(onlyotherownertoggleveh)
destroyedtoggleveh = menu.toggle(Entitymanagerespvehicle, "show Destroyed vehicle", {}, "", function(on)
	showdestroyedveh = on
end, showdestroyedveh)
showdestroyedveh = menu.get_value(destroyedtoggleveh)

local enabledped, showonlymissionped = false, false
local xValueped, yValueped, scaleValueped = 0, 0, 35
local colorped = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 }
local maxDistanceped = 700
local showDistanceped, shownameped, showmissionped, showvehpedisinped, showownerped, showentitygroupped, showdeadped, 
getonlyvisibleped, showpedsinvehped, showonlyblibsped = true, true, true, true, false, true, false, false, true, false

	function renderESPped(givedata)
		if not enabledped then
	        return false
	    end
		if not util.is_session_started() or IS_PAUSE_MENU_ACTIVE() then
			return
		end
		local data = {}
		local gameX, gameY = memory.alloc(1), memory.alloc(1)
	    local myPed = players.user_ped()
	    local myPos = players.get_position(players.user())
	    for _, peds in pairs(entities.get_all_peds_as_pointers()) do
			local pedshandle = entities.pointer_to_handle(peds)
	        if (not IS_ENTITY_ON_SCREEN(pedshandle)) and getonlyvisibleped then
	            goto continue
	        end
			local modelhash = entities.get_model_hash(peds)
	        local pPos = entities.get_position(peds)
	        local dist = myPos:distance(pPos)
			local ownerped =  players.get_name(entities.get_owner(pedshandle))
	        if (dist > maxDistanceped) then
	            goto continue
	        end
			local ispedinveh = IS_PED_IN_ANY_VEHICLE(pedshandle, false)
			local vehofped = GET_VEHICLE_PED_IS_IN(pedshandle, false)
			local vehmodelhash = entities.get_model_hash(vehofped)
			local missionentityped = IS_ENTITY_A_MISSION_ENTITY(pedshandle)
			ispeddead = IS_PED_DEAD_OR_DYING(pedshandle, 1)
			if IS_PED_A_PLAYER(pedshandle) then
				goto continue
			end
			if (not missionentityped) and showonlymissionped then
				goto continue
			end
			if not showdeadped and ispeddead then
				goto continue
			end
			if ispedinveh and not showpedsinvehped then
				goto continue
			end
			if showonlyblibsped and (GET_BLIP_FROM_ENTITY(pedshandle) == 0) then
				goto continue
			end
	        local posToUse = pPos
	        GET_SCREEN_COORD_FROM_WORLD_COORD(posToUse.x, posToUse.y, posToUse.z + 1, gameX, gameY)
	        local screenX, screenY = memory.read_float(gameX), memory.read_float(gameY)
	        local valuesToDisplay = {}
			if showentitygroupped then
	            valuesToDisplay[#valuesToDisplay + 1] = "PED"
	        end
			if showDistanceped then
	            valuesToDisplay[#valuesToDisplay + 1] = math.floor(dist)
	        end
			if shownameped then
	            local textline = ""
	            if shownameped then
	                textline = getmodelnamebyhash(modelhash) .. " "
	            end
	            valuesToDisplay[#valuesToDisplay + 1] = textline
	        end
	        if ispedinveh and showvehpedisinped then
				valuesToDisplay[#valuesToDisplay + 1] = "Vehicle: ".. getmodelnamebyhash(vehmodelhash)
			end
			if missionentityped and showmissionped then
				valuesToDisplay[#valuesToDisplay + 1] = "Mission Entity"
			end
			if showownerped then
				valuesToDisplay[#valuesToDisplay + 1] = "Owner: ".. ownerped
			end
	        local text = table.concat(valuesToDisplay, "\n")
			if not givedata then
	        	directx.draw_text(screenX + xValueped, screenY + yValueped, text, 5, scaleValueped, colorped, false)
			end
			if givedata then
				table.insert(data, pedshandle)
			end
			::continue::
	    end
		if givedata then
			return data
		end
	end
	
enabledToggleped = menu.toggle(Entitymanageresppeds, "Enable ESP Ped", {"ESPped"}, "", function(on_toggle)
	if on_toggle then
		enabledped = true
		if deactivateother then
			if menu.get_value(enabledToggleveh) then
				menu.set_value(enabledToggleveh, false)
			end
			if menu.get_value(enabledToggleobj) then
				menu.set_value(enabledToggleobj, false)
			end
			if menu.get_value(enabledTogglepickup) then
				menu.set_value(enabledTogglepickup, false)
			end
		end
		util.create_tick_handler(renderESPped)
	else
		enabledped = false
	end
end)

onlymissionToggleped = menu.toggle(Entitymanageresppeds, "Show Only Mission", {}, "", function(on)
	showonlymissionped = on
end, showonlymissionped)
showonlymissionped = menu.get_value(onlymissionToggleped)
onlyblibsToggleped = menu.toggle(Entitymanageresppeds, "Show Only peds with blibs", {}, "", function(on)
	showonlyblibsped = on
end, showonlyblibsped)
showonlyblibsped = menu.get_value(onlyblibsToggleped)

actionSubmenuped = menu.list(Entitymanageresppeds, "Action", {}, "action für die auf dennen ESP drauf ist")
actionsettingsSubmenuped = menu.list(actionSubmenuped, "Settings", {}, "")
explosionsettingped = menu.list_select(actionsettingsSubmenuped, "Explosion", {}, "Explosion wie haftbomben oder granaten haben eine grenze also nicht wundern", tables.explosionvariation, explosiontype, function(value)
	explosiontype = value
end)
onlyvisibleToggleped = menu.toggle(actionSubmenuped, "get only visible peds", {}, "", function(on)
	getonlyvisibleped = on
end, getonlyvisibleped)
getonlyvisibleped = menu.get_value(onlyvisibleToggleped)
menu.action(actionSubmenuped, "teleport to me", {}, "ignoriert spieler", function()
	local data = renderESPped(true)
	if data then
		pPos = players.get_position(players.user())
		for data as entity do
			if not IS_PED_A_PLAYER(entity) then
				if entities.request_control(entity, 150) then
					if IS_PED_IN_ANY_VEHICLE(entity, false) then
						CLEAR_PED_TASKS_IMMEDIATELY(entity)
						TASK_LEAVE_ANY_VEHICLE(entity, 0, 16)
						SET_ENTITY_COORDS(entity, pPos.x, pPos.y, pPos.z)
					else
						SET_ENTITY_COORDS(entity, pPos.x, pPos.y, pPos.z)
					end
				end
			end
		end
	else
		util.toast("du musst zuerst das ESP an machen dafür")
	end
end)
menu.action(actionSubmenuped, "Delete", {}, "", function()
	local data = renderESPped(true)
	if data then
		pPos = players.get_position(players.user())
		for data as entity do
			if not IS_PED_A_PLAYER(entity) then
				if entities.request_control(entity, 150) then
					entities.delete(entity)
				end
			end
		end
	else
		util.toast("du musst zuerst das ESP an machen dafür")
	end
end)
menu.action(actionSubmenuped, "Explode", {}, "", function()
	local time = 0
	local data = renderESPped(true)
	if data then
		for data as entity do
			--local pointerent = entities.handle_to_pointer(entity)
			--local positon = entities.get_position(pointerent)
			local boneindex = GET_ENTITY_BONE_INDEX_BY_NAME(entity, "IK_Head")
			local position = GET_ENTITY_BONE_POSTION(entity, boneindex)
			if position ~= number then
				if not IS_PED_A_PLAYER(entity) then
					if GET_ENTITY_CAN_BE_DAMAGED(entity) then
						repeat
							util.yield()
							time += 1
							ADD_EXPLOSION(position.x, position.y, position.z, explosiontype, 100, true, false, 0.0, false)
						until (IS_PED_DEAD_OR_DYING(entity)) or time == 100 or (not DOES_ENTITY_EXIST(entity))
					end
				end
			end
		end
	else
		util.toast("du musst zuerst das ESP an machen dafür")
	end
end)
menu.action(actionSubmenuped, "HEAL", {}, "", function()
	local data = renderESPped(true)
	if data then
		pPos = players.get_position(players.user())
		for data as entity do
			if not IS_PED_A_PLAYER(entity) then
				if entities.request_control(entity, 150) then
					maxhealth = GET_PED_MAX_HEALTH(entity)
					SET_ENTITY_HEALTH(entity, maxhealth, 0)
					STOP_ENTITY_FIRE(entity)
					CLEAR_PED_TASKS_IMMEDIATELY(entity)
				end
			end
		end
	else
		util.toast("du musst zuerst das ESP an machen dafür")
	end
end)
menu.action(actionSubmenuped, "silent kill", {}, "", function()
	local data = renderESPped(true)
	if data then
		pPos = players.get_position(players.user())
		for data as entity do
			if not IS_PED_A_PLAYER(entity) then
				if entities.request_control(entity, 150) then
					SET_ENTITY_HEALTH(entity, 0, 0)
					FORCE_PED_MOTION_STATE(entity, 0x0DBB071C, 0,0,0)
				end
			end
		end
	else
		util.toast("du musst zuerst das ESP an machen dafür")
	end
end)
menu.action(actionSubmenuped, "Clear Tasks", {}, "", function()
	local data = renderESPped(true)
	if data then
		pPos = players.get_position(players.user())
		for data as entity do
			if not IS_PED_A_PLAYER(entity) then
				if entities.request_control(entity, 150) then
					CLEAR_PED_TASKS_IMMEDIATELY(entity)
				end
			end
		end
	else
		util.toast("du musst zuerst das ESP an machen dafür")
	end
end)
menu.action(actionSubmenuped, "Freeze", {}, "", function()
	local data = renderESPped(true)
	if data then
		pPos = players.get_position(players.user())
		for data as entity do
			if not IS_PED_A_PLAYER(entity) then
				if entities.request_control(entity, 150) then
					FREEZE_ENTITY_POSITION(entity, true)
				end
			end
		end
	else
		util.toast("du musst zuerst das ESP an machen dafür")
	end
end)
menu.action(actionSubmenuped, "UN Freeze", {}, "", function()
	local data = renderESPped(true)
	if data then
		pPos = players.get_position(players.user())
		for data as entity do
			if not IS_PED_A_PLAYER(entity) then
				if entities.request_control(entity, 150) then
					FREEZE_ENTITY_POSITION(entity, false)
				end
			end
		end
	else
		util.toast("du musst zuerst das ESP an machen dafür")
	end
end)
menu.action(actionSubmenuped, "Leave all vehicle", {}, "", function()
	local data = renderESPped(true)
	if data then
		pPos = players.get_position(players.user())
		for data as entity do
			if not IS_PED_A_PLAYER(entity) then
				if IS_PED_IN_ANY_VEHICLE(entity) then
					local getvehicle = GET_VEHICLE_PED_IS_IN(entity, false)
					if entities.request_control(entity, 150) then
						TASK_LEAVE_VEHICLE(entity, getvehicle, 16)
					end
				end
			end
		end
	else
		util.toast("du musst zuerst das ESP an machen dafür")
	end
end)

positionSubmenuped = menu.list(Entitymanageresppeds, "position", {}, "")
xSliderped = menu.slider(positionSubmenuped, "XPos", {}, "", -10, 10, xValueped, 1, function(val)
	xValueped = val / 200
end)
--xValue = menu.get_value(xSlider) / 100
ySliderped = menu.slider(positionSubmenuped, "YPos", {}, "", -10, 10, yValueped, 1, function(val)
	yValueped = val / 200
end)
--yValue = menu.get_value(ySlider) / 100
scaleSliderped = menu.slider(positionSubmenuped, "scale", {}, "", 1, 200, scaleValueped, 1, function(val)
	scaleValueped = val / 100
end)
scaleValueped = menu.get_value(scaleSliderped) / 100

colorRefped = menu.colour(Entitymanageresppeds, "color", {}, "", colorped, true, function(c)
	colorped = c
end)

maxDistSliderped = menu.slider(Entitymanageresppeds, "max Dist", {"setdisped"}, "", 10, 10000, maxDistanceped, 10, function(val)
	maxDistanceped = val
end)
maxDistanceped = menu.get_value(maxDistSliderped)

entitygroupToggleped = menu.toggle(Entitymanageresppeds, "show Entity Group", {}, "", function(on)
	showentitygroupped = on
end, showentitygroupped)
showentitygroupped = menu.get_value(entitygroupToggleped)
distToggleped = menu.toggle(Entitymanageresppeds, "show Distance", {}, "", function(on)
	showDistanceped = on
end, showDistanceped)
showDistanceped = menu.get_value(distToggleped)
nametoggleped = menu.toggle(Entitymanageresppeds, "show Name", {}, "", function(on)
	shownameped = on
end, shownameped)
shownameped = menu.get_value(nametoggleped)
pedsinvehtoggleped = menu.toggle(Entitymanageresppeds, "show Peds in vehicle", {}, "", function(on)
	showpedsinvehped = on
end, showpedsinvehped)
showpedsinvehped = menu.get_value(pedsinvehtoggleped)
vehpedisintoggleped = menu.toggle(Entitymanageresppeds, "show Vehicle PedIsIn", {}, "", function(on)
	showvehpedisinped = on
end, showvehpedisinped)
showvehpedisinped = menu.get_value(vehpedisintoggleped)
missiontoggleped = menu.toggle(Entitymanageresppeds, "show Mission Entity", {}, "", function(on)
	showmissionped = on
end, showmissionped)
showmissionped = menu.get_value(missiontoggleped)
deadtoggleped = menu.toggle(Entitymanageresppeds, "show dead peds", {}, "", function(on)
	showdeadped = on
end, showdeadped)
showdeadped = menu.get_value(deadtoggleped)
ownertoggleped = menu.toggle(Entitymanageresppeds, "show Owner", {}, "", function(on)
	showownerped = on
end, showownerped)
showownerped = menu.get_value(ownertoggleped)


local enabledobj, showonlymissionobj = false, false
local xValueobj, yValueobj, scaleValueobj = 0, 0, 35
local colorobj = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 }
local maxDistanceobj = 300
local showDistanceobj, shownameobj, showmissionobj, showownerobj, showattachtoobjobj, showattachtopedobj, 
showattachtovehobj, showentitygroupobj, getonlyvisibleobj = true, true, true, true, false, false, false, true, false

	function renderESPobj(givedata)
		if not enabledobj then
	        return false
	    end
		if not util.is_session_started() or IS_PAUSE_MENU_ACTIVE() then
			return
		end
		local data = {}
		local gameX, gameY = memory.alloc(1), memory.alloc(1)
	    local myPed = players.user_ped()
	    local myPos = players.get_position(players.user())
	    for _, objs in pairs(entities.get_all_objects_as_pointers()) do
			local objshandle = entities.pointer_to_handle(objs)
	        if not IS_ENTITY_ON_SCREEN(objshandle) and getonlyvisibleobj then
	            goto continue
	        end
			local modelhash = entities.get_model_hash(objs)
	        local pPos = entities.get_position(objs)
	        local dist = myPos:distance(pPos)
			local ownerobj = players.get_name(entities.get_owner(objshandle))
			local missionentityobj = IS_ENTITY_A_MISSION_ENTITY(objshandle)
			local attachedobj = IS_ENTITY_ATTACHED_TO_ANY_OBJECT(objshandle)
			local attachedped = IS_ENTITY_ATTACHED_TO_ANY_PED(objshandle)
			local attachedveh = IS_ENTITY_ATTACHED_TO_ANY_VEHICLE(objshandle)
	        if (dist > maxDistanceobj) then
	            goto continue
	        end
			if (not missionentityobj) and showonlymissionobj then
				goto continue
			end
			if showattachtoobjobj or showattachtopedobj or showattachtovehobj then
				if attachedobj or attachedped or attachedveh then
					if attachedobj and showattachtoobjobj then
						goto checkdone
					end
					if attachedped and showattachtopedobj then
						goto checkdone
					end
					if attachedveh and showattachtovehobj then
						goto checkdone
					end
				end
				goto continue
			end
			--[[if not attachedobj and showattachtoobjobj then
				goto continue
			end
			if not attachedped and showattachtopedobj then
				goto continue
			end
			if not attachedveh and showattachtovehobj then
				goto continue
			end]]
			::checkdone::
	        local posToUse = pPos
	        GET_SCREEN_COORD_FROM_WORLD_COORD(posToUse.x, posToUse.y, posToUse.z + 1, gameX, gameY)
	        local screenX, screenY = memory.read_float(gameX), memory.read_float(gameY)
	        local valuesToDisplay = {}
			if showentitygroupobj then
	            valuesToDisplay[#valuesToDisplay + 1] = "OBJECT"
	        end
			if attachedobj and showattachtoobjobj then
	            valuesToDisplay[#valuesToDisplay + 1] = "Attached to OBJ"
	        end
			if attachedped and showattachtopedobj then
	            valuesToDisplay[#valuesToDisplay + 1] = "Attached to PED"
	        end
			if attachedveh and showattachtovehobj then
	            valuesToDisplay[#valuesToDisplay + 1] = "Attached to VEH"
	        end
			if showDistanceobj then
	            valuesToDisplay[#valuesToDisplay + 1] = math.floor(dist)
	        end
			if shownameobj then
	            local textline = ""
	            if shownameobj then
	                textline = getmodelnamebyhash(modelhash) .. " "
	            end
	            valuesToDisplay[#valuesToDisplay + 1] = textline
	        end
			if missionentityobj and showmissionobj then
				valuesToDisplay[#valuesToDisplay + 1] = "Mission Entity"
			end
			if showownerobj then
				valuesToDisplay[#valuesToDisplay + 1] = "Owner: ".. ownerobj
			end
	        local text = table.concat(valuesToDisplay, "\n")
			if not givedata then
	        	directx.draw_text(screenX + xValueobj, screenY + yValueobj, text, 5, scaleValueobj, colorobj, false)
			end
			if givedata then
				table.insert(data, objshandle)
			end
			::continue::
	    end
		if givedata then
			return data
		end
	end
	
enabledToggleobj = menu.toggle(Entitymanagerespobjects, "Enable ESP Objects", {"ESPobject"}, "", function(on_toggle)
	if on_toggle then
		enabledobj = true
		if deactivateother then
			if menu.get_value(enabledToggleped) then
				menu.set_value(enabledToggleped, false)
			end
			if menu.get_value(enabledToggleveh) then
				menu.set_value(enabledToggleveh, false)
			end
			if menu.get_value(enabledTogglepickup) then
				menu.set_value(enabledTogglepickup, false)
			end
		end
		util.create_tick_handler(renderESPobj)
	else
		enabledobj = false
	end
end)

onlymissionToggleobj = menu.toggle(Entitymanagerespobjects, "Show Only Mission", {}, "", function(on)
	showonlymissionobj = on
end, showonlymissionobj)
showonlymissionobj = menu.get_value(onlymissionToggleobj)
local actionSubmenuobj = menu.list(Entitymanagerespobjects, "Action", {}, "action für die auf dennen ESP drauf ist")
onlyvisibleToggleobj = menu.toggle(actionSubmenuobj, "get only visible OBJ", {}, "", function(on)
	getonlyvisibleobj = on
end, getonlyvisibleobj)
getonlyvisibleobj = menu.get_value(onlyvisibleToggleobj)
menu.action(actionSubmenuobj, "teleport to me", {}, "", function()
	local data = renderESPobj(true)
	if data then
		pPos = players.get_position(players.user())
		for data as entity do
			if entities.request_control(entity, 150) then
				SET_ENTITY_COORDS_NO_OFFSET(entity, pPos.x, pPos.y, pPos.z, false, false, false)
			end
		end
	else
		util.toast("du musst zuerst das ESP an machen dafür")
	end
end)
menu.action(actionSubmenuobj, "Delete", {}, "", function()
	local data = renderESPobj(true)
	if data then
		pPos = players.get_position(players.user())
		for data as entity do
			if entities.request_control(entity, 150) then
				entities.delete(entity)
			end
		end
	else
		util.toast("du musst zuerst das ESP an machen dafür")
	end
end)

local positionSubmenuobj = menu.list(Entitymanagerespobjects, "position", {}, "")
xSliderobj = menu.slider(positionSubmenuobj, "XPos", {}, "", -10, 10, xValueobj, 1, function(val)
	xValueobj = val / 200
end)
--xValue = menu.get_value(xSlider) / 100
ySliderobj = menu.slider(positionSubmenuobj, "YPos", {}, "", -10, 10, yValueobj, 1, function(val)
	yValueobj = val / 200
end)
--yValue = menu.get_value(ySlider) / 100
scaleSliderobj = menu.slider(positionSubmenuobj, "scale", {}, "", 1, 200, scaleValueobj, 1, function(val)
	scaleValueobj = val / 100
end)
scaleValueobj = menu.get_value(scaleSliderobj) / 100
colorRefobj = menu.colour(Entitymanagerespobjects, "color", {}, "", colorobj, true, function(c)
	colorobj = c
end)
maxDistSliderobj = menu.slider(Entitymanagerespobjects, "max Dist", {"setdisobject"}, "", 10, 10000, maxDistanceobj, 10, function(val)
	maxDistanceobj = val
end)
maxDistanceobj = menu.get_value(maxDistSliderobj)

entitygroupToggleobj = menu.toggle(Entitymanagerespobjects, "show Entity Group", {}, "", function(on)
	showentitygroupobj = on
end, showentitygroupobj)
showentitygroupobj = menu.get_value(entitygroupToggleobj)
distToggleobj = menu.toggle(Entitymanagerespobjects, "show Distance", {}, "", function(on)
	showDistanceobj = on
end, showDistanceobj)
showDistanceobj = menu.get_value(distToggleobj)
nametoggleobj = menu.toggle(Entitymanagerespobjects, "show Name", {}, "", function(on)
	shownameobj = on
end, shownameobj)
shownameobj = menu.get_value(nametoggleobj)
missiontoggleobj = menu.toggle(Entitymanagerespobjects, "show Mission Entity", {}, "", function(on)
	showmissionobj = on
end, showmissionobj)
showmissionobj = menu.get_value(missiontoggleobj)
ownertoggleobj = menu.toggle(Entitymanagerespobjects, "show Owner", {}, "", function(on)
	showownerobj = on
end, showownerobj)
showownerobj = menu.get_value(ownertoggleobj)
attachtoobjtoggleobj = menu.toggle(Entitymanagerespobjects, "show Only Attachted Obj to Obj", {}, "", function(on)
	showattachtoobjobj = on
end, showattachtoobjobj)
showattachtoobjobj = menu.get_value(attachtoobjtoggleobj)
attachtopedtoggleobj = menu.toggle(Entitymanagerespobjects, "show Only Attachted Obj to Ped", {}, "", function(on)
	showattachtopedobj = on
end, showattachtopedobj)
showattachtopedobj = menu.get_value(attachtopedtoggleobj)
attachtovehtoggleobj = menu.toggle(Entitymanagerespobjects, "show Only Attachted Obj to Veh", {}, "", function(on)
	showattachtovehobj = on
end, showattachtovehobj)
showattachtovehobj = menu.get_value(attachtovehtoggleobj)

local enabledpickup, showonlymissionpickup = false, false
local xValuepickup, yValuepickup, scaleValuepickup = 0, 0, 35
local colorpickup = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 }
local maxDistancepickup = 1000
local showDistancepickup, shownamepickup, showmissionpickup, showownerpickup, showentitiygrouppickup, getonlyvisiblepickups = true, true, true, true, true, false

	function renderESPpickup(givedata)
		if not enabledpickup then
	        return false
	    end
		if not util.is_session_started() or IS_PAUSE_MENU_ACTIVE() then
			return
		end
		local data = {}
		local gameX, gameY = memory.alloc(1), memory.alloc(1)
	    local myPed = players.user_ped()
	    local myPos = players.get_position(players.user())
	    for _, pickups in pairs(entities.get_all_pickups_as_pointers()) do
			local pickupshandle = entities.pointer_to_handle(pickups)
	        if not IS_ENTITY_ON_SCREEN(pickupshandle) and getonlyvisiblepickups then
	            goto continue
	        end
			local modelhash = entities.get_model_hash(pickups)
	        local pPos = entities.get_position(pickups)
	        local dist = myPos:distance(pPos)
			local ownerpickup = players.get_name(entities.get_owner(pickupshandle))
			local missionentitypickup = IS_ENTITY_A_MISSION_ENTITY(pickupshandle)
	        if (dist > maxDistancepickup) then
	            goto continue
	        end
			if (not missionentitypickup) and showonlymissionpickup then
				goto continue
			end
	        local posToUse = pPos
	        GET_SCREEN_COORD_FROM_WORLD_COORD(posToUse.x, posToUse.y, posToUse.z + 1, gameX, gameY)
	        local screenX, screenY = memory.read_float(gameX), memory.read_float(gameY)
	        local valuesToDisplay = {}
			if showentitiygrouppickup then
	            valuesToDisplay[#valuesToDisplay + 1] = "PICKUP"
	        end
			if showDistancepickup then
	            valuesToDisplay[#valuesToDisplay + 1] = math.floor(dist)
	        end
			if shownamepickup then
	            local textline = ""
	            if shownamepickup then
	                textline = getmodelnamebyhash(modelhash) .. " "
	            end
	            valuesToDisplay[#valuesToDisplay + 1] = textline
	        end
			if missionentitypickup and showmissionpickup then
				valuesToDisplay[#valuesToDisplay + 1] = "Mission Entity"
			end
			if showownerpickup then
				valuesToDisplay[#valuesToDisplay + 1] = "Owner: ".. ownerpickup
			end
	        local text = table.concat(valuesToDisplay, "\n")
			if not givedata then
	       		directx.draw_text(screenX + xValuepickup, screenY + yValuepickup, text, 5, scaleValuepickup, colorpickup, false)
			end
			if givedata then
				table.insert(data, pickupshandle)
			end
			::continue::
		end
		if givedata then
			return data
		end
	end
	
enabledTogglepickup = menu.toggle(Entitymanageresppickups, "Enable ESP Pickups", {"ESPpickup"}, "", function(on_toggle)
	if on_toggle then
		enabledpickup = true
		if deactivateother then
			if menu.get_value(enabledToggleped) then
				menu.set_value(enabledToggleped, false)
			end
			if menu.get_value(enabledToggleobj) then
				menu.set_value(enabledToggleobj, false)
			end
			if menu.get_value(enabledToggleveh) then
				menu.set_value(enabledToggleveh, false)
			end
		end
		util.create_tick_handler(renderESPpickup)
	else
		enabledpickup = false
	end
end)

onlymissionTogglepickup = menu.toggle(Entitymanageresppickups, "Show Only Mission", {}, "", function(on)
	showonlymissionpickup = on
end, showonlymissionpickup)
showonlymissionpickup = menu.get_value(onlymissionTogglepickup)

local actionSubmenupickups = menu.list(Entitymanageresppickups, "Action", {}, "action für die auf dennen ESP drauf ist")
onlyvisibleTogglepickups = menu.toggle(actionSubmenupickups, "get only visible vehs", {}, "", function(on)
	getonlyvisiblepickups = on
end, getonlyvisiblepickups)
getonlyvisiblepickups = menu.get_value(onlyvisibleTogglepickups)
menu.action(actionSubmenupickups, "teleport to me", {}, "", function()
	local data = renderESPpickup(true)
	if data then
		pPos = players.get_position(players.user())
		for data as entity do
			if entities.request_control(entity, 150) then
				SET_ENTITY_COORDS(entity, pPos.x, pPos.y, pPos.z)
			end
		end
	else
		util.toast("du musst zuerst das ESP an machen dafür")
	end
end)
menu.action(actionSubmenupickups, "Delete", {}, "", function()
	local data = renderESPpickup(true)
	if data then
		for data as entity do
			if entities.request_control(entity, 150) then
				entities.delete(entity)
			end
		end
	else
		util.toast("du musst zuerst das ESP an machen dafür")
	end
end)

local positionSubmenupickup = menu.list(Entitymanageresppickups, "position", {}, "")
xSliderpickup = menu.slider(positionSubmenupickup, "XPos", {}, "", -10, 10, xValuepickup, 1, function(val)
	xValuepickup = val / 200
end)
--xValue = menu.get_value(xSlider) / 100
ySliderpickup = menu.slider(positionSubmenupickup, "YPos", {}, "", -10, 10, yValuepickup, 1, function(val)
	yValuepickup = val / 200
end)
--yValue = menu.get_value(ySlider) / 100
scaleSliderpickup = menu.slider(positionSubmenupickup, "scale", {}, "", 1, 200, scaleValuepickup, 1, function(val)
	scaleValuepickup = val / 100
end)
scaleValuepickup = menu.get_value(scaleSliderpickup) / 100

colorRefpickup = menu.colour(Entitymanageresppickups, "color", {}, "", colorpickup, true, function(c)
	colorpickup = c
end)

maxDistSliderpickup = menu.slider(Entitymanageresppickups, "max Dist", {"setdispickup"}, "", 10, 10000, maxDistancepickup, 10, function(val)
	maxDistancepickup = val
end)
maxDistancepickup = menu.get_value(maxDistSliderpickup)

entitygroupTogglepickup = menu.toggle(Entitymanageresppickups, "show Entity Group", {}, "", function(on)
	showentitiygrouppickup = on
end, showentitiygrouppickup)
showentitiygrouppickup = menu.get_value(entitygroupTogglepickup)
distTogglepickup = menu.toggle(Entitymanageresppickups, "show Distance", {}, "", function(on)
	showDistancepickup = on
end, showDistancepickup)
showDistancepickup = menu.get_value(distTogglepickup)
nametogglepickup = menu.toggle(Entitymanageresppickups, "show Name", {}, "", function(on)
	shownamepickup = on
end, shownamepickup)
shownamepickup = menu.get_value(nametogglepickup)
missiontogglepickup = menu.toggle(Entitymanageresppickups, "show Mission Entity", {}, "", function(on)
	showmissionpickup = on
end, showmissionpickup)
showmissionpickup = menu.get_value(missiontogglepickup)
ownertogglepickup = menu.toggle(Entitymanageresppickups, "show Owner", {}, "", function(on)
	showownerpickup = on
end, showownerpickup)
showownerpickup = menu.get_value(ownertogglepickup)



maxDistancenearentitys = 200
onlymissionnearentitys, showplayersnearentitys, showonlyblibsnearentitys, switchsearchnearentitys, 
showdebugginfosnearentitys, showarsignalnearentitys, 
infosearchnearentitys, removeattachobjnearentitys, showlinenearentitys, showboxnearentitys = false, true, false, false, true, true, false, false, true, true
local seattable = {}
local seatzaehlerofseats = 0
local numberfunctioninlist = 0
local boostvaluetoboostnearentitys = 100

rot = {x = 0, y = 0, z = 0}
dimensions = {x = 1, y = 1, z = 1.5}

local vehicledata = {}
local pedsdata = {}
local objectsdata = {}
local pickupdata = {}
local searchnearveh = ""
local searchnearpeds = ""
local searchnearobjects = ""
local searchnearpickups = ""
local Entitymanagernearvehiclevehicles = menu.list(Entitymanagernearvehicle, "vehicles", {}, "", function(on_click)
	enablednearvehicle  = true
	util.create_tick_handler(getnearvehicle)
end, function(on_back)
	enablednearvehicle  = false
end)
local Entitymanagernearvehiclepeds = menu.list(Entitymanagernearvehicle, "Peds", {}, "", function(on_click)
	enablednearpeds  = true
	util.create_tick_handler(getnearpeds)
end, function(on_back)
	enablednearpeds  = false
end)
local Entitymanagernearvehicleobjects = menu.list(Entitymanagernearvehicle, "Objects", {}, "", function(on_click)
	enablednearobjects  = true
	util.create_tick_handler(getnearobjects)
end, function(on_back)
	enablednearobjects  = false
end)
local Entitymanagernearvehiclepickup = menu.list(Entitymanagernearvehicle, "Pickups", {}, "", function(on_click)
	enablednearpickups  = true
	util.create_tick_handler(getnearpickup)
end, function(on_back)
	enablednearpickups  = false
end)


searchnearentitysveh = menu.text_input(Entitymanagernearvehiclevehicles, "Search", {"Searchnearveh"}, "", function(input)
	searchnearveh = input
	if not searchnearveh ~= number then
		searchnearveh = searchnearveh:lower()
	end
	menu.set_help_text(searchnearentitysveh ,"Last Input: "..input)
	if string.len(input) > 0 then
		menu.set_menu_name(searchnearentitysveh ,"Search Aktive")
	else
		menu.set_menu_name(searchnearentitysveh ,"Search")
		for vehicledata as vehhandle do
			if menu.is_ref_valid(veh[vehhandle]) then
				menu.delete(veh[vehhandle])
				tableremove(vehicledata, vehhandle)
			end
		end
	end
	menu.set_value(searchnearentitysveh, "")
end)
searchnearentityspeds = menu.text_input(Entitymanagernearvehiclepeds, "Search", {"Searchnearpeds"}, "", function(input)
	searchnearpeds = input
	if not searchnearpeds ~= number then
		searchnearpeds = searchnearpeds:lower()
	end
	menu.set_help_text(searchnearentityspeds ,"Last Input: "..input)
	if string.len(input) > 0 then
		menu.set_menu_name(searchnearentityspeds ,"Search Aktive")
	else
		menu.set_menu_name(searchnearentityspeds ,"Search")
		for pedsdata as vehhandle do
			if menu.is_ref_valid(veh[vehhandle]) then
				menu.delete(veh[vehhandle])
				tableremove(pedsdata, vehhandle)
			end
		end
	end
	menu.set_value(searchnearentityspeds, "")
end)
searchnearentitysobj = menu.text_input(Entitymanagernearvehicleobjects, "Search", {"Searchnearobjects"}, "", function(input)
	searchnearobjects = input
	if not searchnearobjects ~= number then
		searchnearobjects = searchnearobjects:lower()
	end
	menu.set_help_text(searchnearentitysobj ,"Last Input: "..input)
	if string.len(input) > 0 then
		menu.set_menu_name(searchnearentitysobj ,"Search Aktive")
	else
		menu.set_menu_name(searchnearentitysobj ,"Search")
		for objectsdata as vehhandle do
			if menu.is_ref_valid(veh[vehhandle]) then
				menu.delete(veh[vehhandle])
				tableremove(objectsdata, vehhandle)
			end
		end
	end
	menu.set_value(searchnearentitysobj, "")
end)
searchnearentityspickup = menu.text_input(Entitymanagernearvehiclepickup, "Search", {"Searchnearpickups"}, "", function(input)
	searchnearpickups = input
	if not searchnearpickups ~= number then
		searchnearpickups = searchnearpickups:lower()
	end
	menu.set_help_text(searchnearentityspickup ,"Last Input: "..input)
	if string.len(input) > 0 then
		menu.set_menu_name(searchnearentityspickup ,"Search Aktive")
	else
		menu.set_menu_name(searchnearentityspickup ,"Search")
		for pickupdata as vehhandle do
			if menu.is_ref_valid(veh[vehhandle]) then
				menu.delete(veh[vehhandle])
				tableremove(pickupdata, vehhandle)
			end
		end
	end
	menu.set_value(searchnearentityspickup, "")
end)

Entitymanagernearvehicleallveh = menu.list(Entitymanagernearvehiclevehicles, "Action for all Vehicle", {}, "", function(on_click)
	loadboxonallent = true
end, function(on_back)
	loadboxonallent = false
end)
menu.action(Entitymanagernearvehicleallveh, "Teleport to me", {}, "", function()
	for vehicledata as vehhandle do
		local ent_ptr = memory.alloc_int()
		memory.write_int(ent_ptr, vehhandle)
		local mypos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +6, 0)
		if getcontrole(vehhandle) then
			SET_VEHICLE_FORWARD_SPEED(vehhandle, 0)
			SET_ENTITY_AS_MISSION_ENTITY(vehhandle)
			SET_ENTITY_COORDS_NO_OFFSET(vehhandle, mypos.x, mypos.y, mypos.z, false, false, false)
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)
menu.divider(Entitymanagernearvehicleallveh, "Trolling")
menu.action(Entitymanagernearvehicleallveh, "Explode", {}, "", function()
	for vehicledata as vehhandle do
		local ePos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehhandle, 0, 0, 0)
		if ePos.x == 0 or ePos.y == 0 then
			goto end
		end
		local canbedamaged = entities.is_invulnerable(vehhandle)
		ADD_EXPLOSION(ePos.x, ePos.y, ePos.z, 5, 1000, true, false, 0.0, false)
		if GET_VEHICLE_ENGINE_HEALTH(vehhandle) > 0 and not canbedamaged then
			repeat
				util.yield()
				ePos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehhandle, 0, 0, 0)
				if ePos.x == 0 or ePos.y == 0 or (not DOES_ENTITY_EXIST(vehhandle)) then
					break
				end
				ADD_EXPLOSION(ePos.x, ePos.y, ePos.z, 5, 1000, true, false, 0.0, false)
				vehiclehealth = GET_VEHICLE_ENGINE_HEALTH(vehhandle)
				vehiclebodyhealth = GET_VEHICLE_BODY_HEALTH(vehhandle)
				--timer += 1
			until vehiclehealth < 0 or vehiclebodyhealth < 1 --or timer > 250
		end
		::end::
		--if getcontrole(vehhandle) then
		--	ADD_EXPLOSION(ePos.x, ePos.y, ePos.z, 2, 1, true, false, 0.0, false)
		--else
		--	util.toast("konnte keine kontrolle bekommen")
		--end
	end
end)
menu.action(Entitymanagernearvehicleallveh, "Delete", {}, "", function()
	for vehicledata as vehhandle do
			entities.delete(vehhandle)
	end
end)
menu.textslider_stateful(Entitymanagernearvehicleallveh, "Boost", {}, "", {"Forward", "Right", "Left","Up","Down", "Back"}, function(index)
	for vehicledata as vehhandle do
		if index == 1 then
			if getcontrole(vehhandle) then
				APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(vehhandle, 1, 0.0, boostvaluetoboostnearentitys, 0.0, true, true, true, true)
			end
		elseif index == 2 then
			if getcontrole(vehhandle) then
				APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(vehhandle, 1, boostvaluetoboostnearentitys, 0.0, 0.0, true, true, true, true)
			end
		elseif index == 3 then
			if getcontrole(vehhandle) then
				APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(vehhandle, 1, -boostvaluetoboostnearentitys, 0.0, 0.0, true, true, true, true)
			end
		elseif index == 4 then
			if getcontrole(vehhandle) then
				APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(vehhandle, 1, 0.0, 0.0, boostvaluetoboostnearentitys, true, true, true, true)
			end
		elseif index == 5 then
			if getcontrole(vehhandle) then
				APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(vehhandle, 1, 0.0, 0.0, -boostvaluetoboostnearentitys, true, true, true, true)
			end
		elseif index == 6 then
			if getcontrole(vehhandle) then
				APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(vehhandle, 1, 0.0, -boostvaluetoboostnearentitys, 0.0, true, true, true, true)
			end
		end
	end
end)
menu.action(Entitymanagernearvehicleallveh, "Freeze ON", {}, "", function()
	for vehicledata as vehhandle do
		if getcontrole(vehhandle) then
			FREEZE_ENTITY_POSITION(vehhandle, true)
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)
menu.action(Entitymanagernearvehicleallveh, "Freeze OFF", {}, "", function()
	for vehicledata as vehhandle do
		if getcontrole(vehhandle) then
			FREEZE_ENTITY_POSITION(vehhandle, false)
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)
menu.action(Entitymanagernearvehicleallveh, "Kick Peds of Vehicle", {}, "", function()
	for vehicledata as vehhandle do
		local pedsinveh = getpedsinvehicle(vehhandle)
		if pedsinveh != 0 then
			for pedsinveh as pedsinveh1 do
				if not IS_PED_A_PLAYER(pedsinveh1) then
					if getcontrole(pedsinveh1) and getcontrole(vehhandle) then
						TASK_LEAVE_VEHICLE(pedsinveh1, vehhandle, 16)
						CLEAR_PED_TASKS_IMMEDIATELY(pedsinveh1)
					end
				end
			end
		end
	end
end)
menu.action(Entitymanagernearvehicleallveh, "Delete Peds of Vehicle", {}, "", function()
	for vehicledata as vehhandle do
		local pedsinveh = getpedsinvehicle(vehhandle)
		if pedsinveh != 0 then
			for pedsinveh as pedsinveh1 do
				if not IS_PED_A_PLAYER(pedsinveh1) then
					entities.delete(pedsinveh1)
				end
			end
		end
	end
end)
menu.action(Entitymanagernearvehicleallveh, "Remove wheels", {}, "", function()
	for vehicledata as vehhandle do
		if getcontrole(vehhandle) then
			for i=0, 7 do
				SET_VEHICLE_TYRE_BURST(vehhandle, i, true, 0)
				entities.detach_wheel(vehhandle, i)
			end
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)
menu.divider(Entitymanagernearvehicleallveh, "Friendly")
menu.action(Entitymanagernearvehicleallveh, "Give Godmode", {}, "", function()
	for vehicledata as vehhandle do
		local vehpointer = entities.handle_to_pointer(vehhandle)
		local ePos = entities.get_position(vehpointer)
		if getcontrole(vehhandle) then
			SET_ENTITY_INVINCIBLE(vehhandle, true)
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)
menu.action(Entitymanagernearvehicleallveh, "Remove Godmode", {}, "", function()
	for vehicledata as vehhandle do
		local vehpointer = entities.handle_to_pointer(vehhandle)
		local ePos = entities.get_position(vehpointer)
		if getcontrole(vehhandle) then
			SET_ENTITY_INVINCIBLE(vehhandle, false)
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)
menu.action(Entitymanagernearvehicleallveh, "Repair", {}, "", function()
	for vehicledata as vehhandle do
		if getcontrole(vehhandle) then
			STOP_ENTITY_FIRE(vehhandle)
			SET_VEHICLE_FIXED(vehhandle)
			SET_VEHICLE_DIRT_LEVEL(vehhandle, 0)
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)
menu.list_action(Entitymanagernearvehicleallveh, "Upgrade", {}, "", {"full", "random", "down"}, function(index)
	for vehicledata as vehhandle do
		if index == 1 then
			upgrade_vehicle(vehhandle)
		elseif index == 2 then
			randomupgrade_vehicle(vehhandle)
		elseif index == 3 then
			downggrade_vehicle(vehhandle)
		end
	end
end)
menu.divider(Entitymanagernearvehicleallveh, "Misc")
local savingvehrunning = false
menu.text_input(Entitymanagernearvehicleallveh, "Save vehicle / adds number to it", {"saveallveh"}, "", function(input)
	local numbertoadd = 0
	local mypos = players.get_position(players.user())
	local wasinveh = IS_PED_IN_ANY_VEHICLE(players.user_ped())
	local vehicleofped = GET_VEHICLE_PED_IS_IN(players.user_ped())
	local seatofplayer = getseatofplayer(vehicleofped)
	for _, vehhandle in pairs(vehicledata) do
		local modelname = getmodelnamebyhash(entities.get_model_hash(vehhandle))
		savingvehrunning = true
		freeseat = getfreevehseat(vehhandle)
		if GET_VEHICLE_PED_IS_IN(players.user_ped()) == vehhandle then
			numbertoadd += 1
			menu.trigger_commands("savevehicle "..input.." ".. numbertoadd)
			util.toast("VEH: ".. modelname.. " Saved as ".. input.." ".. numbertoadd)
			goto end
		end
			if freeseat then
				SET_PED_INTO_VEHICLE(players.user_ped(), vehhandle, freeseat)
				util.yield(20)
				numbertoadd += 1
				menu.trigger_commands("savevehicle "..input.." ".. numbertoadd)
				util.toast("VEH: ".. modelname.. " Saved as ".. input.." ".. numbertoadd)
				util.yield(10)
			else
				util.toast(modelname.. " Ist voll es wird übersprungen")
			end
		::end::
	end
	savingvehrunning = false
	if wasinveh then
		if DOES_ENTITY_EXIST(vehicleofped) then
			if vehicleofped == GET_VEHICLE_PED_IS_IN(players.user_ped()) then
				goto stopprocess
			end
			if IS_VEHICLE_SEAT_FREE(vehicleofped, seatofplayer, false) then
				SET_PED_INTO_VEHICLE(players.user_ped(), vehicleofped, seatofplayer)
			else
				getfreesetincar = getfreevehseat(vehicleofped)
				if getfreesetincar then
					SET_PED_INTO_VEHICLE(players.user_ped(), vehicleofped, getfreesetincar)
				else
					SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), mypos, false, false, false)
				end
			end
		end
	else
		SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), mypos, false, false, false)
	end
	::stopprocess::
	menu.set_value(menu.ref_by_command_name("saveallveh"), "")
end)
menu.action(Entitymanagernearvehicleallveh, "Set vehicle as mission Entity", {}, "setzt das vehicle als mission entity kann also nicht einfach so despawnen", function()
	for vehicledata as vehhandle do
		if getcontrole(vehhandle) then
			SET_ENTITY_AS_MISSION_ENTITY(vehhandle)
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)
menu.action(Entitymanagernearvehicleallveh, "Set Vehicle as no longer needed", {}, "setzt das Vehicle einfach auf ein normal enitity das despawned wenn du weg gehst\nz.b. bei teleport to me werden die entitys als missions entitiy gesetzt", function()
	for vehicledata as vehhandle do
		local ent_ptr = memory.alloc_int()
		memory.write_int(ent_ptr, vehhandle)
		if getcontrole(vehhandle) then
			SET_ENTITY_AS_NO_LONGER_NEEDED(ent_ptr)
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)

Entitymanagernearvehicleallpeds = menu.list(Entitymanagernearvehiclepeds, "Action for all Peds", {}, "", function(on_click)
	loadboxonallent = true
end, function(on_back)
	loadboxonallent = false
end)
menu.action(Entitymanagernearvehicleallpeds, "Teleport to me", {}, "", function()
	for pedsdata as vehhandle do
		local mypos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +2, 0)
		if getcontrole(vehhandle) then
			--SET_ENTITY_AS_MISSION_ENTITY(vehhandle)
			SET_ENTITY_COORDS_NO_OFFSET(vehhandle, mypos.x, mypos.y, mypos.z, false, false, false)
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)
menu.divider(Entitymanagernearvehicleallpeds, "Trolling")
menu.action(Entitymanagernearvehicleallpeds, "Delete", {}, "", function()
	for pedsdata as vehhandle do
			entities.delete(vehhandle)
	end
end)
menu.textslider_stateful(Entitymanagernearvehicleallpeds, "Boost", {}, "", {"Forward", "Right", "Left","Up","Down", "Back"}, function(index)
	for pedsdata as vehhandle do
		if index == 1 then
			if getcontrole(vehhandle) then
				APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(vehhandle, 1, 0.0, boostvaluetoboostnearentitys, 0.0, true, true, true, true)
			end
		elseif index == 2 then
			if getcontrole(vehhandle) then
				APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(vehhandle, 1, boostvaluetoboostnearentitys, 0.0, 0.0, true, true, true, true)
			end
		elseif index == 3 then
			if getcontrole(vehhandle) then
				APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(vehhandle, 1, -boostvaluetoboostnearentitys, 0.0, 0.0, true, true, true, true)
			end
		elseif index == 4 then
			if getcontrole(vehhandle) then
				APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(vehhandle, 1, 0.0, 0.0, boostvaluetoboostnearentitys, true, true, true, true)
			end
		elseif index == 5 then
			if getcontrole(vehhandle) then
				APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(vehhandle, 1, 0.0, 0.0, -boostvaluetoboostnearentitys, true, true, true, true)
			end
		elseif index == 6 then
			if getcontrole(vehhandle) then
				APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(vehhandle, 1, 0.0, -boostvaluetoboostnearentitys, 0.0, true, true, true, true)
			end
		end
	end
end)
menu.action(Entitymanagernearvehicleallpeds, "Explode", {}, "", function()
	for pedsdata as vehhandle do
		local vehpointer = entities.handle_to_pointer(vehhandle)
		local ePos = entities.get_position(vehpointer)
		--if getcontrole(vehhandle) then
		if IS_PED_IN_ANY_VEHICLE(vehhandle) then CLEAR_PED_TASKS_IMMEDIATELY(vehhandle) end
			ADD_EXPLOSION(ePos.x, ePos.y, ePos.z, 5, 100, true, false, 0.0, false)
			SET_ENTITY_HEALTH(vehhandle, 0, 0)
			FORCE_PED_MOTION_STATE(vehhandle, 0x0DBB071C, 0,0,0)
		--else
		--	util.toast("konnte keine kontrolle bekommen")
		--end
	end
end)
menu.action(Entitymanagernearvehicleallpeds, "Kill", {}, "", function()
	for pedsdata as vehhandle do
		local vehpointer = entities.handle_to_pointer(vehhandle)
		local ePos = entities.get_position(vehpointer)
		if getcontrole(vehhandle) then
			SET_ENTITY_HEALTH(vehhandle, 0, 0)
			FORCE_PED_MOTION_STATE(vehhandle, 0x0DBB071C, 0,0,0)
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)
menu.action(Entitymanagernearvehicleallpeds, "Shoot", {}, "", function()
	for pedsdata as vehhandle do
		local vehpointer = entities.handle_to_pointer(vehhandle)
		local ePos = entities.get_position(vehpointer)
		if GET_VEHICLE_PED_IS_USING(vehhandle) ~= 0 then CLEAR_PED_TASKS_IMMEDIATELY(vehhandle) end
		local PedPos = GET_ENTITY_COORDS(vehhandle)
		local AddPos = GET_ENTITY_COORDS(vehhandle)
		AddPos.z = AddPos.z + 1
		SHOOT_SINGLE_BULLET_BETWEEN_COORDS(AddPos.x, AddPos.y, AddPos.z, PedPos.x, PedPos.y, PedPos.z, 1000, false, 0xC472FE2, players.user_ped(), false, true, 1000)
	end
end)
menu.action(Entitymanagernearvehicleallpeds, "Freeze ON", {}, "", function()
	for pedsdata as vehhandle do
		local vehpointer = entities.handle_to_pointer(vehhandle)
		local ePos = entities.get_position(vehpointer)
		if getcontrole(vehhandle) then
			FREEZE_ENTITY_POSITION(vehhandle, true)
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)
menu.action(Entitymanagernearvehicleallpeds, "Freeze OFF", {}, "", function()
	for pedsdata as vehhandle do
		local vehpointer = entities.handle_to_pointer(vehhandle)
		local ePos = entities.get_position(vehpointer)
		if getcontrole(vehhandle) then
			FREEZE_ENTITY_POSITION(vehhandle, false)
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)
menu.action(Entitymanagernearvehicleallpeds, "Remove weapons", {}, "", function()
	for pedsdata as vehhandle do
		local vehpointer = entities.handle_to_pointer(vehhandle)
		local ePos = entities.get_position(vehpointer)
		if getcontrole(vehhandle) then
			REMOVE_ALL_PED_WEAPONS(vehhandle, false)
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)
menu.divider(Entitymanagernearvehicleallpeds, "Friendly")
menu.action(Entitymanagernearvehicleallpeds, "Heal/Revive", {}, "", function()
	for pedsdata as vehhandle do
		local vehpointer = entities.handle_to_pointer(vehhandle)
		local ePos = entities.get_position(vehpointer)
		local ispeddead = IS_PED_DEAD_OR_DYING(vehhandle)
		if getcontrole(vehhandle) then
			maxhealth = GET_PED_MAX_HEALTH(vehhandle)
			SET_ENTITY_HEALTH(vehhandle, maxhealth, 0)
			STOP_ENTITY_FIRE(vehhandle)
			if ispeddead then
				CLEAR_PED_TASKS_IMMEDIATELY(vehhandle)
			end
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)
menu.action(Entitymanagernearvehicleallpeds, "Give Godmode", {}, "", function()
	for pedsdata as vehhandle do
		local vehpointer = entities.handle_to_pointer(vehhandle)
		local ePos = entities.get_position(vehpointer)
		if getcontrole(vehhandle) then
			SET_ENTITY_INVINCIBLE(vehhandle, true)
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)
menu.action(Entitymanagernearvehicleallpeds, "Remove Godmode", {}, "", function()
	for pedsdata as vehhandle do
		local vehpointer = entities.handle_to_pointer(vehhandle)
		local ePos = entities.get_position(vehpointer)
		if getcontrole(vehhandle) then
			SET_ENTITY_INVINCIBLE(vehhandle, false)
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)
menu.divider(Entitymanagernearvehicleallpeds, "Misc")
menu.action(Entitymanagernearvehicleallpeds, "Clear Tasks", {}, "", function()
	for pedsdata as vehhandle do
		if getcontrole(vehhandle) then
			CLEAR_PED_TASKS_IMMEDIATELY(vehhandle)
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)
menu.action(Entitymanagernearvehicleallpeds, "Set PED as mission Entity", {}, "setzt das PED als mission entity kann also nicht einfach so despawnen", function()
	for pedsdata as vehhandle do
		if getcontrole(vehhandle) then
			SET_ENTITY_AS_MISSION_ENTITY(vehhandle)
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)
menu.action(Entitymanagernearvehicleallpeds, "Set PED as no longer needed", {}, "setzt das PED einfach auf ein normal enitity das despawned wenn du weg gehst", function()
	for pedsdata as vehhandle do
		local ent_ptr = memory.alloc_int()
		memory.write_int(ent_ptr, vehhandle)
		if getcontrole(vehhandle) then
			SET_ENTITY_AS_NO_LONGER_NEEDED(ent_ptr)
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)

Entitymanagernearvehicleallobjects = menu.list(Entitymanagernearvehicleobjects, "Action for all Objects", {}, "", function(on_click)
	loadboxonallent = true
end, function(on_back)
	loadboxonallent = false
end)
menu.action(Entitymanagernearvehicleallobjects, "Teleport to me", {}, "", function()
	for objectsdata as vehhandle do
		local mypos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +2, 0)
		if getcontrole(vehhandle) then
			SET_ENTITY_COORDS_NO_OFFSET(vehhandle, mypos.x, mypos.y, mypos.z, false, false, false)
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)
menu.action(Entitymanagernearvehicleallobjects, "Delete", {}, "", function()
	for objectsdata as vehhandle do
			entities.delete(vehhandle)
	end
end)
menu.action(Entitymanagernearvehicleallobjects, "Explode", {}, "", function()
	for objectsdata as vehhandle do
		util.yield(5)
		local ePos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehhandle, 0, 0, 0)
		ADD_EXPLOSION(ePos.x, ePos.y, ePos.z, 5, 100, true, false, 0.0, false)
	end
end)
menu.divider(Entitymanagernearvehicleallobjects, "misc")
menu.action(Entitymanagernearvehicleallobjects, "Set Object as mission Entity", {}, "setzt das Object als mission entity kann also nicht einfach so despawnen", function()
	for objectsdata as vehhandle do
		if getcontrole(vehhandle) then
			SET_ENTITY_AS_MISSION_ENTITY(vehhandle)
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)
menu.action(Entitymanagernearvehicleallobjects, "Set Object as no longer needed", {}, "setzt das Object einfach auf ein normal enitity das despawned wenn du weg gehst", function()
	for objectsdata as vehhandle do
		local ent_ptr = memory.alloc_int()
		memory.write_int(ent_ptr, vehhandle)
		if getcontrole(vehhandle) then
			SET_ENTITY_AS_NO_LONGER_NEEDED(ent_ptr)
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)

Entitymanagernearvehicleallpickups = menu.list(Entitymanagernearvehiclepickup, "Action for all Pickups", {}, "", function(on_click)
	loadboxonallent = true
end, function(on_back)
	loadboxonallent = false
end)
menu.action(Entitymanagernearvehicleallpickups, "Teleport to me", {}, "", function()
	for pickupdata as vehhandle do
		local mypos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +2, 0)
		if getcontrole(vehhandle) then
			SET_ENTITY_COORDS_NO_OFFSET(vehhandle, mypos.x, mypos.y, mypos.z, false, false, false)
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)
menu.action(Entitymanagernearvehicleallpickups, "Delete", {}, "", function()
	for pickupdata as vehhandle do
			entities.delete(vehhandle)
	end
end)
menu.divider(Entitymanagernearvehicleallpickups, "misc")
menu.action(Entitymanagernearvehicleallpickups, "Set Pickup as mission Entity", {}, "setzt das Pickup als mission entity kann also nicht einfach so despawnen", function()
	for pickupdata as vehhandle do
		if getcontrole(vehhandle) then
			SET_ENTITY_AS_MISSION_ENTITY(vehhandle)
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)
menu.action(Entitymanagernearvehicleallpickups, "Set Pickup as no longer needed", {}, "setzt das Pickup einfach auf ein normal enitity das despawned wenn du weg gehst", function()
	for pickupdata as vehhandle do
		local ent_ptr = memory.alloc_int()
		memory.write_int(ent_ptr, vehhandle)
		if getcontrole(vehhandle) then
			SET_ENTITY_AS_NO_LONGER_NEEDED(ent_ptr)
		else
			util.toast("konnte keine kontrolle bekommen")
		end
	end
end)

--[[function nearvehsorter(list)
	local sorterttable = {}
	local sorterttable1 = {}
	local childrenoflist = menu.get_children(list)
	for _, commandref in pairs(childrenoflist) do
		if _ < 2 then
			goto end
		end
		local dist = string.strip(menu.get_menu_name(commandref), "[]")
		table.insert(sorterttable, {commandref=commandref, distance=dist})
	::end::
	end
	table.sort(sorterttable, function(a, b) return a.distance > b.distance end)
	for _, commandref1 in pairs(sorterttable) do
		local newcommandref = menu.detach(commandref1.commandref)
		table.insert(sorterttable1, newcommandref)
	end
	for _, commandref1 in pairs(sorterttable1) do
		local commandref = commandref1
		--local commandref1 = menu.detach(commandref1.commandref)
		--if _ == 1 then
			menu.attach(Entitymanagernearvehiclevehicles, commandref)
			--menu.attach_after(commandref, Entitymanagernearvehicleallveh)
		--[[else
			for i, commandref2 in pairs(sorterttable) do
				if i < getindex and i > getindex1 then
					commandrefend = commandref2.commandref
					menu.attach(Entitymanagernearvehicleallveh, menu.detach(menu.replace(commandref, menu.detach(commandrefend))))
					--menu.attach_after(commandref, menu.detach(commandrefend))
				end
			end
		end
	end
end]]

local isinfocusthemenu

function getnearvehicle()
	if not enablednearvehicle then
		for vehicledata as vehhandle do
			if menu.is_ref_valid(veh[vehhandle]) then
				menu.delete(veh[vehhandle])
			end
		end
		vehicledata = {}
		return false
	end
	--if not menu.is_open() then
	--	return
	--end
	if util.is_session_transition_active() then
		return
	end
	if savingvehrunning then
		return
	end
	local allpointer = entities.get_all_vehicles_as_pointers()
	for _, vehpointer in pairs(allpointer) do
		local vehhandle = entities.pointer_to_handle(vehpointer)
		local modelhash = entities.get_model_hash(vehhandle)
		local pPos = players.get_position(players.user())
		local ePos = entities.get_position(vehpointer)
		local dist = math.floor(pPos:distance(ePos))
		local modelname = getmodelnamebyhash(modelhash)
		local infodist = pPos:distance(ePos)
		local ismissionentity = IS_ENTITY_A_MISSION_ENTITY(vehhandle)
		local vehicleclassbyhandle = tables.classes[GET_VEHICLE_CLASS(vehhandle)]
		local textline = modelname.. "  [".. dist.. "]"
		local infotextline = modelname.. " {"..vehicleclassbyhandle.."}\nDist: ".. dist
		local createmenus = true
		if onlymissionnearentitys and not ismissionentity then
			goto continue
		end
		if dist > maxDistancenearentitys then
			goto continue
		end
		if showonlyblibsnearentitys and (GET_BLIP_FROM_ENTITY(vehhandle) == 0) then
			goto continue
		end
		infotextline = infotextline.. "\nEngineHealth: ".. math.floor(GET_VEHICLE_ENGINE_HEALTH(vehhandle))
		if not IS_ENTITY_VISIBLE(vehhandle) then
			infotextline = infotextline..  "\nInVisible: TRUE"
		else
			infotextline = infotextline.. "\nInVisible: FALSE"
		end
		if entities.is_invulnerable(vehhandle) then --not GET_ENTITY_CAN_BE_DAMAGED(vehhandle) or GET_ENTITY_PROOFS(vehhandle, true,true,true,true,true,true,true,true) then
			infotextline = infotextline..  "\nGOD: true"
		else
			infotextline = infotextline.. "\nGOD: false"
		end
		infotextline = infotextline.. "\nOwner: ".. players.get_name(entities.get_owner(vehhandle))
		infotextline = infotextline.. "\nMission Entity: ".. IS_ENTITY_A_MISSION_ENTITY(vehhandle)
		local passangersinveh = ""
		local pedsinveh = getpedsinvehicle(vehhandle)
		if not IS_VEHICLE_SEAT_FREE(vehhandle, -1, false) then
			pedinveh = GET_PED_IN_VEHICLE_SEAT(vehhandle, -1, true)
			if IS_PED_A_PLAYER(pedinveh) then
				if showplayersnearentitys then
					local pidnameofp = players.get_name(NETWORK_GET_PLAYER_INDEX_FROM_PED(pedinveh))
					infotextline = infotextline.. "\nDriver: ".. pidnameofp
					textline = textline .. "  (PL ".. pidnameofp.. ")"
				else
					goto continue
				end
			end
		end
		if not IS_VEHICLE_SEAT_FREE(vehhandle, -1, false) or not IS_VEHICLE_SEAT_FREE(vehhandle, 0, false) or not IS_VEHICLE_SEAT_FREE(vehhandle, 1, false) then
			if IS_PED_A_PLAYER(GET_PED_IN_VEHICLE_SEAT(vehhandle, -1)) or IS_PED_A_PLAYER(GET_PED_IN_VEHICLE_SEAT(vehhandle, 0)) or IS_PED_A_PLAYER(GET_PED_IN_VEHICLE_SEAT(vehhandle, 1)) then
				local maxPassengers = GET_VEHICLE_MAX_NUMBER_OF_PASSENGERS(vehhandle)
				for i = 0, maxPassengers do
		 			if not IS_VEHICLE_SEAT_FREE(vehhandle, i, false) then
						local vehPed = GET_PED_IN_VEHICLE_SEAT(vehhandle, i)
						if IS_PED_A_PLAYER(vehPed) then
							passangersinveh = passangersinveh.. players.get_name(NETWORK_GET_PLAYER_INDEX_FROM_PED(vehPed)) .. ", "
						end
					end
	 			end
			end
		end
		if string.len(passangersinveh) > 0 then
			infotextline = infotextline.. "\nPassangers: ".. passangersinveh
		end
		--if GET_BLIP_FROM_ENTITY(vehhandle) != 0 then
			if GET_BLIP_COLOUR(GET_BLIP_FROM_ENTITY(vehhandle)) == 1 then
				textline = textline.. " {Enemie}"
			end
		--end
		if GET_VEHICLE_ENGINE_HEALTH(vehhandle) < 0 then
			textline = textline.. " {destroyed}"
		end
		if entities.get_user_personal_vehicle_as_handle() == vehhandle then
			textline = textline.. " personalveh"
		end
		if showdebugginfosnearentitys then
			infotextline = infotextline.. "\nModelhash: ".. modelhash.. "\nWorldPosition: " .. "X:" ..math.floor(ePos.x) .. " Y:" ..math.floor(ePos.y) .. " Z:" ..math.floor(ePos.z)
		end
		infotextline = string.replace(infotextline, "true", "TRUE")
		infotextline = string.replace(infotextline, "false", "FALSE")
		textlinemain = textline
		if infosearchnearentitys then
			textline = infotextline
		end
		textline = textline:lower()
		if switchsearchnearentitys then
			if string.match(string.replace(textline, "["..dist.."]", ""), searchnearveh) and string.len(searchnearveh) > 0 then
				createmenus = false
			end
		else
			if not string.match(string.replace(textline, "["..dist.."]", ""), searchnearveh) then
				createmenus = false
			end
		end
		if not table.contains(vehicledata, vehhandle) then
			if createmenus then
			table.insert(vehicledata, vehhandle)
			veh[vehhandle] = menu.list(Entitymanagernearvehiclevehicles, textlinemain, {"nearveh".. modelname}, infotextline, function(on_click)
				isinfocusthemenu = true
				repeat
					local vehhandle = vehhandle
					local entitypointer = vehpointer
					local pPos = players.get_position(players.user())
					ePos = entities.get_position(vehpointer)
					if showarsignalnearentitys then
						util.draw_ar_beacon(ePos)
					end
					if showlinenearentitys then
						DRAW_LINE(pPos.x, pPos.y, pPos.z, ePos.x, ePos.y, ePos.z, 255, 0, 0, 255)
					end
					if showboxnearentitys then
						draw_bounding_box(vehhandle)
					end
					util.yield()
				until not menu.is_ref_valid(veh[vehhandle]) or not isinfocusthemenu
			end, function(on_back)
				isinfocusthemenu = false
			end)
			menu.set_temporary(veh[vehhandle])
			local numbertimercall = 0
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Teleport to Vehicle", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local entitypPos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(entityhandle, 0, 0, +2)
				local vehofpedm = GET_VEHICLE_PED_IS_IN(players.user_ped())
				SET_ENTITY_AS_MISSION_ENTITY(entityhandle)
				if IS_PED_IN_ANY_VEHICLE(players.user_ped(), true) and (GET_PED_IN_VEHICLE_SEAT(vehofpedm, -1, true) == players.user_ped()) then
					SET_ENTITY_COORDS_NO_OFFSET(vehofpedm, entitypPos.x, entitypPos.y, entitypPos.z, false, false, false)
				else
					SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), entitypPos.x, entitypPos.y, entitypPos.z, false, false, false)
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Teleport into (driver) Vehicle", {}, infotextline, function()
				local timer = 0
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local entitypPos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(entityhandle, -2, 0, 0)
				if IS_VEHICLE_SEAT_FREE(entityhandle, -1) then
					SET_PED_INTO_VEHICLE(players.user_ped(), entityhandle, -1)
				else
					local pedinseat = GET_PED_IN_VEHICLE_SEAT(entityhandle, -1)
					if IS_PED_A_PLAYER(pedinseat) then
						menu.trigger_commands("vehkick"..players.get_name(NETWORK_GET_PLAYER_INDEX_FROM_PED(pedinseat)))
						repeat
							util.yield()
							seatfree = IS_VEHICLE_SEAT_FREE(entityhandle, -1)
							if seatfree then
								util.yield(50)
								levideaktivate()
								SET_PED_INTO_VEHICLE(players.user_ped(), entityhandle, -1)
							end
							pedinseat1 = GET_PED_IN_VEHICLE_SEAT(entityhandle, -1)
							timer += 1
						until pedinseat1 == players.user_ped() or timer == 500
						if timer > 499 then
							util.toast("konnte ihn nicht aus dem auto kicken")
						end
					else
						entities.delete(pedinseat)
						repeat
							util.yield()
							seatfree = IS_VEHICLE_SEAT_FREE(entityhandle, -1)
							if seatfree then
								util.yield(50)
								levideaktivate()
								SET_PED_INTO_VEHICLE(players.user_ped(), entityhandle, -1)
							end
							pedinseat1 = GET_PED_IN_VEHICLE_SEAT(entityhandle, -1)
							timer += 1
						until seatfree or timer == 500
						if timer > 499 then
							util.toast("NPC konnte nicht gelöscht werden")
						end
					end
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Teleport into (any free seat) Vehicle", {}, infotextline, function()
				local timer = 0
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local entitypPos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(entityhandle, -2, 0, 0)
				freeseat = getfreevehseat(entityhandle)
				if freeseat ~= number then
					SET_PED_INTO_VEHICLE(players.user_ped(), entityhandle, freeseat)
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.list(veh[vehhandle], "select seat to Teleport you in", {}, infotextline, function(on_click)
				local timer = 0
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local seattextline = ""
				local maxPassengers = GET_VEHICLE_MAX_NUMBER_OF_PASSENGERS(entityhandle) -1
				for i=-1, maxPassengers do
				 	seattextline = tables.getseatname[i]
					if not IS_VEHICLE_SEAT_FREE(entityhandle, i) then
						local pedinseat = GET_PED_IN_VEHICLE_SEAT(entityhandle, i, true)
						if IS_PED_A_PLAYER(pedinseat) then
							seattextline = seattextline.. "  [pl ".. players.get_name(NETWORK_GET_PLAYER_INDEX_FROM_PED(pedinseat)).. "]"
						else
							if DOES_ENTITY_EXIST(pedinseat) then
								seattextline = seattextline.. "  [NPC]"
							end
						end
					end
					seatzaehlerofseats += 1
					seattable[seatzaehlerofseats] = menu.action(vehinfotab[vehhandle.. 4], seattextline, {"seatsvehicle"..seatzaehlerofseats}, "Sachen hier dirn werden sich nicht aktualisieren wenn du eine aktuelle liste haben willst verlass diese und dann geh wieder ein", function()
						local entityhandle = entityhandle
						local entitypointer = entitypointer
						local pPos = players.get_position(players.user())
						local ePos = entities.get_position(vehpointer)
						local dist = pPos:distance(ePos)
						local entitypPos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(entityhandle, 0, 0, 0)
						local seat = i
						if not IS_VEHICLE_SEAT_FREE(entityhandle, seat) then
							if not IS_PED_A_PLAYER(GET_PED_IN_VEHICLE_SEAT(entityhandle, seat)) then
								entities.delete(GET_PED_IN_VEHICLE_SEAT(entityhandle, seat))
							else
								if GET_PED_IN_VEHICLE_SEAT(entityhandle, seat) == players.user_ped() then
									util.toast("Du hockst da schon drin")
									goto end
								end
								menu.trigger_commands("vehkick".. players.get_name(NETWORK_GET_PLAYER_INDEX_FROM_PED(GET_PED_IN_VEHICLE_SEAT(entityhandle, seat))))
								repeat
									util.yield()
									timer += 1
									inseatplayer = IS_PED_A_PLAYER(GET_PED_IN_VEHICLE_SEAT(entityhandle, seat))
								until not inseatplayer or timer > 300
								if timer > 300 then
									util.toast("konnte nicht aus dem auto gekickt werden")
									timer = 0
									goto end
								end
							end
						end
							--if dist > 150 then
								--SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), entitypPos.x, entitypPos.y, entitypPos.z, false, false, false)
							--	util.yield(20)
							--end
							SET_PED_INTO_VEHICLE(players.user_ped(), entityhandle, seat)
					::end::
					end)
				end
			end, function(on_back)
				for i=1, seatzaehlerofseats do
					if menu.is_ref_valid(seattable[i]) then
						menu.delete(seattable[i])
					end
				end
				seatzaehlerofseats = 0
				seattable = {}
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Teleport to me", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +4, 0)
				local entitypPos = entities.get_position(entitypointer)
				if getcontrole(entityhandle) then
					SET_VEHICLE_FORWARD_SPEED(entityhandle, 0)
					SET_ENTITY_COORDS_NO_OFFSET(entityhandle, mypos.x, mypos.y, mypos.z, false, false, false)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)

			menu.divider(veh[vehhandle], "Trolling")

			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Explode", {}, infotextline, function()
				local timer = 0
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +4, 0)
				entitypPos = entities.get_position(entitypointer)
				local canbedamaged = entities.is_invulnerable(entityhandle)
				--if getcontrole(entityhandle) then
					ADD_EXPLOSION(entitypPos.x, entitypPos.y, entitypPos.z, 5, 1000, true, false, 0.0, false)
					if GET_VEHICLE_ENGINE_HEALTH(entityhandle) > 0 and not canbedamaged then
						repeat
							util.yield()
							ADD_EXPLOSION(entitypPos.x, entitypPos.y, entitypPos.z, 5, 1000, true, false, 0.0, false)
							vehiclehealth = GET_VEHICLE_ENGINE_HEALTH(entityhandle)
							vehiclebodyhealth = GET_VEHICLE_BODY_HEALTH(entityhandle)
							--timer += 1
						until (vehiclehealth < 0 and vehiclebodyhealth < 1) --or timer > 250
					end
				--else
				--	util.toast("konnte keine kontrolle bekommen")
				--end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Delete", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = players.get_position(players.user())
				local entitypPos = entities.get_position(entitypointer)
				local dist = math.floor(mypos:distance(entitypPos))
					entities.delete(entityhandle)
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Freeze ON", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = players.get_position(players.user())
				local entitypPos = entities.get_position(entitypointer)
				local dist = math.floor(mypos:distance(entitypPos))
				if getcontrole(entityhandle) then
					FREEZE_ENTITY_POSITION(entityhandle, true)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Freeze OFF", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = players.get_position(players.user())
				local entitypPos = entities.get_position(entitypointer)
				local dist = math.floor(mypos:distance(entitypPos))
				if getcontrole(entityhandle) then
					FREEZE_ENTITY_POSITION(entityhandle, false)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Kick peds of vehicle", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = players.get_position(players.user())
				local entitypPos = entities.get_position(entitypointer)
				local dist = math.floor(mypos:distance(entitypPos))
				local pedsinveh = getpedsinvehicle(entityhandle)
				if pedsinveh != 0 then
					for pedsinveh as pedsinveh1 do
						if not IS_PED_A_PLAYER(pedsinveh1) then
							if getcontrole(pedsinveh1) and getcontrole(entityhandle) then
								TASK_LEAVE_VEHICLE(pedsinveh1, entityhandle, 16)
							end
						end
					end
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Delete peds of vehicle", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = players.get_position(players.user())
				local entitypPos = entities.get_position(entitypointer)
				local dist = math.floor(mypos:distance(entitypPos))
				local pedsinveh = getpedsinvehicle(entityhandle)
				if pedsinveh != 0 then
					for pedsinveh as pedsinveh1 do
						if not IS_PED_A_PLAYER(pedsinveh1) then
							entities.delete(pedsinveh1)
						end
					end
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Remove wheels", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				if getcontrole(entityhandle) then
					for i=0, 7 do
						SET_VEHICLE_TYRE_BURST(entityhandle, i, true, 0)
						entities.detach_wheel(entityhandle, i)
					end
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.textslider_stateful(veh[vehhandle], "Boost", {}, infotextline, {"Forward", "Right", "Left","Up","Down", "Back"}, function(index)
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				if index == 1 then
					if getcontrole(entityhandle) then
						APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(entityhandle, 1, 0.0, boostvaluetoboostnearentitys, 0.0, true, true, true, true)
					end
				elseif index == 2 then
					if getcontrole(entityhandle) then
						APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(entityhandle, 1, boostvaluetoboostnearentitys, 0.0, 0.0, true, true, true, true)
					end
				elseif index == 3 then
					if getcontrole(entityhandle) then
						APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(entityhandle, 1, -boostvaluetoboostnearentitys, 0.0, 0.0, true, true, true, true)
					end
				elseif index == 4 then
					if getcontrole(entityhandle) then
						APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(entityhandle, 1, 0.0, 0.0, boostvaluetoboostnearentitys, true, true, true, true)
					end
				elseif index == 5 then
					if getcontrole(entityhandle) then
						APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(entityhandle, 1, 0.0, 0.0, -boostvaluetoboostnearentitys, true, true, true, true)
					end
				elseif index == 6 then
					if getcontrole(entityhandle) then
						APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(entityhandle, 1, 0.0, -boostvaluetoboostnearentitys, 0.0, true, true, true, true)
					end
				end
			end)

			menu.divider(veh[vehhandle], "Friendly")

			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Give Godmode", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +4, 0)
				local entitypPos = entities.get_position(entitypointer)
				if getcontrole(entityhandle) then
					SET_ENTITY_INVINCIBLE(entityhandle, true)
					SET_ENTITY_PROOFS(entityhandle, true, true,true,true,true,true,true,true)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Remove Godmode", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +4, 0)
				local entitypPos = entities.get_position(entitypointer)
				if getcontrole(entityhandle) then
					SET_ENTITY_INVINCIBLE(entityhandle, false)
					SET_ENTITY_PROOFS(entityhandle, false, false,false,false,false,false,false,false)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Repair", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +4, 0)
				local entitypPos = entities.get_position(entitypointer)
				if getcontrole(entityhandle) then
					STOP_ENTITY_FIRE(entityhandle)
					SET_VEHICLE_FIXED(entityhandle)
					SET_VEHICLE_DIRT_LEVEL(entityhandle, 0)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.click_slider_float(veh[vehhandle], "Modifiy Top speed", {"Topspeednearveh"..modelname}, infotextline, 100, 2000, 100, 100, function(s)
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +4, 0)
				local entitypPos = entities.get_position(entitypointer)
				if getcontrole(entityhandle) then
					s = s / 10
					MODIFY_VEHICLE_TOP_SPEED(entityhandle, s)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.list_action(veh[vehhandle], "Upgrade", {}, "", {"full", "random", "down"}, function(index)
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				--local mypos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +4, 0)
				--local entitypPos = entities.get_position(entitypointer)
				if index == 1 then
					upgrade_vehicle(entityhandle)
				elseif index == 2 then
					randomupgrade_vehicle(entityhandle)
				elseif index == 3 then
					downggrade_vehicle(entityhandle)
				end
			end)

			menu.divider(veh[vehhandle], "Misc")
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Copy vehicle", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = players.get_position(players.user())
				local entitypPos = entities.get_position(entitypointer)
				local dist = math.floor(mypos:distance(entitypPos))
				local pedsinveh = getpedsinvehicle(entityhandle)
				local clonedvehicle = clonevehicle(entityhandle)
				SET_ENTITY_COORDS(clonedvehicle, mypos.x, mypos.y, mypos.z)
				SET_PED_INTO_VEHICLE(players.user_ped(), clonedvehicle, -1)
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.text_input(veh[vehhandle], "Save Vehicle", {"save"..modelname}, infotextline, function(input)
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = players.get_position(players.user())
				local entitypPos = entities.get_position(entitypointer)
				local dist = math.floor(mypos:distance(entitypPos))
				savevehicleingarage(entityhandle, input)
				--[[freeseat = getfreevehseat(entityhandle)
				if GET_VEHICLE_PED_IS_IN(players.user_ped()) == entityhandle then
					menu.trigger_commands("savevehicle "..input)
					util.toast("VEH: ".. entitiyname.. " Saved as ".. input)
					goto end
				end
				if freeseat then
					if IS_PED_IN_ANY_VEHICLE(players.user_ped()) then
						local vehicleofped = GET_VEHICLE_PED_IS_IN(players.user_ped())
						local seatofplayer = getseatofplayer(vehicleofped)
						SET_PED_INTO_VEHICLE(players.user_ped(), entityhandle, freeseat)
						util.yield(20)
						menu.trigger_commands("savevehicle "..input)
						util.toast("VEH: ".. entitiyname.. " Saved as ".. input)
						util.yield(20)
						if DOES_ENTITY_EXIST(vehicleofped) then
							if IS_VEHICLE_SEAT_FREE(vehicleofped, seatofplayer, false) then
								SET_PED_INTO_VEHICLE(players.user_ped(), vehicleofped, seatofplayer)
							else
								getfreesetincar = getfreevehseat(vehicleofped)
								if getfreesetincar ~= number then
									SET_PED_INTO_VEHICLE(players.user_ped(), vehicleofped, getfreesetincar)
								else
									SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), mypos, false, false, false)
								end
							end
						end
					else
						SET_PED_INTO_VEHICLE(players.user_ped(), entityhandle, freeseat)
						util.yield(20)
						menu.trigger_commands("savevehicle "..input)
						util.toast("VEH: ".. entitiyname.. " Saved as ".. input)
						util.yield(10)
						SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), mypos, false, false, false)
					end
				else
					util.toast("Es gibt kein sitzplatz für dich")
				end
				::end::]]
				menu.set_value(menu.ref_by_command_name("save"..modelname), "")
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Set Mission Entitiy", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +4, 0)
				local entitypPos = entities.get_position(entitypointer)
				if getcontrole(entityhandle) then
					SET_ENTITY_AS_MISSION_ENTITY(entityhandle)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Set Entity as no longer needed", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +4, 0)
				local entitypPos = entities.get_position(entitypointer)
				local ent_ptr = memory.alloc_int()
				memory.write_int(ent_ptr, entityhandle)
				if getcontrole(entityhandle) then
					SET_ENTITY_AS_NO_LONGER_NEEDED(ent_ptr)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Set Visible", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +4, 0)
				local entitypPos = entities.get_position(entitypointer)
				if getcontrole(entityhandle) then
					SET_ENTITY_VISIBLE(entityhandle, true, 0)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Set Unvisible", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +4, 0)
				local entitypPos = entities.get_position(entitypointer)
				if getcontrole(entityhandle) then
					SET_ENTITY_VISIBLE(entityhandle, false, 0)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numberfunctioninlist = numbertimercall
			end
		else
			if loadboxonallent and showboxnearentitys then
				draw_bounding_box(vehhandle)
			end
			if menu.is_focused(veh[vehhandle]) then
				if showarsignalnearentitys then
					util.draw_ar_beacon(ePos)
				end
				if showlinenearentitys then
					DRAW_LINE(pPos.x, pPos.y, pPos.z, ePos.x, ePos.y, ePos.z, 255, 0, 0, 255)
				end
				if showboxnearentitys then
					draw_bounding_box(vehhandle)
				end
			end
			if menu.is_ref_valid(veh[vehhandle]) then
				menu.set_menu_name(veh[vehhandle], textlinemain)
				if menu.get_help_text(veh[vehhandle]) != infotextline and menu.is_focused(veh[vehhandle]) then
					menu.set_help_text(veh[vehhandle], infotextline)
				end
			end
			for i = 1, numberfunctioninlist do
				if menu.is_focused(vehinfotab[vehhandle.. i]) then
					if menu.is_ref_valid(vehinfotab[vehhandle.. i]) then
						--[[if menu.is_focused(vehinfotab[vehhandle.. i]) then
							if showarsignalnearentitys then
								util.draw_ar_beacon(ePos)
							end
							if showlinenearentitys then
								DRAW_LINE(pPos.x, pPos.y, pPos.z, ePos.x, ePos.y, ePos.z, 255, 0, 0, 255)
							end
							if showboxnearentitys then
								draw_bounding_box(vehhandle)
							end
						end]]
						if menu.get_help_text(vehinfotab[vehhandle.. i]) != infotextline then
							menu.set_help_text(vehinfotab[vehhandle.. i], infotextline)
						end
					end
				end
			end
		end
		::continue::
	end
	for vehicledata as vehhandle do
		if DOES_ENTITY_EXIST(vehhandle) then
			local vehpointer = entities.handle_to_pointer(vehhandle)
			local pPos = players.get_position(players.user())
			local ePos = entities.get_position(vehpointer)
			local infodist = pPos:distance(ePos)
			local textline = menu.get_menu_name(veh[vehhandle])
			local pedinveh = getpedsinvehicle(vehhandle)
			local delethandlelist = false
			if not showplayersnearentitys then
				for pedinveh as peds do
					if IS_PED_A_PLAYER(peds) then
						delethandlelist = true
					end
				end
			end
			if infosearchnearentitys then
				textline = menu.get_help_text(veh[vehhandle])
			end
			textline = textline:lower()
			local dist = string.strip(textline, "[]")
			if switchsearchnearentitys then
				stringmatcher = string.match(string.replace(textline, "["..dist.."]", ""), searchnearveh) and string.len(searchnearveh) > 0
			else
				stringmatcher = not string.match(string.replace(textline, "["..dist.."]", ""), searchnearveh)
			end
			if (onlymissionnearentitys and not IS_ENTITY_A_MISSION_ENTITY(vehhandle)) or (infodist > maxDistancenearentitys) or (stringmatcher) or (showonlyblibsnearentitys and (GET_BLIP_FROM_ENTITY(vehhandle) == 0)) or (delethandlelist) then
				if menu.is_ref_valid(veh[vehhandle]) then
					menu.delete(veh[vehhandle])
					tableremove(vehicledata, vehhandle)
				end
			end
		elseif not DOES_ENTITY_EXIST(vehhandle) or (onlymissionnearentitys and not IS_ENTITY_A_MISSION_ENTITY(vehhandle)) then
			if menu.is_ref_valid(veh[vehhandle]) then
				menu.delete(veh[vehhandle])
				tableremove(vehicledata, vehhandle)
			end
		end
	end
	::end::
end

function getnearpeds()
	if not enablednearpeds then
		for pedsdata as vehhandle do
			if menu.is_ref_valid(veh[vehhandle]) then
				menu.delete(veh[vehhandle])
			end
		end
		pedsdata = {}
		return false
	end
	--if not menu.is_open() then
	--	return
	--end
	if util.is_session_transition_active() then
		return
	end
	local allpointer = entities.get_all_peds_as_pointers()
	for _, vehpointer in pairs(allpointer) do
		local vehhandle = entities.pointer_to_handle(vehpointer)
		local modelhash = entities.get_model_hash(vehhandle)
		local pPos = players.get_position(players.user())
		local ePos = entities.get_position(vehpointer)
		local dist = math.floor(pPos:distance(ePos))
		local modelname = getmodelnamebyhash(modelhash)
		local infodist = pPos:distance(ePos)
		local ismissionentity = IS_ENTITY_A_MISSION_ENTITY(vehhandle)
		local textline = modelname.. "  [".. dist.. "]"
		local infotextline = modelname.. "\nDist: ".. dist
		local createmenus = true
		if onlymissionnearentitys and not ismissionentity then
			goto continue
		end
		if infodist > maxDistancenearentitys then
			goto continue
		end
		if vehhandle == players.user_ped() then
			goto continue
		end
		if showonlyblibsnearentitys and (GET_BLIP_FROM_ENTITY(vehhandle) == 0) then
			goto continue
		end
		if IS_PED_A_PLAYER(vehhandle) then
			if showplayersnearentitys then
				local pidnameofp = players.get_name(NETWORK_GET_PLAYER_INDEX_FROM_PED(vehhandle))
				textline = "(pl "..pidnameofp .. ")  [".. dist.. "]"
				infotextline = pidnameofp.. "\nDist: ".. dist
			else
				goto continue
			end
		end
		infotextline = infotextline.. "\nHealth: ".. GET_ENTITY_HEALTH(vehhandle)
		infotextline = infotextline.. "\nArmour: ".. GET_PED_ARMOUR(vehhandle)
		if IS_PED_ARMED(vehhandle ,7) then
			infotextline = infotextline.. "\nWeapon out: TRUE"
		else
			infotextline = infotextline.. "\nWeapon out: FALSE"
		end
		if not IS_ENTITY_VISIBLE(vehhandle) then
			infotextline = infotextline..  "\nInVisible: TRUE"
		else
			infotextline = infotextline.. "\nInVisible: FALSE"
		end
		if not GET_ENTITY_CAN_BE_DAMAGED(vehhandle) then
			infotextline = infotextline..  "\nGOD: TRUE"
		else
			infotextline = infotextline.. "\nGOD: FALSE"
		end
		infotextline = infotextline.. "\nMission Entity: ".. IS_ENTITY_A_MISSION_ENTITY(vehhandle)
		if IS_PED_IN_ANY_VEHICLE(vehhandle, false) then
			textline = textline.. " {in veh}"
			infotextline = infotextline.. "\nVehicle: ".. getmodelnamebyhash(entities.get_model_hash(GET_VEHICLE_PED_IS_IN(vehhandle)))
		end
		if isentitiyaenemie(vehhandle) then
			textline = textline.. " {Enemie}"
		end
		if IS_PED_DEAD_OR_DYING(vehhandle) then
			textline = textline.. " {Dead}"
		end
		if tables.PedType[GET_PED_TYPE(vehhandle)] != nil then
			infotextline = infotextline.. "\nPedType: ".. tables.PedType[GET_PED_TYPE(vehhandle)]
		end
		if showdebugginfosnearentitys then
			infotextline = infotextline.. "\nModelhash: ".. modelhash.. "\nWorldPosition: " .. "X:" ..math.floor(ePos.x) .. " Y:" ..math.floor(ePos.y) .. " Z:" ..math.floor(ePos.z)
		end
		infotextline = string.replace(infotextline, "true", "TRUE")
		infotextline = string.replace(infotextline, "false", "FALSE")
		textlinemain = textline
		if infosearchnearentitys then
			textline = infotextline
		end
		textline = textline:lower()
		if switchsearchnearentitys then
			if string.match(string.replace(textline, "["..dist.."]", ""), searchnearpeds) and string.len(searchnearpeds) > 0 then
				createmenus = false
			end
		else
			if not string.match(string.replace(textline, "["..dist.."]", ""), searchnearpeds) then
				createmenus = false
			end
		end
		if not table.contains(pedsdata, vehhandle) then
			if createmenus then
			table.insert(pedsdata, vehhandle)
			veh[vehhandle] = menu.list(Entitymanagernearvehiclepeds, textlinemain, {}, infotextline, function(on_click)
				isinfocusthemenu = true
				repeat
					local vehhandle = vehhandle
					local entitypointer = vehpointer
					local pPos = players.get_position(players.user())
					ePos = entities.get_position(vehpointer)
					if showarsignalnearentitys then
						util.draw_ar_beacon(ePos)
					end
					if showlinenearentitys then
						DRAW_LINE(pPos.x, pPos.y, pPos.z, ePos.x, ePos.y, ePos.z, 255, 0, 0, 255)
					end
					if showboxnearentitys then
						draw_bounding_box(vehhandle)
					end
					util.yield()
				until not menu.is_ref_valid(veh[vehhandle]) or not isinfocusthemenu
			end, function(on_back)
				isinfocusthemenu = false
			end)
			local numbertimercall = 0
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Teleport to Ped", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local entitypPos = entities.get_position(entitypointer)
				local vehofpedm = GET_VEHICLE_PED_IS_IN(players.user_ped())
				SET_ENTITY_AS_MISSION_ENTITY(entityhandle)
				if IS_PED_IN_ANY_VEHICLE(players.user_ped(), true) and (GET_PED_IN_VEHICLE_SEAT(vehofpedm, -1, true) == players.user_ped()) then
					SET_ENTITY_COORDS_NO_OFFSET(vehofpedm, entitypPos.x, entitypPos.y, entitypPos.z, false, false, false)
				else
					SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), entitypPos.x, entitypPos.y, entitypPos.z, false, false, false)
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Teleport to me", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +2, 0)
				mypos.z = get_ground_z(mypos) +1
				local entitypPos = entities.get_position(entitypointer)
				if getcontrole(entityhandle) then
					SET_ENTITY_COORDS_NO_OFFSET(entityhandle, mypos.x, mypos.y, mypos.z, false, false, false)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			menu.divider(veh[vehhandle], "Trolling")
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Delete", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = players.get_position(players.user())
				local entitypPos = entities.get_position(entitypointer)
				local dist = math.floor(mypos:distance(entitypPos))
					entities.delete(entityhandle)
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Explode", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local entitypPos = entities.get_position(entitypointer)
				ADD_EXPLOSION(entitypPos.x, entitypPos.y, entitypPos.z, 2, 100, true, false, 0.0, false)
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Kill", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				if getcontrole(entityhandle) then
					SET_ENTITY_HEALTH(entityhandle, 0, 0)
					FORCE_PED_MOTION_STATE(entityhandle, 0x0DBB071C, 0,0,0)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Shoot", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				if GET_VEHICLE_PED_IS_USING(entityhandle) ~= 0 then CLEAR_PED_TASKS_IMMEDIATELY(entityhandle) end
				local PedPos = GET_ENTITY_COORDS(entityhandle)
				local AddPos = GET_ENTITY_COORDS(entityhandle)
				AddPos.z = AddPos.z + 1
				SHOOT_SINGLE_BULLET_BETWEEN_COORDS(AddPos.x, AddPos.y, AddPos.z, PedPos.x, PedPos.y, PedPos.z, 1000, false, 0xC472FE2, players.user_ped(), false, true, 1000)
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Freeze ON", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				if getcontrole(entityhandle) then
					FREEZE_ENTITY_POSITION(entityhandle, true)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Freeze OFF", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				if getcontrole(entityhandle) then
					FREEZE_ENTITY_POSITION(entityhandle, false)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Remove Weapons", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				if getcontrole(entityhandle) then
					REMOVE_ALL_PED_WEAPONS(entityhandle, false)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.textslider_stateful(veh[vehhandle], "Boost", {}, infotextline, {"Forward", "Right", "Left","Up","Down", "Back"}, function(index)
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				if index == 1 then
					if getcontrole(entityhandle) then
						APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(entityhandle, 1, 0.0, boostvaluetoboostnearentitys, 0.0, true, true, true, true)
					end
				elseif index == 2 then
					if getcontrole(entityhandle) then
						APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(entityhandle, 1, boostvaluetoboostnearentitys, 0.0, 0.0, true, true, true, true)
					end
				elseif index == 3 then
					if getcontrole(entityhandle) then
						APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(entityhandle, 1, -boostvaluetoboostnearentitys, 0.0, 0.0, true, true, true, true)
					end
				elseif index == 4 then
					if getcontrole(entityhandle) then
						APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(entityhandle, 1, 0.0, 0.0, boostvaluetoboostnearentitys, true, true, true, true)
					end
				elseif index == 5 then
					if getcontrole(entityhandle) then
						APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(entityhandle, 1, 0.0, 0.0, -boostvaluetoboostnearentitys, true, true, true, true)
					end
				elseif index == 6 then
					if getcontrole(entityhandle) then
						APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(entityhandle, 1, 0.0, -boostvaluetoboostnearentitys, 0.0, true, true, true, true)
					end
				end
			end)
			menu.divider(veh[vehhandle], "Friendly")
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Give Godmode", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				if getcontrole(entityhandle) then
					SET_ENTITY_INVINCIBLE(entityhandle, true)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Remove Godmode", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				if getcontrole(entityhandle) then
					SET_ENTITY_INVINCIBLE(entityhandle, false)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Heal/Revive", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = players.get_position(players.user())
				local entitypPos = entities.get_position(entitypointer)
				local dist = math.floor(mypos:distance(entitypPos))
				local ispeddead = IS_PED_DEAD_OR_DYING(entityhandle)
				if getcontrole(entityhandle) then
					maxhealth = GET_PED_MAX_HEALTH(entityhandle)
					SET_ENTITY_HEALTH(entityhandle, maxhealth, 0)
					STOP_ENTITY_FIRE(entityhandle)
					if ispeddead then
						CLEAR_PED_TASKS_IMMEDIATELY(entityhandle)
					end
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			menu.divider(veh[vehhandle], "Misc")
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Clear Tasks", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				if getcontrole(entityhandle) then
					CLEAR_PED_TASKS_IMMEDIATELY(entityhandle)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Geld menge dabei", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				if getcontrole(entityhandle) then
					util.toast(GET_PED_MONEY(entityhandle))
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Set Entity as mission entity", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = players.get_position(players.user())
				local entitypPos = entities.get_position(entitypointer)
				local dist = math.floor(mypos:distance(entitypPos))
				if getcontrole(entityhandle) then
					SET_ENTITY_AS_MISSION_ENTITY(entityhandle)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Set entitiy as no longer needed", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = players.get_position(players.user())
				local entitypPos = entities.get_position(entitypointer)
				local dist = math.floor(mypos:distance(entitypPos))
				local ent_ptr = memory.alloc_int()
				memory.write_int(ent_ptr, entityhandle)
				if getcontrole(entityhandle) then
					SET_ENTITY_AS_NO_LONGER_NEEDED(ent_ptr)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Set Visible", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				if getcontrole(entityhandle) then
					SET_ENTITY_VISIBLE(entityhandle, true, 0)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Set Unvisible", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				if getcontrole(entityhandle) then
					SET_ENTITY_VISIBLE(entityhandle, false, 0)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numberfunctioninlist = numbertimercall
			end
		else
			if loadboxonallent and showboxnearentitys then
				draw_bounding_box(vehhandle)
			end
			if menu.is_focused(veh[vehhandle]) then
				if showarsignalnearentitys then
					util.draw_ar_beacon(ePos)
				end
				if showlinenearentitys then
					DRAW_LINE(pPos.x, pPos.y, pPos.z, ePos.x, ePos.y, ePos.z, 255, 0, 0, 255)
				end
				if showboxnearentitys then
					draw_bounding_box(vehhandle)
				end
			end
			if menu.is_ref_valid(veh[vehhandle]) then
				menu.set_menu_name(veh[vehhandle], textlinemain)
				if menu.get_help_text(veh[vehhandle]) != infotextline and menu.is_focused(veh[vehhandle]) then
					menu.set_help_text(veh[vehhandle], infotextline)
				end
			end
			for i = 1, numberfunctioninlist do
				if menu.is_focused(vehinfotab[vehhandle.. i]) then
					if menu.is_ref_valid(vehinfotab[vehhandle.. i]) then
						--[[if menu.is_focused(vehinfotab[vehhandle.. i]) then
							if showarsignalnearentitys then
								util.draw_ar_beacon(ePos)
							end
							if showlinenearentitys then
								DRAW_LINE(pPos.x, pPos.y, pPos.z, ePos.x, ePos.y, ePos.z, 255, 0, 0, 255)
							end
							if showboxnearentitys then
								draw_bounding_box(vehhandle)
							end
						end]]
						if menu.get_help_text(vehinfotab[vehhandle.. i]) != infotextline then
							menu.set_help_text(vehinfotab[vehhandle.. i], infotextline)
						end
					end
				end
			end
		end
		::continue::
		--if not string.match(string.replace(textline, "["..dist.."]", ""), searchnearpeds) then
		--	if DOES_ENTITY_EXIST(vehhandle) then
		--		if veh[vehhandle] != nil and not veh[vehhandle] == number then
		--			if menu.is_ref_valid(veh[vehhandle]) then
		--				menu.set_menu_name(veh[vehhandle], textline)
		--			end
		--		end
		--	end
		--end
	end
	for pedsdata as vehhandle do
		if DOES_ENTITY_EXIST(vehhandle) then
			local vehpointer = entities.handle_to_pointer(vehhandle)
			local pPos = players.get_position(players.user())
			local ePos = entities.get_position(vehpointer)
			local infodist = pPos:distance(ePos)
			local textline = menu.get_menu_name(veh[vehhandle])
			if infosearchnearentitys then
				textline = menu.get_help_text(veh[vehhandle])
			end
			textline = textline:lower()
			local dist = string.strip(textline, "[]")
			if switchsearchnearentitys then
				stringmatcher = string.match(string.replace(textline, "["..dist.."]", ""), searchnearpeds) and string.len(searchnearpeds) > 0
			else
				stringmatcher = not string.match(string.replace(textline, "["..dist.."]", ""), searchnearpeds)
			end
			if (onlymissionnearentitys and not IS_ENTITY_A_MISSION_ENTITY(vehhandle)) or (infodist > maxDistancenearentitys) or (stringmatcher) or (showonlyblibsnearentitys and (GET_BLIP_FROM_ENTITY(vehhandle) == 0)) then
				if menu.is_ref_valid(veh[vehhandle]) then
					menu.delete(veh[vehhandle])
					tableremove(pedsdata, vehhandle)
				end
			end
		elseif not DOES_ENTITY_EXIST(vehhandle) or (onlymissionnearentitys and not IS_ENTITY_A_MISSION_ENTITY(vehhandle)) then
			if menu.is_ref_valid(veh[vehhandle]) then
				menu.delete(veh[vehhandle])
				tableremove(pedsdata, vehhandle)
			end
		end
	end
	::end::
end


function getnearobjects()
	if not enablednearobjects then
		if not enablednearobjects then
			for objectsdata as vehhandle do
				if menu.is_ref_valid(veh[vehhandle]) then
					menu.delete(veh[vehhandle])
				end
			end
			objectsdata = {}
			return false
		end
	end
	--if not menu.is_open() then
	--	return
	--end
	if util.is_session_transition_active() then
		return
	end
	for _, vehpointer in pairs(entities.get_all_objects_as_pointers()) do
		local vehhandle = entities.pointer_to_handle(vehpointer)
		local modelhash = entities.get_model_hash(vehhandle)
		local pPos = players.get_position(players.user())
		local ePos = entities.get_position(vehpointer)
		local dist = math.floor(pPos:distance(ePos))
		local modelname = getmodelnamebyhash(modelhash)
		local infodist = pPos:distance(ePos)
		local ismissionentity = IS_ENTITY_A_MISSION_ENTITY(vehhandle)
		local textline = modelname.. "  [".. dist.. "]"
		local infotextline = modelname.. "\nDist: ".. dist
		local createmenus = true
		if infodist > maxDistancenearentitys then
			goto continue
		end
		if onlymissionnearentitys and not ismissionentity then
			goto continue
		end
		if modelname == "" then
			goto continue
		end
		if showonlyblibsnearentitys and (GET_BLIP_FROM_ENTITY(vehhandle) == 0) then
			goto continue
		end
		if removeattachobjnearentitys and IS_ENTITY_ATTACHED(vehhandle) then
			goto continue
		end
		if not IS_ENTITY_VISIBLE(vehhandle) then
			infotextline = infotextline..  "\nInVisible: TRUE"
		else
			infotextline = infotextline.. "\nInVisible: FALSE"
		end
		if not GET_ENTITY_CAN_BE_DAMAGED(vehhandle) then
			infotextline = infotextline..  "\nGOD: TRUE"
		else
			infotextline = infotextline.. "\nGOD: FALSE"
		end
		infotextline = infotextline.. "\nMission Entity: ".. IS_ENTITY_A_MISSION_ENTITY(vehhandle)
		if GET_ENTITY_ATTACHED_TO(vehhandle) != 0 then
			attachedto = GET_ENTITY_ATTACHED_TO(vehhandle)
			if IS_PED_A_PLAYER(attachedto) then
				infotextline = infotextline.. "\nAttached to: ".. players.get_name(NETWORK_GET_PLAYER_INDEX_FROM_PED(attachedto))
			else
				infotextline = infotextline.. "\nAttached to: ".. getmodelnamebyhash(entities.get_model_hash(attachedto))
			end
		end
		if showdebugginfosnearentitys then
			infotextline = infotextline.. "\nModelhash: ".. modelhash.. "\nWorldPosition: " .. "X:" ..math.floor(ePos.x) .. " Y:" ..math.floor(ePos.y) .. " Z:" ..math.floor(ePos.z)
		end
		infotextline = string.replace(infotextline, "true", "TRUE")
		infotextline = string.replace(infotextline, "false", "FALSE")
		textlinemain = textline
		if infosearchnearentitys then
			textline = infotextline
		end
		textline = textline:lower()
		if switchsearchnearentitys then
			if string.match(string.replace(textline, "["..dist.."]", ""), searchnearobjects) and string.len(searchnearobjects) > 0 then
				createmenus = false
			end
		else
			if not string.match(string.replace(textline, "["..dist.."]", ""), searchnearobjects) then
				createmenus = false
			end
		end
		if not table.contains(objectsdata, vehhandle) then
			if createmenus then
			table.insert(objectsdata, vehhandle)
			veh[vehhandle] = menu.list(Entitymanagernearvehicleobjects, textlinemain, {}, infotextline, function(on_click)
				isinfocusthemenu = true
				repeat
					local vehhandle = vehhandle
					local entitypointer = vehpointer
					local pPos = players.get_position(players.user())
					ePos = entities.get_position(vehpointer)
					if showarsignalnearentitys then
						util.draw_ar_beacon(ePos)
					end
					if showlinenearentitys then
						DRAW_LINE(pPos.x, pPos.y, pPos.z, ePos.x, ePos.y, ePos.z, 255, 0, 0, 255)
					end
					if showboxnearentitys then
						draw_bounding_box(vehhandle)
					end
					util.yield()
				until not menu.is_ref_valid(veh[vehhandle]) or not isinfocusthemenu
			end, function(on_back)
				isinfocusthemenu = false
			end)
			local numbertimercall = 0
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Teleport to Object", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local entitypPos = entities.get_position(entitypointer)
				SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), entitypPos.x, entitypPos.y, entitypPos.z, false, false, false)
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Teleport to me", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +4, -1)
				local entitypPos = entities.get_position(entitypointer)
				if getcontrole(entityhandle) then
					SET_ENTITY_COORDS_NO_OFFSET(entityhandle, mypos.x, mypos.y, mypos.z, false, false, false)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Delete", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = players.get_position(players.user())
				local entitypPos = entities.get_position(entitypointer)
				local dist = math.floor(mypos:distance(entitypPos))
					entities.delete(entityhandle)
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Explode", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = players.get_position(players.user())
				local ePos = entities.get_position(entitypointer)
				ADD_EXPLOSION(ePos.x, ePos.y, ePos.z, 5, 1000, true, false, 0.0, false)
			end)
			menu.divider(veh[vehhandle], "Misc")
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Set Entity as mission entity", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = players.get_position(players.user())
				local entitypPos = entities.get_position(entitypointer)
				local dist = math.floor(mypos:distance(entitypPos))
				if getcontrole(entityhandle) then
					SET_ENTITY_AS_MISSION_ENTITY(vehhandle)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Set entitiy as no longer needed", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = players.get_position(players.user())
				local entitypPos = entities.get_position(entitypointer)
				local dist = math.floor(mypos:distance(entitypPos))
				local ent_ptr = memory.alloc_int()
				memory.write_int(ent_ptr, vehhandle)
				if getcontrole(vehhandle) then
					SET_ENTITY_AS_NO_LONGER_NEEDED(ent_ptr)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Set Visible", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +4, 0)
				local entitypPos = entities.get_position(entitypointer)
				if getcontrole(entityhandle) then
					SET_ENTITY_VISIBLE(entityhandle, true, 0)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Set Unvisible", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +4, 0)
				local entitypPos = entities.get_position(entitypointer)
				if getcontrole(entityhandle) then
					SET_ENTITY_VISIBLE(entityhandle, false, 0)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numberfunctioninlist = numbertimercall
			end
		else
			if loadboxonallent and showboxnearentitys then
				draw_bounding_box(vehhandle)
			end
			if menu.is_focused(veh[vehhandle]) then
				if showarsignalnearentitys then
					util.draw_ar_beacon(ePos)
				end
				if showlinenearentitys then
					DRAW_LINE(pPos.x, pPos.y, pPos.z, ePos.x, ePos.y, ePos.z, 255, 0, 0, 255)
				end
				if showboxnearentitys then
					draw_bounding_box(vehhandle)
				end
			end
			if menu.is_ref_valid(veh[vehhandle]) then
				menu.set_menu_name(veh[vehhandle], textlinemain)
				if menu.get_help_text(veh[vehhandle]) != infotextline and menu.is_focused(veh[vehhandle]) then
					menu.set_help_text(veh[vehhandle], infotextline)
				end
			end
			for i = 1, numberfunctioninlist do
				if menu.is_focused(vehinfotab[vehhandle.. i]) then
					if menu.is_ref_valid(vehinfotab[vehhandle.. i]) then
						--[[if menu.is_focused(vehinfotab[vehhandle.. i]) then
							if showarsignalnearentitys then
								util.draw_ar_beacon(ePos)
							end
							if showlinenearentitys then
								DRAW_LINE(pPos.x, pPos.y, pPos.z, ePos.x, ePos.y, ePos.z, 255, 0, 0, 255)
							end
							if showboxnearentitys then
								draw_bounding_box(vehhandle)
							end
						end]]
						if menu.get_help_text(vehinfotab[vehhandle.. i]) != infotextline then
							menu.set_help_text(vehinfotab[vehhandle.. i], infotextline)
						end
					end
				end
			end
		end
		::continue::
	end
	for objectsdata as vehhandle do
		if DOES_ENTITY_EXIST(vehhandle) then
			local vehpointer = entities.handle_to_pointer(vehhandle)
			local pPos = players.get_position(players.user())
			local ePos = entities.get_position(vehpointer)
			local infodist = pPos:distance(ePos)
			local textline = menu.get_menu_name(veh[vehhandle])
			if infosearchnearentitys then
				textline = menu.get_help_text(veh[vehhandle])
			end
			textline = textline:lower()
			local dist = string.strip(textline, "[]")
			if switchsearchnearentitys then
				stringmatcher = string.match(string.replace(textline, "["..dist.."]", ""), searchnearobjects) and string.len(searchnearobjects) > 0
			else
				stringmatcher = not string.match(string.replace(textline, "["..dist.."]", ""), searchnearobjects)
			end
			if (onlymissionnearentitys and not IS_ENTITY_A_MISSION_ENTITY(vehhandle)) or (infodist > maxDistancenearentitys) or (stringmatcher) or (showonlyblibsnearentitys and (GET_BLIP_FROM_ENTITY(vehhandle) == 0)) then
				if menu.is_ref_valid(veh[vehhandle]) then
					menu.delete(veh[vehhandle])
					tableremove(objectsdata, vehhandle)
				end
			end
		elseif not DOES_ENTITY_EXIST(vehhandle) or (onlymissionnearentitys and not IS_ENTITY_A_MISSION_ENTITY(vehhandle)) then
			if menu.is_ref_valid(veh[vehhandle]) then
				menu.delete(veh[vehhandle])
				tableremove(objectsdata, vehhandle)
			end
		end
	end
	menu.collect_garbage()
	::end::
end

function getnearpickup()
	if not enablednearpickups then
		if not enablednearpickups then
			for pickupdata as vehhandle do
				if menu.is_ref_valid(veh[vehhandle]) then
					menu.delete(veh[vehhandle])
				end
			end
			pickupdata = {}
			return false
		end
	end
	--if not menu.is_open() then
	--	return
	--end
	if util.is_session_transition_active() then
		return
	end
	local allpointer = entities.get_all_pickups_as_pointers()
	for _, vehpointer in pairs(allpointer) do
		local vehhandle = entities.pointer_to_handle(vehpointer)
		local modelhash = entities.get_model_hash(vehhandle)
		local pPos = players.get_position(players.user())
		local ePos = entities.get_position(vehpointer)
		local dist = math.floor(pPos:distance(ePos))
		local modelname = getmodelnamebyhash(modelhash)
		local infodist = pPos:distance(ePos)
		local ismissionentity = IS_ENTITY_A_MISSION_ENTITY(vehhandle)
		local textline = modelname.. "  [".. dist.. "]"
		local infotextline = modelname.. "\nDist: ".. dist
		local createmenus = true
		if onlymissionnearentitys and not ismissionentity then
			goto continue
		end
		if infodist > maxDistancenearentitys then
			goto continue
		end
		if showonlyblibsnearentitys and (GET_BLIP_FROM_ENTITY(vehhandle) == 0) then
			goto continue
		end
		if removeattachobjnearentitys and IS_ENTITY_ATTACHED(vehhandle) then
			goto continue
		end
		if not IS_ENTITY_VISIBLE(vehhandle) then
			infotextline = infotextline..  "\nInVisible: TRUE"
		else
			infotextline = infotextline.. "\nInVisible: FALSE"
		end
		if not GET_ENTITY_CAN_BE_DAMAGED(vehhandle) then
			infotextline = infotextline..  "\nGOD: TRUE"
		else
			infotextline = infotextline.. "\nGOD: FALSE"
		end
		infotextline = infotextline.. "\nMission Entity: ".. IS_ENTITY_A_MISSION_ENTITY(vehhandle)
		if GET_ENTITY_ATTACHED_TO(vehhandle) != 0 then
			attachedto = GET_ENTITY_ATTACHED_TO(vehhandle)
			if IS_PED_A_PLAYER(attachedto) then
				infotextline = infotextline.. "\nAttached to: ".. players.get_name(NETWORK_GET_PLAYER_INDEX_FROM_PED(attachedto))
			else
				infotextline = infotextline.. "\nAttached to: ".. getmodelnamebyhash(entities.get_model_hash(attachedto))
			end
		end
		if showdebugginfosnearentitys then
			infotextline = infotextline.. "\nModelhash: ".. modelhash.. "\nWorldPosition: " .. "X:" ..math.floor(ePos.x) .. " Y:" ..math.floor(ePos.y) .. " Z:" ..math.floor(ePos.z)
		end
		infotextline = string.replace(infotextline, "true", "TRUE")
		infotextline = string.replace(infotextline, "false", "FALSE")
		textlinemain = textline
		if infosearchnearentitys then
			textline = infotextline
		end
		textline = textline:lower()
		if switchsearchnearentitys then
			if string.match(string.replace(textline, "["..dist.."]", ""), searchnearpickups) and string.len(searchnearpickups) > 0 then
				createmenus = false
			end
		else
			if not string.match(string.replace(textline, "["..dist.."]", ""), searchnearpickups) then
				createmenus = false
			end
		end
		if not table.contains(pickupdata, vehhandle) then
			if createmenus then
			table.insert(pickupdata, vehhandle)
			veh[vehhandle] = menu.list(Entitymanagernearvehiclepickup, textlinemain, {}, infotextline, function(on_click)
				isinfocusthemenu = true
				repeat
					local vehhandle = vehhandle
					local entitypointer = vehpointer
					local pPos = players.get_position(players.user())
					ePos = entities.get_position(vehpointer)
					if showarsignalnearentitys then
						util.draw_ar_beacon(ePos)
					end
					if showlinenearentitys then
						DRAW_LINE(pPos.x, pPos.y, pPos.z, ePos.x, ePos.y, ePos.z, 255, 0, 0, 255)
					end
					if showboxnearentitys then
						draw_bounding_box(vehhandle)
					end
					util.yield()
				until not menu.is_ref_valid(veh[vehhandle]) or not isinfocusthemenu
			end, function(on_back)
				isinfocusthemenu = false
			end)
			local numbertimercall = 0
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Teleport to Pickup", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local entitypPos = entities.get_position(entitypointer)
				SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), entitypPos.x, entitypPos.y, entitypPos.z, false, false, false)
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Teleport to me", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = players.get_position(players.user())
				local entitypPos = entities.get_position(entitypointer)
				if getcontrole(entityhandle) then
					SET_ENTITY_COORDS_NO_OFFSET(entityhandle, mypos.x, mypos.y, mypos.z, false, false, false)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Delete", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = players.get_position(players.user())
				local entitypPos = entities.get_position(entitypointer)
				local dist = math.floor(mypos:distance(entitypPos))
					entities.delete(entityhandle)
			end)
			menu.divider(veh[vehhandle], "Misc")
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Set Entity as mission entity", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = players.get_position(players.user())
				local entitypPos = entities.get_position(entitypointer)
				local dist = math.floor(mypos:distance(entitypPos))
				if getcontrole(entityhandle) then
					SET_ENTITY_AS_MISSION_ENTITY(vehhandle)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Set entitiy as no longer needed", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = players.get_position(players.user())
				local entitypPos = entities.get_position(entitypointer)
				local dist = math.floor(mypos:distance(entitypPos))
				local ent_ptr = memory.alloc_int()
				memory.write_int(ent_ptr, vehhandle)
				if getcontrole(vehhandle) then
					SET_ENTITY_AS_NO_LONGER_NEEDED(ent_ptr)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Set Visible", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +4, 0)
				local entitypPos = entities.get_position(entitypointer)
				if getcontrole(entityhandle) then
					SET_ENTITY_VISIBLE(entityhandle, true, 0)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numbertimercall += 1
			vehinfotab[vehhandle.. numbertimercall] = menu.action(veh[vehhandle], "Set Unvisible", {}, infotextline, function()
				local entityhandle = vehhandle
				local entitypointer = vehpointer
				local entityhash = modelhash
				local entitiyname = modelname
				local mypos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +4, 0)
				local entitypPos = entities.get_position(entitypointer)
				if getcontrole(entityhandle) then
					SET_ENTITY_VISIBLE(entityhandle, false, 0)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end)
			numberfunctioninlist = numbertimercall
			end
		else
			if loadboxonallent and showboxnearentitys then
				draw_bounding_box(vehhandle)
			end
			if menu.is_focused(veh[vehhandle]) then
				if showarsignalnearentitys then
					util.draw_ar_beacon(ePos)
				end
				if showlinenearentitys then
					DRAW_LINE(pPos.x, pPos.y, pPos.z, ePos.x, ePos.y, ePos.z, 255, 0, 0, 255)
				end
				if showboxnearentitys then
					draw_bounding_box(vehhandle)
				end
			end
			if menu.is_ref_valid(veh[vehhandle]) then
				menu.set_menu_name(veh[vehhandle], textlinemain)
				if menu.get_help_text(veh[vehhandle]) != infotextline and menu.is_focused(veh[vehhandle]) then
					menu.set_help_text(veh[vehhandle], infotextline)
				end
			end
			for i = 1, numberfunctioninlist do
				if menu.is_focused(vehinfotab[vehhandle.. i]) then
					if menu.is_ref_valid(vehinfotab[vehhandle.. i]) then
						--[[if menu.is_focused(vehinfotab[vehhandle.. i]) then
							if showarsignalnearentitys then
								util.draw_ar_beacon(ePos)
							end
							if showlinenearentitys then
								DRAW_LINE(pPos.x, pPos.y, pPos.z, ePos.x, ePos.y, ePos.z, 255, 0, 0, 255)
							end
							if showboxnearentitys then
								draw_bounding_box(vehhandle)
							end
						end]]
						if menu.get_help_text(vehinfotab[vehhandle.. i]) != infotextline then
							menu.set_help_text(vehinfotab[vehhandle.. i], infotextline)
						end
					end
				end
			end
		end
		::continue::
	end
	for pickupdata as vehhandle do
		if DOES_ENTITY_EXIST(vehhandle) then
			local vehpointer = entities.handle_to_pointer(vehhandle)
			local pPos = players.get_position(players.user())
			local ePos = entities.get_position(vehpointer)
			local infodist = pPos:distance(ePos)
			local textline = menu.get_menu_name(veh[vehhandle])
			if infosearchnearentitys then
				textline = menu.get_help_text(veh[vehhandle])
			end
			textline = textline:lower()
			local dist = string.strip(textline, "[]")
			if switchsearchnearentitys then
				stringmatcher = string.match(string.replace(textline, "["..dist.."]", ""), searchnearpickups) and string.len(searchnearpickups) > 0
			else
				stringmatcher = not string.match(string.replace(textline, "["..dist.."]", ""), searchnearpickups)
			end
			if (onlymissionnearentitys and not IS_ENTITY_A_MISSION_ENTITY(vehhandle)) or (infodist > maxDistancenearentitys) or (stringmatcher) or (showonlyblibsnearentitys and (GET_BLIP_FROM_ENTITY(vehhandle) == 0)) then
				if menu.is_ref_valid(veh[vehhandle]) then
					menu.delete(veh[vehhandle])
					tableremove(pickupdata, vehhandle)
				end
			end
		elseif not DOES_ENTITY_EXIST(vehhandle) or (onlymissionnearentitys and not IS_ENTITY_A_MISSION_ENTITY(vehhandle)) then
			if menu.is_ref_valid(veh[vehhandle]) then
				menu.delete(veh[vehhandle])
				tableremove(pickupdata, vehhandle)
			end
		end
	end
	::end::
end

menu.divider(Entitymanagernearvehicle, "Settings")
maxDistnearentitys = menu.slider(Entitymanagernearvehicle, "Range to load", {"setdistnearenittys"}, "", 10, 10000, maxDistancenearentitys, 10, function(val)
	maxDistancenearentitys = val
end)
maxDistancenearentitys = menu.get_value(maxDistnearentitys)
boostvaluenearentitys = menu.slider(Entitymanagernearvehicle, "Boost Value", {"setboostvaluenearenittys"}, "", 10, 300, boostvaluetoboostnearentitys, 10, function(val)
	boostvaluetoboostnearentitys = val
end)
boostvaluetoboostnearentitys = menu.get_value(boostvaluenearentitys)
switchsearchtoggleentitys = menu.toggle(Entitymanagernearvehicle, "umgekehrte suche", {}, "Entfernt das was du suchst", function(on)
	switchsearchnearentitys = on
end, switchsearchnearentitys)
switchsearchnearentitys = menu.get_value(switchsearchtoggleentitys)
infosearchtoggleentitys = menu.toggle(Entitymanagernearvehicle, "suche im info fenster", {}, "damit wird im infofenster danach gesucht was du suchst", function(on)
	infosearchnearentitys = on
end, infosearchnearentitys)
infosearchnearentitys = menu.get_value(infosearchtoggleentitys)
onlymissiontoggleentitys = menu.toggle(Entitymanagernearvehicle, "Only Mission entitys", {}, "", function(on)
	onlymissionnearentitys = on
end, onlymissionnearentitys)
onlymissionnearentitys = menu.get_value(onlymissiontoggleentitys)
showplayerstoggleentitys = menu.toggle(Entitymanagernearvehicle, "Show players", {}, "", function(on)
	showplayersnearentitys = on
end, showplayersnearentitys)
showplayersnearentitys = menu.get_value(showplayerstoggleentitys)
onlyblibstoggleentitys = menu.toggle(Entitymanagernearvehicle, "Show only entitys with a blib", {}, "", function(on)
	showonlyblibsnearentitys = on
end, showonlyblibsnearentitys)
showonlyblibsnearentitys = menu.get_value(onlyblibstoggleentitys)
removeattachobjtoggleentitys = menu.toggle(Entitymanagernearvehicle, "Remove attached OBJ in list", {}, "", function(on)
	removeattachobjnearentitys = on
end, removeattachobjnearentitys)
removeattachobjnearentitys = menu.get_value(removeattachobjtoggleentitys)
debugginfostoggleentitys = menu.toggle(Entitymanagernearvehicle, "Show Debug infos in help text", {}, "", function(on)
	showdebugginfosnearentitys = on
end, showdebugginfosnearentitys)
showdebugginfosnearentitys = menu.get_value(debugginfostoggleentitys)
drawarsignalstoggleentitys = menu.toggle(Entitymanagernearvehicle, "Show AR signal", {}, "", function(on)
	showarsignalnearentitys = on
end, showarsignalnearentitys)
showarsignalnearentitys = menu.get_value(drawarsignalstoggleentitys)
drawlinetoggleentitys = menu.toggle(Entitymanagernearvehicle, "Show line", {}, "", function(on)
	showlinenearentitys = on
end, showlinenearentitys)
showlinenearentitys = menu.get_value(drawlinetoggleentitys)
drawboxtoggleentitys = menu.toggle(Entitymanagernearvehicle, "Show Box", {}, "", function(on)
	showboxnearentitys = on
end, showboxnearentitys)
showboxnearentitys = menu.get_value(drawboxtoggleentitys)


menu.action(Self, "Tp waypoint or mission point", {"tpwpob"}, "wenn ein waypoint gesetzt ist geht er da hin wenn keiner da ist geht er zu missions punkt", function()
	if IS_WAYPOINT_ACTIVE() then
		menu.trigger_commands("tpwp")
	else
		menu.trigger_commands("tpobjective")
	end
end)

--shoot gods
menu.toggle_loop(Self, 'Shoot gods', {}, 'Disables godmode for other players when aiming at them. Mostly works on trash menus.', function()
	if IS_PLAYER_FREE_AIMING(players.user()) then
		for players.list_except(true) as pid do
			local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
 			if IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), ped) and not players.is_in_interior(ped) then
				if players.is_godmode(pid) then
					util.trigger_script_event(1 << pid, {800157557, pid, 225624744, math.random(0, 9999)})
				end
			end
		end
	end
end)

local ghostplayertable = {}
--IS_PLAYER_FREE_AIMING_AT_ENTITY(pid, players.user_ped()) or IS_PLAYER_FREE_AIMING_AT_ENTITY(pid, vehicleped)
ghostarmedplayers = menu.toggle_loop(Self, "Ghost Armed Players", {}, "macht godmode spieler zum geist für dich wenn sie auf dich ziehlen. \nwird nicht gehen wenn du godmode an hast weil du da ja eh unsterblich bist", function()
for players.list_except(true) as pid do
	local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
	local pedplayer = GET_PLAYER_PED_SCRIPT_INDEX(players.user())
	godmodeon = menu.get_value(menu.ref_by_path("Self>Immortality"))
	vehiclegodmode = menu.get_value(menu.ref_by_path("Vehicle>Indestructible"))
	local vehicleped = GET_VEHICLE_PED_IS_IN(players.user_ped())
	local pc = players.get_position(players.user())
	local cc = players.get_position(pid)
		if IS_PED_ARMED(ped, 7) and IS_PLAYER_FREE_AIMING(pid) and IS_PED_FACING_PED(ped, pedplayer, 15) and not players.is_in_interior(pid) then
			if players.is_godmode(pid) and not godmodeon then
				SET_REMOTE_PLAYER_AS_GHOST(pid, true)
				if not table.contains(ghostplayertable, pid) then
					table.insert(ghostplayertable, pid)
				end
			end
		elseif (VDIST2(pc.x, pc.y, pc.z, cc.x, cc.y, cc.z) <= 10)and IS_PED_ARMED(ped, 7) and not players.is_in_interior(pid) then
			if players.is_godmode(pid) and not godmodeon then
				SET_REMOTE_PLAYER_AS_GHOST(pid, true)
				if not table.contains(ghostplayertable, pid) then
					table.insert(ghostplayertable, pid)
				end
			end
		else
			if table.contains(ghostplayertable, pid) then
				--for ghostplayertable as pid do
					SET_REMOTE_PLAYER_AS_GHOST(pid, false)
					tableremove(ghostplayertable, pid)
				--end
			end
		end
end
end, function(on_stop)
for players.list_except(true) as pid do
	SET_REMOTE_PLAYER_AS_GHOST(pid, false)
end
end)
local levispeed = menu.get_state(menu.ref_by_path("Self>Movement>Levitation>Movement Speed"))
local levisprintspeed = menu.get_state(menu.ref_by_path("Self>Movement>Levitation>Sprint Multiplier"))
local levimindistground = menu.get_state(menu.ref_by_path("Self>Movement>Levitation>Min Distance From Ground"))
local levimaxdistground = menu.get_state(menu.ref_by_path("Self>Movement>Levitation>Max Distance From Ground"))
local levispeedupdown = menu.get_state(menu.ref_by_path("Self>Movement>Levitation>Speed"))
local leviupwardsstrenth = menu.get_state(menu.ref_by_path("Self>Movement>Levitation>Upward Force"))
local levidownwardsstrenth = menu.get_state(menu.ref_by_path("Self>Movement>Levitation>Downward Force"))
local levidownkillzone = menu.get_state(menu.ref_by_path("Self>Movement>Levitation>Downward Deadzone"))
local levicatch = menu.get_state(menu.ref_by_path("Self>Movement>Levitation>Snapping"))

local islevithingon = false

menu.toggle_loop(Self, "Levitation Interior", {}, "setzt z.b in gebäude die settings so um das du nicht mega schnell bist und nicht einfach rausfliegst\nbereiche wo eingestellt wird:\nInennräume", function()
	if players.is_in_interior(players.user()) then
		islevithingon = true
		menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Movement Speed"), 0.1)
		menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Sprint Multiplier"), 2.00)
		menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Min Distance From Ground"), 0.0)
		menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Max Distance From Ground"), 0.0)
		menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Speed"), 0)
		menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Upward Force"), 0.0)
		menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Downward Force"), 0.0)
		menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Downward Deadzone"), 0)
		menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Snapping"), 0.0)
	else
		if islevithingon then
			menu.set_state(menu.ref_by_path("Self>Movement>Levitation>Movement Speed"), levispeed)
			menu.set_state(menu.ref_by_path("Self>Movement>Levitation>Sprint Multiplier"), levisprintspeed)
			menu.set_state(menu.ref_by_path("Self>Movement>Levitation>Min Distance From Ground"), levimindistground)
			menu.set_state(menu.ref_by_path("Self>Movement>Levitation>Max Distance From Ground"), levimaxdistground)
			menu.set_state(menu.ref_by_path("Self>Movement>Levitation>Speed"), levispeedupdown)
			menu.set_state(menu.ref_by_path("Self>Movement>Levitation>Upward Force"), leviupwardsstrenth)
			menu.set_state(menu.ref_by_path("Self>Movement>Levitation>Downward Force"), levidownwardsstrenth)
			menu.set_state(menu.ref_by_path("Self>Movement>Levitation>Downward Deadzone"), levidownkillzone)
			menu.set_state(menu.ref_by_path("Self>Movement>Levitation>Snapping"), levicatch)
			islevithingon = false
		end
	end
end, function(on_stop)
	if islevithingon then
		menu.set_state(menu.ref_by_path("Self>Movement>Levitation>Movement Speed"), levispeed)
		menu.set_state(menu.ref_by_path("Self>Movement>Levitation>Sprint Multiplier"), levisprintspeed)
		menu.set_state(menu.ref_by_path("Self>Movement>Levitation>Min Distance From Ground"), levimindistground)
		menu.set_state(menu.ref_by_path("Self>Movement>Levitation>Max Distance From Ground"), levimaxdistground)
		menu.set_state(menu.ref_by_path("Self>Movement>Levitation>Speed"), levispeedupdown)
		menu.set_state(menu.ref_by_path("Self>Movement>Levitation>Upward Force"), leviupwardsstrenth)
		menu.set_state(menu.ref_by_path("Self>Movement>Levitation>Downward Force"), levidownwardsstrenth)
		menu.set_state(menu.ref_by_path("Self>Movement>Levitation>Downward Deadzone"), levidownkillzone)
		menu.set_state(menu.ref_by_path("Self>Movement>Levitation>Snapping"), levicatch)
		islevithingon = false
	end
end)

--[[if IS_PED_IN_ANY_VEHICLE(ped,true) then
players.is_godmode(pid) and 
IS_PLAYER_FREE_AIMING_AT_ENTITY(pid, players.user_ped()) or 
	local vehicleped = players.get_vehicle_model(players.user())
	if IS_PED_ARMED(ped, 7) and IS_PLAYER_FREE_AIMING(pid) and IS_PLAYER_FREE_AIMING_AT_ENTITY(vehicleped, players.user_ped()) and not players.is_in_interior(pid) then
		if not vehiclegodmode then
			SET_REMOTE_PLAYER_AS_GHOST(pid, true)
		end
	else
		SET_REMOTE_PLAYER_AS_GHOST(pid, false)
	end
else]]
--or GET_IS_TASK_ACTIVE(ped, 199) or GET_IS_TASK_ACTIVE(ped, 128)  and not is_in_interior(pid) 

local timerforafk = 120
local timegerade = util.current_time_millis()
local ghostplayer = false
menu.toggle_loop(Self, "anti afk kill", {}, "", function()
	if not util.is_session_transition_active() then
		local ismovingon = false
		if IS_PED_IN_ANY_VEHICLE(players.user_ped()) and GET_PED_IN_VEHICLE_SEAT(GET_VEHICLE_PED_IS_USING(players.user_ped()), -1) != players.user_ped() then
			if isMoving(players.user_ped()) then
				ismovingon = true
			end
		end
		if isanykeypressed() or ismovingon  then
			timegerade = util.current_time_millis()
			if ghostplayer then
				menu.set_value(ghostarmedplayers, true)
				for players.list(false, true, true) as pid do
					SET_REMOTE_PLAYER_AS_GHOST(pid, false)
				end
				ghostplayer = false
			end
			if not menu.get_value(ghostarmedplayers) then
				for players.list(false, true, true) as pid do
					SET_REMOTE_PLAYER_AS_GHOST(pid, false)
				end
			end
		elseif not isanykeypressed() then
			if (util.current_time_millis() - timegerade) >= (timerforafk * 1000) then
				if menu.get_value(ghostarmedplayers) then
					ghostplayer = true
					menu.set_value(ghostarmedplayers, false)
				end
				for players.list(false, true, true) as pid do
					SET_REMOTE_PLAYER_AS_GHOST(pid, true)
				end
				util.draw_debug_text("[AFK] Spieler sind im Ghost")
			end
		end
	end
end)

menu.toggle_loop(Self, "anti idle cam", {}, "", function()
	local timer = 0
	if not isanykeypressed() then
		repeat
			util.yield()
			timer += 1
			if isanykeypressed() then
				break
			end
		until timer == 1000
		if timer >= 999 then
			INVALIDATE_IDLE_CAM()
		end
	end
end)

auswahlauusmachen = menu.list(Zeugforjob, "selbst auswahl für aus machen", {}, "kannst sagen was nicht aus gemacht werden muss\nmach am besste nichts an oder aus wärend du sachen aus machen lässt")

local commandreftableforjob = {}

local deactivatejobtable = {
	[1]= "Self>Weapons>Lock Weapons>Lock Weapons",
	[2]= "Online>Transitions>Matchmaking>Region Override>Region Override",
	[3]= "Online>Transitions>Matchmaking>Pool Override>Pool Override",
	[4]= "Online>Transitions>Seamless Session Switching>Seamless Session Switching",
	[5]= "Online>Transitions>Speed Up>Don't Ask For Permission To Spawn",
	[6]= "Online>Transitions>Speed Up>Don't Wait For Mission Launcher",
	[7]= "Online>Transitions>Speed Up>Don't Wait For Data Broadcast",
	[8]= "Online>Transitions>Skip Swoop Down",
	[9]= "Online>Protections>Delete Modded Pop Multiplier Areas",
	[10]= "Online>Protections>Block Entity Spam>Block Entity Spam",
	[11]= "Game>Disables>Disable Restricted Areas",
	[12]= "Self>Lock Wanted Level",
	[13]= "Online>Spoofing>Host Token Spoofing>Host Token Spoofing",
	[14]= "Stand>Lua Scripts>"..SCRIPT_NAME..">Zeug für mich angepasst>alle waffen immer",
	[15]= "Online>Transitions>Join Group Override"}

function loadtoggleoptionjobs()
	for i, adress in pairs(deactivatejobtable) do
		if commandreftableforjob[i] == nil or not menu.is_ref_valid(commandreftableforjob[i]) then
			menuname = menu.get_menu_name(menu.ref_by_path(adress))
			commandreftableforjob[i] = menu.toggle(auswahlauusmachen, menuname, {}, adress, function(on_toggle)
				if on_toggle then togglething = true else togglething = false end
			end)
		end
	end
end

function jobthingdeactivateeverything()
	for i, adress in pairs(commandreftableforjob) do
		if menu.is_ref_valid(commandreftableforjob[i]) then
			if not menu.get_value(commandreftableforjob[i]) then
				menu.apply_default_state(menu.ref_by_path(menu.get_help_text(commandreftableforjob[i])))
				if not menu.get_value(menu.ref_by_path(menu.get_help_text(commandreftableforjob[i]))) then
					menu.trigger_command(menu.ref_by_path(menu.get_help_text(commandreftableforjob[i])), false)
					util.toast(lang.get_string(menu.get_menu_name(commandreftableforjob[i])).. " OFF", TOAST_CONSOLE)
				end
			end
		end
	end
end

function jobzuegwiederanmachen()
	menu.set_value(menu.ref_by_path("Self>Weapons>Lock Weapons>Lock Weapons"), Lockweapons)
	menu.set_value(menu.ref_by_path("Self>Lock Wanted Level"), wantedlevel)
	menu.set_value(menu.ref_by_path("Stand>Lua Scripts>"..SCRIPT_NAME..">Zeug für mich angepasst>alle waffen immer"), allweapons)
	menu.set_value(menu.ref_by_path("Online>Transitions>Matchmaking>Region Override>Region Override"), Regionsmatch)
	menu.set_value(menu.ref_by_path("Online>Transitions>Matchmaking>Pool Override>Pool Override"), poolOver)
	menu.set_value(menu.ref_by_path("Online>Transitions>Seamless Session Switching>Seamless Session Switching"), seamlessswitch)
	menu.set_value(menu.ref_by_path("Online>Transitions>Speed Up>Don't Wait For Data Broadcast"), Broadcastdata)
	menu.set_value(menu.ref_by_path("Online>Transitions>Speed Up>Don't Wait For Mission Launcher"), Lauchnermission)
	menu.set_value(menu.ref_by_path("Online>Transitions>Speed Up>Don't Ask For Permission To Spawn"), permissionspawn)
	menu.set_value(menu.ref_by_path("Online>Transitions>Skip Swoop Down"), swoopdown)
	menu.set_value(menu.ref_by_path("Online>Protections>Delete Modded Pop Multiplier Areas"), multiplierareas)
	menu.set_value(menu.ref_by_path("Online>Protections>Block Entity Spam>Block Entity Spam"), Entityspamzeug)
	menu.set_value(menu.ref_by_path("Game>Disables>Disable Restricted Areas"), restrictedareas)
	menu.set_value(menu.ref_by_path("Online>Spoofing>Host Token Spoofing>Host Token Spoofing"), hosttokenspoof)
	menu.set_value(menu.ref_by_path("Online>Transitions>Join Group Override"), groupoveride)
end

menu.toggle(Zeugforjob, "Zeug für Job aus machen", {}, "Macht zeug aus damit in missionen weniger probleme kommen können", function(on_toggle)
	if on_toggle then
		Lockweapons = menu.get_value(menu.ref_by_path("Self>Weapons>Lock Weapons>Lock Weapons"))
		Regionsmatch = menu.get_value(menu.ref_by_path("Online>Transitions>Matchmaking>Region Override>Region Override"))
		poolOver = menu.get_value(menu.ref_by_path("Online>Transitions>Matchmaking>Pool Override>Pool Override"))
		seamlessswitch = menu.get_value(menu.ref_by_path("Online>Transitions>Seamless Session Switching>Seamless Session Switching"))
		permissionspawn = menu.get_value(menu.ref_by_path("Online>Transitions>Speed Up>Don't Ask For Permission To Spawn"))
		Lauchnermission = menu.get_value(menu.ref_by_path("Online>Transitions>Speed Up>Don't Wait For Mission Launcher"))
		Broadcastdata = menu.get_value(menu.ref_by_path("Online>Transitions>Speed Up>Don't Wait For Data Broadcast"))
		swoopdown = menu.get_value(menu.ref_by_path("Online>Transitions>Skip Swoop Down"))
		multiplierareas = menu.get_value(menu.ref_by_path("Online>Protections>Delete Modded Pop Multiplier Areas"))
		Entityspamzeug = menu.get_value(menu.ref_by_path("Online>Protections>Block Entity Spam>Block Entity Spam"))
		restrictedareas = menu.get_value(menu.ref_by_path("Game>Disables>Disable Restricted Areas"))
		wantedlevel = menu.get_value(menu.ref_by_path("Self>Lock Wanted Level"))
		hosttokenspoof = menu.get_value(menu.ref_by_path("Online>Spoofing>Host Token Spoofing>Host Token Spoofing"))
		allweapons = menu.get_value(menu.ref_by_path("Stand>Lua Scripts>"..SCRIPT_NAME..">Zeug für mich angepasst>alle waffen immer"))
		groupoveride = menu.get_value(menu.ref_by_path("Online>Transitions>Join Group Override"))

		zeugforthejob = true
		jobthingdeactivateeverything()
	else
		zeugforthejob = false
		jobzuegwiederanmachen()
	end
end)

function zeugwiederan()
	if zeugforthejob then
		jobzuegwiederanmachen()
	end
end

util.on_pre_stop(zeugwiederan)

menu.action(Zeugforjob, "Teleport Pickups To Me", {}, "teleportiert sachen zum aufheben zu dir", function()
    local counter = 0
    local pos = players.get_position(players.user())
    for entities.get_all_pickups_as_handles() as pickup do
		if getcontrole(pickup) then
        	SET_ENTITY_COORDS(pickup, pos, false, false, false, false)
        	counter += 1
        	util.yield()
		else
			util.toast("cant get control")
		end
    end
    if counter == 0 then
        util.toast("No Pickups Found. :/")
    else
        util.toast("Teleported ".. tostring(counter) .." Pickups.")
    end
end)

function createmanagenearbypedscams(on)
	if not on then
	NEARPEDCAMremoveweapons = menu.attach_after(NEARPEDCAMignore, menu.action(menu.shadow_root(), "Remove Weapons", {}, "", function()
		local numberofpeds = 0
		for _, ped in pairs(entities.get_all_peds_as_handles()) do
			if IS_PLAYER_PED(ped) or IS_ENTITY_DEAD(ped) then goto out end
			if reactonredblips then
				if isentitiyaenemie(ped) then goto getthem else goto out end
			end
			::getthem::
			if nearpedcamrange != 0 then
				pPos = players.get_position(players.user())
				ePos = entities.get_position(entities.handle_to_pointer(ped))
				local dist = pPos:distance(ePos)
				if nearpedcamrange < dist then
					goto out
				end
			end
			numberofpeds += 1
			REMOVE_ALL_PED_WEAPONS(ped, true)
			::out::
		end
		util.toast("Removed Weapons from ".. numberofpeds.. " Peds")
	end))
	NEARPEDCAMdelete = menu.attach_after(NEARPEDCAMremoveweapons, menu.action(menu.shadow_root(), "Delete", {}, "", function()
		local numberofpeds = 0
		for _, ped in pairs(entities.get_all_peds_as_handles()) do
			if IS_PLAYER_PED(ped) or IS_ENTITY_DEAD(ped) then goto out end
			if reactonredblips then
				if isentitiyaenemie(ped) then goto getthem else goto out end
			end
			::getthem::
			if nearpedcamrange != 0 then
				pPos = players.get_position(players.user())
				ePos = entities.get_position(entities.handle_to_pointer(ped))
				local dist = pPos:distance(ePos)
				if nearpedcamrange < dist then
					goto out
				end
			end
			numberofpeds += 1
			entities.delete(ped)
			::out::
		end
		util.toast("Deleted ".. numberofpeds.. " Peds")
	end))
	NEARPEDCAMkill = menu.attach_after(NEARPEDCAMdelete, menu.action(menu.shadow_root(), "Kill", {}, "", function()
		local numberofpeds = 0
		for _, ped in pairs(entities.get_all_peds_as_handles()) do
			if IS_PLAYER_PED(ped) or IS_ENTITY_DEAD(ped) then goto out end
			if reactonredblips then
				if isentitiyaenemie(ped) then goto getthem else goto out end
			end
			::getthem::
			if nearpedcamrange != 0 then
				pPos = players.get_position(players.user())
				ePos = entities.get_position(entities.handle_to_pointer(ped))
				local dist = pPos:distance(ePos)
				if nearpedcamrange < dist then
					goto out
				end
			end
			numberofpeds += 1
			SET_ENTITY_HEALTH(ped, 0, 0)
			::out::
		end
		util.toast("Killed ".. numberofpeds.. " Peds")
	end))
	NEARPEDCAMshoot = menu.attach_after(NEARPEDCAMkill, menu.action(menu.shadow_root(), "Shoot", {}, "", function()
		local numberofpeds = 0
		for _, ped in pairs(entities.get_all_peds_as_handles()) do
			if IS_PLAYER_PED(ped) or IS_ENTITY_DEAD(ped) then goto out end
			if reactonredblips then
				if isentitiyaenemie(ped) then goto getthem else goto out end
			end
			::getthem::
			if nearpedcamrange != 0 then
				pPos = players.get_position(players.user())
				ePos = entities.get_position(entities.handle_to_pointer(ped))
				local dist = pPos:distance(ePos)
				if nearpedcamrange < dist then
					goto out
				end
			end
			if GET_VEHICLE_PED_IS_USING(ped) ~= 0 then CLEAR_PED_TASKS_IMMEDIATELY(ped) end
			local PedPos = GET_ENTITY_COORDS(ped)
			local AddPos = GET_ENTITY_COORDS(ped)
			AddPos.z = AddPos.z + 1
			numberofpeds += 1
			SHOOT_SINGLE_BULLET_BETWEEN_COORDS(AddPos.x, AddPos.y, AddPos.z, PedPos.x, PedPos.y, PedPos.z, 1000, false, 0xC472FE2, players.user_ped(), false, true, 1000)
			::out::
		end
		util.toast("Shoot ".. numberofpeds.. " Peds")
	end))
	NEARPEDCAMcamtaze = menu.attach_after(NEARPEDCAMdividercams, menu.action(menu.shadow_root(), "Taze", {}, "", function()
		local numberofcams = 0
		for _, ent in pairs(entities.get_all_objects_as_handles()) do
			for __, cam in pairs(AllCamLists) do
				if GET_ENTITY_MODEL(ent) == cam then
					local CamPos = GET_ENTITY_COORDS(ent)
					local AddPos = GET_ENTITY_COORDS(ent)
					AddPos.z = AddPos.z + 1
					if nearpedcamrange != 0 then
						pPos = players.get_position(players.user())
						ePos = entities.get_position(entities.handle_to_pointer(ent))
						local dist = pPos:distance(ePos)
						if nearpedcamrange < dist then
							goto end
						end
					end
					numberofcams += 1
					SHOOT_SINGLE_BULLET_BETWEEN_COORDS(AddPos.x, AddPos.y, AddPos.z, CamPos.x, CamPos.y, CamPos.z, 1000, false, 0x3656C8C1, players.user_ped(), false, true, 1000)
					::end::
				end
			end
		end
		util.toast("Tazed ".. numberofcams.. " Cams")
	end))
	NEARPEDCAMcamdelete = menu.attach_after(NEARPEDCAMcamtaze, menu.action(menu.shadow_root(), "Delete", {}, "", function()
		local numberofcams = 0
		for _, cam in pairs(AllCamLists) do
			for _, ent in pairs(entities.get_all_objects_as_handles()) do
				if GET_ENTITY_MODEL(ent) == cam then
					if nearpedcamrange != 0 then
						pPos = players.get_position(players.user())
						ePos = entities.get_position(entities.handle_to_pointer(ent))
						local dist = pPos:distance(ePos)
						if nearpedcamrange < dist then
							goto end
						end
					end
					numberofcams += 1
					entities.delete(ent)
					::end::
				end
			end
		end
		util.toast("Deleted ".. numberofcams.. " Cams")
	end))
	else
		NEARPEDCAMremoveweaponsloop = menu.attach_after(NEARPEDCAMignore, menu.toggle_loop(menu.shadow_root(), "Remove Weapons", {}, "", function()
			local numberofpeds = 0
			for _, ped in pairs(entities.get_all_peds_as_handles()) do
				if IS_PLAYER_PED(ped) or IS_ENTITY_DEAD(ped) then goto out end
				if reactonredblips then
					if isentitiyaenemie(ped) then goto getthem else goto out end
				end
				::getthem::
				if nearpedcamrange != 0 then
					pPos = players.get_position(players.user())
					ePos = entities.get_position(entities.handle_to_pointer(ped))
					local dist = pPos:distance(ePos)
					if nearpedcamrange < dist then
						goto out
					end
				end
				numberofpeds += 1
				REMOVE_ALL_PED_WEAPONS(ped, true)
				::out::
			end
			util.draw_debug_text("Remove Weapons Loop: Aktive")
			--util.toast("Removed Weapons from ".. numberofpeds.. " Peds")
		end))
		NEARPEDCAMdeleteloop = menu.attach_after(NEARPEDCAMremoveweaponsloop, menu.toggle_loop(menu.shadow_root(), "Delete", {}, "", function()
			local numberofpeds = 0
			for _, ped in pairs(entities.get_all_peds_as_handles()) do
				if IS_PLAYER_PED(ped) or IS_ENTITY_DEAD(ped) then goto out end
				if reactonredblips then
					if isentitiyaenemie(ped) then goto getthem else goto out end
				end
				::getthem::
				if nearpedcamrange != 0 then
					pPos = players.get_position(players.user())
					ePos = entities.get_position(entities.handle_to_pointer(ped))
					local dist = pPos:distance(ePos)
					if nearpedcamrange < dist then
						goto out
					end
				end
				numberofpeds += 1
				entities.delete(ped)
				::out::
			end
			util.draw_debug_text("Delete peds Loop: Aktive")
			--util.toast("Deleted ".. numberofpeds.. " Peds")
		end))
		NEARPEDCAMkillloop = menu.attach_after(NEARPEDCAMdeleteloop, menu.toggle_loop(menu.shadow_root(), "Kill", {}, "", function()
			local numberofpeds = 0
			for _, ped in pairs(entities.get_all_peds_as_handles()) do
				if IS_PLAYER_PED(ped) or IS_ENTITY_DEAD(ped) then goto out end
				if reactonredblips then
					if isentitiyaenemie(ped) then goto getthem else goto out end
				end
				::getthem::
				if nearpedcamrange != 0 then
					pPos = players.get_position(players.user())
					ePos = entities.get_position(entities.handle_to_pointer(ped))
					local dist = pPos:distance(ePos)
					if nearpedcamrange < dist then
						goto out
					end
				end
				numberofpeds += 1
				SET_ENTITY_HEALTH(ped, 0, 0)
				::out::
			end
			util.draw_debug_text("Kill Loop: Aktive")
			--util.toast("Killed ".. numberofpeds.. " Peds")
		end))
		NEARPEDCAMshootloop = menu.attach_after(NEARPEDCAMkillloop, menu.toggle_loop(menu.shadow_root(), "Shoot", {}, "", function()
			local numberofpeds = 0
			for _, ped in pairs(entities.get_all_peds_as_handles()) do
				if IS_PLAYER_PED(ped) or IS_ENTITY_DEAD(ped) then goto out end
				if reactonredblips then
					if isentitiyaenemie(ped) then goto getthem else goto out end
				end
				::getthem::
				if nearpedcamrange != 0 then
					pPos = players.get_position(players.user())
					ePos = entities.get_position(entities.handle_to_pointer(ped))
					local dist = pPos:distance(ePos)
					if nearpedcamrange < dist then
						goto out
					end
				end
				if GET_VEHICLE_PED_IS_USING(ped) ~= 0 then CLEAR_PED_TASKS_IMMEDIATELY(ped) end
				local PedPos = GET_ENTITY_COORDS(ped)
				local AddPos = GET_ENTITY_COORDS(ped)
				AddPos.z = AddPos.z + 1
				numberofpeds += 1
				SHOOT_SINGLE_BULLET_BETWEEN_COORDS(AddPos.x, AddPos.y, AddPos.z, PedPos.x, PedPos.y, PedPos.z, 1000, false, 0xC472FE2, players.user_ped(), false, true, 1000)
				::out::
			end
			util.draw_debug_text("Shoot Peds Loop: Aktive")
			--util.toast("Shoot ".. numberofpeds.. " Peds")
		end))
		NEARPEDCAMcamtazeloop = menu.attach_after(NEARPEDCAMdividercams, menu.toggle_loop(menu.shadow_root(), "Taze", {}, "", function()
			local numberofcams = 0
			for _, ent in pairs(entities.get_all_objects_as_handles()) do
				for __, cam in pairs(AllCamLists) do
					if GET_ENTITY_MODEL(ent) == cam then
						local CamPos = GET_ENTITY_COORDS(ent)
						local AddPos = GET_ENTITY_COORDS(ent)
						AddPos.z = AddPos.z + 1
						if nearpedcamrange != 0 then
							pPos = players.get_position(players.user())
							ePos = entities.get_position(entities.handle_to_pointer(ent))
							local dist = pPos:distance(ePos)
							if nearpedcamrange < dist then
								goto end
							end
						end
						numberofcams += 1
						SHOOT_SINGLE_BULLET_BETWEEN_COORDS(AddPos.x, AddPos.y, AddPos.z, CamPos.x, CamPos.y, CamPos.z, 1000, false, 0x3656C8C1, players.user_ped(), false, true, 1000)
						::end::
					end
				end
			end
			util.draw_debug_text("Taze Cams Loop: Aktive")
			--util.toast("Tazed ".. numberofcams.. " Cams")
		end))
		NEARPEDCAMcamdeleteloop = menu.attach_after(NEARPEDCAMcamtazeloop, menu.toggle_loop(menu.shadow_root(), "Delete", {}, "", function()
			local numberofcams = 0
			for _, cam in pairs(AllCamLists) do
				for _, ent in pairs(entities.get_all_objects_as_handles()) do
					if GET_ENTITY_MODEL(ent) == cam then
						if nearpedcamrange != 0 then
							pPos = players.get_position(players.user())
							ePos = entities.get_position(entities.handle_to_pointer(ent))
							local dist = pPos:distance(ePos)
							if nearpedcamrange < dist then
								goto end
							end
						end
						numberofcams += 1
						entities.delete(ent)
						::end::
					end
				end
			end
			util.draw_debug_text("Delete Cams Loop: Aktive")
			--util.toast("Deleted ".. numberofcams.. " Cams")
		end))
	end
	return
end

function nearpedcamsloadsphere()
	if not loadspherethindtoggle then
		return false
	end
	if nearpedcamrange == 0 then
		return
	end
	local pPos = players.get_position(players.user())
	if NEARPEDCAMrange:isFocused() then
		loadsphereninrangered(nearpedcamrange, pPos)
	end
end

nearpedcamrange = 0
colorpedcam = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 }
NEAR_PED_CAM = menu.list(Zeugforjob, "Manage Nearby Peds And Cams", {}, "", function(on_click)
	loadspherethindtoggle = true
	util.create_tick_handler(nearpedcamsloadsphere)
end, function(on_back)
	loadspherethindtoggle = false
end)

NEARPEDCAMlooptoggle = menu.toggle(NEAR_PED_CAM, "Make it to loop", {}, "", function(on_toggle)
	if on_toggle then
		menu.delete(NEARPEDCAMremoveweapons)
		menu.delete(NEARPEDCAMdelete)
		menu.delete(NEARPEDCAMkill)
		menu.delete(NEARPEDCAMshoot)
		menu.delete(NEARPEDCAMcamtaze)
		menu.delete(NEARPEDCAMcamdelete)
		createmanagenearbypedscams(true)
	else
		if menu.get_value(NEARPEDCAMremoveweaponsloop) then menu.default_and_delete(NEARPEDCAMremoveweaponsloop) else menu.delete(NEARPEDCAMremoveweaponsloop) end
		if menu.get_value(NEARPEDCAMdeleteloop) then menu.default_and_delete(NEARPEDCAMdeleteloop) else	menu.delete(NEARPEDCAMdeleteloop) end
		if menu.get_value(NEARPEDCAMkillloop) then menu.default_and_delete(NEARPEDCAMkillloop) else menu.delete(NEARPEDCAMkillloop) end
		if menu.get_value(NEARPEDCAMshootloop) then menu.default_and_delete(NEARPEDCAMshootloop) else menu.delete(NEARPEDCAMshootloop) end
		if menu.get_value(NEARPEDCAMcamtazeloop) then menu.default_and_delete(NEARPEDCAMcamtazeloop) else menu.delete(NEARPEDCAMcamtazeloop) end
		if menu.get_value(NEARPEDCAMcamdeleteloop) then menu.default_and_delete(NEARPEDCAMcamdeleteloop) else menu.delete(NEARPEDCAMcamdeleteloop) end
		createmanagenearbypedscams()
	end
end)

NEARPEDCAMdividerpeds = menu.divider(NEAR_PED_CAM, "Peds")

NEARPEDCAMignore = menu.toggle_loop(NEAR_PED_CAM, "Ignore You", {}, "Makes hostile peds (Included guards, polices, and gangs) ignore you even saw you. Except for the rare case, they don't shoot to you.", function()
	SET_EVERYONE_IGNORE_PLAYER(players.user(), true)
end, function()
	SET_EVERYONE_IGNORE_PLAYER(players.user(), false)
end)

NEARPEDCAMdividercams = menu.divider(NEAR_PED_CAM, "Cameras")

AllCamLists = {
	util.joaat("prop_cctv_cam_01a"),
	util.joaat("prop_cctv_cam_01b"),
	util.joaat("prop_cctv_cam_02a"),
	util.joaat("prop_cctv_cam_03a"),
	util.joaat("prop_cctv_cam_04a"),
	util.joaat("prop_cctv_cam_04c"),
	util.joaat("prop_cctv_cam_05a"),
	util.joaat("prop_cctv_cam_06a"),
	util.joaat("prop_cctv_cam_07a"),
	util.joaat("prop_cctv_POLE_04"),
	util.joaat("prop_cs_cctv"),
	util.joaat("p_cctv_s"),
	util.joaat("hei_prop_bank_cctv_01"),
	util.joaat("hei_prop_bank_cctv_02"),
	util.joaat("ch_prop_ch_cctv_cam_02a"),
	util.joaat("xm_prop_x17_server_farm_cctv_01"),
}

createmanagenearbypedscams()
menu.divider(NEAR_PED_CAM, "Settings")

menu.toggle(NEAR_PED_CAM, "only react on enemies", {}, "Ausgeschloßen: cams, ignore you", function(on_toggle)
	if on_toggle then
		reactonredblips = true
	else
		reactonredblips = false
	end
end)

NEARPEDCAMrange = menu.slider(NEAR_PED_CAM, "Only in area", {"clearpedcamsnear"}, "wenn 0 dann wird es auf alle benutzt die es findet", 0, 1000, 0, 25, function (value)
	nearpedcamrange = value
end)

function request_anim_dict(dict)
    request_time = os.time()
    if not DOES_ANIM_DICT_EXIST(dict) then
        return
    end
    REQUEST_ANIM_DICT(dict)
    while not HAS_ANIM_DICT_LOADED(dict) do
        if os.time() - request_time >= 10 then
            break
        end
        util.yield()
    end
end

menu.text_input(Self, "Claim auto", {"claimautoinput"}, "Schreib die zahl rein von dem auto das spawnen soll.\nsiehst du wenn du den command pvs benutzt dann kannst dein auto suchen und als befehlt steht dann welche zahl da ist", function(input)
	name = input
end, '')

menu.action(Self, "Claim all vehicles", {"claimallvehicles"}, "Claims all vehicles destroyed from Mors Mutual.\nEs werden einfach alle autos durch stand angefordert und das letzte was angefordert wurde steht dann halt als persönliches auto da", function ()
	reclaimVehicles()
	if name ~= number then
		menu.trigger_commands("pv".. name .."request")
	end
end)

menu.toggle_loop(Entitymanager, "Entity aim Controle", {}, "", function()
	local entpointer = memory.alloc()
	local aimeintity = GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(players.user(), entpointer)
	local handle = memory.read_int(entpointer)
	local lightattack = menu.get_value(menu.ref_by_path("Game>Disables>Disable Game Inputs>MELEE_ATTACK_LIGHT"))
	local grenade = menu.get_value(menu.ref_by_path("Game>Disables>Disable Game Inputs>THROW_GRENADE"))
	local vehexit = menu.get_value(menu.ref_by_path("Game>Disables>Disable Game Inputs>VEH_EXIT"))
	local vehenter = menu.get_value(menu.ref_by_path("Game>Disables>Disable Game Inputs>ENTER"))
	if schwerkraftan then
		if is_key_just_down('VK_E') and IS_PLAYER_FREE_AIMING(players.user()) then
			menu.trigger_command(menu.ref_by_path("Self>Weapons>Gravity Gun>Gravity Gun"), false)
		end
	end
	if not IS_PED_ARMED(players.user_ped(), 4) then
		directx.draw_circle(0.5, 0.5, 0.001, {r=1,g=0,b=1,a=0.8})
	end
	menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>MELEE_ATTACK_LIGHT"), true)
	menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>THROW_GRENADE"), true)
	menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>VEH_EXIT"), false)
	menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>ENTER"), false)
	if GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(players.user(), entpointer) then
		if GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(players.user(), entpointer) and IS_ENTITY_A_VEHICLE(handle) or IS_PED_IN_ANY_VEHICLE(handle,true) then
			menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>VEH_EXIT"), true)
			menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>ENTER"), true)
		end
	local godmodeentity = GET_ENTITY_CAN_BE_DAMAGED(handle) if godmodeentity then godmodeentity1 = false else godmodeentity1 = true end
	local visibleentitiy = IS_ENTITY_VISIBLE(handle)
	local deadentity = IS_ENTITY_DEAD(handle)
	local missionentity = IS_ENTITY_A_MISSION_ENTITY(handle)
	local speedentity = GET_ENTITY_SPEED(handle) * 3.6
	speedentity1 = roundDecimals(speedentity, 1)
	local modelhashentity = GET_ENTITY_MODEL(handle)
	local modelname = getmodelnamebyhash(modelhashentity)
	local healthentity = GET_ENTITY_HEALTH(handle)
	local ownerentity = entities.get_owner(handle)
	local namefromplayer = players.get_name(ownerentity)
	local textline = ""
	x = 0.52
	y = 0.54
	y10 = 0.90 --info fenster unten
	schwerkraftan = menu.get_value(menu.ref_by_path("Self>Weapons>Gravity Gun>Gravity Gun"))
		if IS_ENTITY_A_PED(handle) then
			if IS_PED_IN_ANY_VEHICLE(handle,true) and not IS_PED_A_PLAYER(handle) then
				local vehicleding = GET_VEHICLE_PED_IS_IN(handle)
				local healthentity1 = GET_ENTITY_HEALTH(vehicleding)
				local godmodeentity2 = GET_ENTITY_CAN_BE_DAMAGED(vehicleding) if godmodeentity2 then godmodeentity3 = false else godmodeentity3 = true end
				local visibleentitiy1 = IS_ENTITY_VISIBLE(vehicleding)
				local deadentity1 = IS_ENTITY_DEAD(vehicleding)
				local missionentity1 = IS_ENTITY_A_MISSION_ENTITY(vehicleding)
				local speedentity2 = GET_ENTITY_SPEED(vehicleding) * 3.6
				speedentity3 = roundDecimals(speedentity, 1)
				local modelhashentity1 = GET_ENTITY_MODEL(vehicleding)
				local vehiclemodelentity1 = getmodelnamebyhash(modelhashentity1)
				local ownerentity1 = entities.get_owner(vehicleding)
				local namefromplayer1 = players.get_name(ownerentity1)
				--npc in einem auto
				if not informationpedveh then
					textline = textline .."VEHICLE: ".. vehiclemodelentity1.. "\n"
					textline = textline .."GOD: ".. godmodeentity3.. "\n"
					textline = textline .."FOR MISSION: ".. missionentity1.. "\n"
					textline = textline .."SPEED: ".. speedentity3.. "\n"
					textline = textline .."HEALTH: ".. healthentity1.. "\n"
					textline = textline .."OWNERVEH: ".. namefromplayer1
					directx.draw_text(x, y, textline, 4, 0.5, {r=1,g=1,b=1,a=1}, true)
				else
					textline = textline .."PED: ".. modelname.. "\n"
					textline = textline .."VEHICLE: ".. vehiclemodelentity1.. "\n"
					textline = textline .."GOD: ".. godmodeentity1.. "\n"
					textline = textline .."DEAD: ".. deadentity.. "\n"
					textline = textline .."FOR MISSION: ".. missionentity.. "\n"
					textline = textline .."SPEED: ".. speedentity1.. "\n"
					textline = textline .."HEALTH: ".. healthentity.. "\n"
					textline = textline .."OWNERVEH: ".. namefromplayer
					directx.draw_text(x, y, textline, 4, 0.5, {r=1,g=1,b=1,a=1}, true)
				end
				--directx.draw_text(x, y6, "MODEL HASH: ".. modelhashentity1, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
				directx.draw_text(0.5, y10, "R = Delete  /  E = GRAVITY GUN  /  F = ENTER VEH  /  G = EXPLODE", 5, 0.8, {r=1,g=1,b=1,a=1}, true)
				if is_key_just_down("VK_F") and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
					if not vehenterstealnpc then
						if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
							menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
							entities.delete(handle)
							SET_PED_INTO_VEHICLE(players.user_ped(), vehicleding, -1)
						else
							entities.delete(handle)
							SET_PED_INTO_VEHICLE(players.user_ped(), vehicleding, -1)
						end
					else
						if ARE_ANY_VEHICLE_SEATS_FREE(vehicleding) then
							if IS_VEHICLE_SEAT_FREE(vehicleding, 0) then
								if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
									menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
									SET_PED_INTO_VEHICLE(players.user_ped(), vehicleding, 0)
								else
									SET_PED_INTO_VEHICLE(players.user_ped(), vehicleding, 0)
								end
							elseif  IS_VEHICLE_SEAT_FREE(vehicleding, 1) then
								if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
									menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
									SET_PED_INTO_VEHICLE(players.user_ped(), vehicleding, 1)
								else
									SET_PED_INTO_VEHICLE(players.user_ped(), vehicleding, 1)
								end
							elseif  IS_VEHICLE_SEAT_FREE(vehicleding, 2) then
								if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
									menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
									SET_PED_INTO_VEHICLE(players.user_ped(), vehicleding, 2)
								else
									SET_PED_INTO_VEHICLE(players.user_ped(), vehicleding, 2)
								end
							elseif  IS_VEHICLE_SEAT_FREE(vehicleding, 3) then
								if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
									menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
									SET_PED_INTO_VEHICLE(players.user_ped(), vehicleding, 3)
								else
									SET_PED_INTO_VEHICLE(players.user_ped(), vehicleding, 3)
								end
							elseif  IS_VEHICLE_SEAT_FREE(vehicleding, 4) then
								if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
									menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
									SET_PED_INTO_VEHICLE(players.user_ped(), vehicleding, 4)
								else
									SET_PED_INTO_VEHICLE(players.user_ped(), vehicleding, 4)
								end
							else
								util.toast("konnte dich in keinen sitz setzen")
							end
						else
							util.toast("Fahrzeug ist voll")
						end
					end
				end
				if controlepedcar then
					if is_key_just_down('VK_R') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
						entities.delete(handle)
						if not IS_VEHICLE_SEAT_FREE(vehicleding, 0) then
							local vehicleseat0 = GET_PED_IN_VEHICLE_SEAT(vehicleding, 0)
							entities.delete(vehicleseat0)
						end
						if not IS_VEHICLE_SEAT_FREE(vehicleding, 1) then
							local vehicleseat1 = GET_PED_IN_VEHICLE_SEAT(vehicleding, 1)
							entities.delete(vehicleseat1)
						end
						if not IS_VEHICLE_SEAT_FREE(vehicleding, 2) then
							local vehicleseat2 = GET_PED_IN_VEHICLE_SEAT(vehicleding, 2)
							entities.delete(vehicleseat2)
						end
						if not IS_VEHICLE_SEAT_FREE(vehicleding, 3) then
							local vehicleseat3 = GET_PED_IN_VEHICLE_SEAT(vehicleding, 3)
							entities.delete(vehicleseat3)
						end
						if not IS_VEHICLE_SEAT_FREE(vehicleding, 4) then
							local vehicleseat4 = GET_PED_IN_VEHICLE_SEAT(vehicleding, 4)
							entities.delete(vehicleseat4)
						end
							entities.delete(vehicleding)
					end
				elseif deletevehicle then
					if is_key_just_down('VK_R') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
						entities.delete(vehicleding)
					end
				else
					if is_key_just_down('VK_R') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
						if not IS_VEHICLE_SEAT_FREE(vehicleding, 0) then
							local vehicleseat0 = GET_PED_IN_VEHICLE_SEAT(vehicleding, 0)
							entities.delete(vehicleseat0)
						end
						if not IS_VEHICLE_SEAT_FREE(vehicleding, 1) then
							local vehicleseat1 = GET_PED_IN_VEHICLE_SEAT(vehicleding, 1)
							entities.delete(vehicleseat1)
						end
						if not IS_VEHICLE_SEAT_FREE(vehicleding, 2) then
							local vehicleseat2 = GET_PED_IN_VEHICLE_SEAT(vehicleding, 2)
							entities.delete(vehicleseat2)
						end
						if not IS_VEHICLE_SEAT_FREE(vehicleding, 3) then
							local vehicleseat3 = GET_PED_IN_VEHICLE_SEAT(vehicleding, 3)
							entities.delete(vehicleseat3)
						end
						if not IS_VEHICLE_SEAT_FREE(vehicleding, 4) then
							local vehicleseat4 = GET_PED_IN_VEHICLE_SEAT(vehicleding, 4)
							entities.delete(vehicleseat4)
						end
						entities.delete(handle)
					end
				end
				if is_key_just_down('VK_G') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
					NETWORK_EXPLODE_VEHICLE(vehicleding, 1, 0, 0)
				end
				if not schwerkraftan then
					if is_key_just_down('VK_E') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
						menu.trigger_command(menu.ref_by_path("Self>Weapons>Gravity Gun>Gravity Gun"), true)
					end
				end
			elseif IS_PED_A_PLAYER(handle) then
				local nearestplayer = GET_NEAREST_PLAYER_TO_ENTITY(handle)
				local nameplayer = players.get_name(nearestplayer)
				local tagsofplayer = players.get_tags_string(nearestplayer)
				local vehmodel = players.get_vehicle_model(nearestplayer)
				if IS_PED_IN_ANY_VEHICLE(handle,true) then
					directx.draw_text(0.5, y10, "R = Delete  /  E = GRAVITY GUN  /  F = ENTER VEH  /  C = KICKEN  /  B = PLAYER WINDOW  /  G = EXPLODE", 5, 0.8, {r=1,g=1,b=1,a=1}, true)
					local vehicleplayer1 = getmodelnamebyhash(vehmodel)
					local vehicleplayer = GET_VEHICLE_PED_IS_IN(handle)
					local ownerentity2 = entities.get_owner(vehicleplayer)
					local namefromplayer2 = players.get_name(ownerentity2)
					textline = textline .."PLAYER: ".. nameplayer.. "\n"
					textline = textline .."VEHICLE: ".. vehicleplayer1.. "\n"
					textline = textline .."GOD: ".. godmodeentity1.. "\n"
					textline = textline .."VISIBLE: ".. visibleentitiy.. "\n"
					textline = textline .."SPEED: ".. speedentity1.. "\n"
					textline = textline .."HEALTH: ".. healthentity.. "\n"
					textline = textline .."OWNERVEH: ".. namefromplayer2.. "\n"
					textline = textline .."TAGS: ".. tagsofplayer
					directx.draw_text(x, y, textline, 4, 0.5, {r=1,g=1,b=1,a=1}, true)
					if is_key_just_down("VK_F") and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
						if vehentersteal then
							menu.trigger_commands("vehkick"..nameplayer)
							vehtimer = 0
							repeat
								vehtimer += 1
								if vehtimer > 100 then
									util.toast("er konnte nicht aus dem auto geworfen werden")
									vehtimer = 0
									break
								end
								util.yield()
							until not IS_PED_IN_ANY_VEHICLE(handle,true)
							if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
								menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
								SET_PED_INTO_VEHICLE(players.user_ped(), vehicleplayer, -1)
							else
								SET_PED_INTO_VEHICLE(players.user_ped(), vehicleplayer, -1)
							end
						else
							if ARE_ANY_VEHICLE_SEATS_FREE(vehicleplayer) then
								if IS_VEHICLE_SEAT_FREE(vehicleplayer, 0) then
									if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
										menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
										SET_PED_INTO_VEHICLE(players.user_ped(), vehicleplayer, 0)
									else
										SET_PED_INTO_VEHICLE(players.user_ped(), vehicleplayer, 0)
									end
								elseif  IS_VEHICLE_SEAT_FREE(vehicleplayer, 1) then
									if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
										menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
										SET_PED_INTO_VEHICLE(players.user_ped(), vehicleplayer, 1)
									else
										SET_PED_INTO_VEHICLE(players.user_ped(), vehicleplayer, 1)
									end
								elseif  IS_VEHICLE_SEAT_FREE(vehicleplayer, 2) then
									if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
										menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
										SET_PED_INTO_VEHICLE(players.user_ped(), vehicleplayer, 2)
									else
										SET_PED_INTO_VEHICLE(players.user_ped(), vehicleplayer, 2)
									end
								elseif  IS_VEHICLE_SEAT_FREE(vehicleplayer, 3) then
									if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
										menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
										SET_PED_INTO_VEHICLE(players.user_ped(), vehicleplayer, 3)
									else
										SET_PED_INTO_VEHICLE(players.user_ped(), vehicleplayer, 3)
									end
								elseif  IS_VEHICLE_SEAT_FREE(vehicleplayer, 4) then
									if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
										menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
										SET_PED_INTO_VEHICLE(players.user_ped(), vehicleplayer, 4)
									else
										SET_PED_INTO_VEHICLE(players.user_ped(), vehicleplayer, 4)
									end
								else
									util.toast("konnte dich in keinen sitz setzen")
								end
							else
								util.toast("es sind keine sitze frei")
							end
						end
					end
					if is_key_just_down('VK_R') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
						entities.delete(vehicleplayer)
					end
					if is_key_just_down('VK_C') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
						menu.trigger_commands("kick ".. nameplayer)
					end
					if is_key_just_down('VK_B') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
						menu.trigger_commands("p ".. nameplayer)
					end
					if not schwerkraftan then
						if is_key_just_down('VK_E') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
							menu.trigger_command(menu.ref_by_path("Self>Weapons>Gravity Gun>Gravity Gun"), true)
						end
					end
					if is_key_just_down('VK_G') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
						if getcontrole(vehicleplayer) then
							NETWORK_EXPLODE_VEHICLE(vehicleplayer, 1, 0, 0)
						else
							util.toast("konnte keine kontrolle bekommen")
						end
					end
				else
					if tagsofplayer == "" then
						freezeonoroff = menu.get_value(menu.ref_by_path("Players>".. nameplayer ..">Trolling>Freeze"))
					else
						freezeonoroff = menu.get_value(menu.ref_by_path("Players>".. nameplayer .. " [" ..tagsofplayer .."]>Trolling>Freeze"))
					end
					directx.draw_text(0.5, y10, "C = KICKEN  /  R = Freeze  /  B = PLAYER WINDOW", 5, 0.8, {r=1,g=1,b=1,a=1}, true)
					textline = textline .."PLAYER: ".. nameplayer.. "\n"
					textline = textline .."GOD: ".. godmodeentity1.. "\n"
					textline = textline .."SPEED: ".. speedentity1.. "\n"
					textline = textline .."HEALTH: ".. healthentity.. "\n"
					textline = textline .."Freeze: ".. freezeonoroff.. "\n"
					textline = textline .."TAGS: ".. tagsofplayer
					directx.draw_text(x, y, textline, 4, 0.5, {r=1,g=1,b=1,a=1}, true)
					if is_key_just_down('VK_C') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
						menu.trigger_commands("kick ".. nameplayer)
					end
					if is_key_just_down('VK_B') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
						menu.trigger_commands("p ".. nameplayer)
					end
					if is_key_just_down('VK_R') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
						if tagsofplayer == "" then
							if freezeonoroff then
								menu.trigger_command(menu.ref_by_path("Players>".. nameplayer ..">Trolling>Freeze"), false)
							else 
								menu.trigger_command(menu.ref_by_path("Players>".. nameplayer ..">Trolling>Freeze"), true)
							end
						else
							if freezeonoroff then
								menu.trigger_command(menu.ref_by_path("Players>".. nameplayer .. " [" ..tagsofplayer .."]>Trolling>Freeze"), false)
							else 
								menu.trigger_command(menu.ref_by_path("Players>".. nameplayer .. " [" ..tagsofplayer .."]>Trolling>Freeze"), true)
							end
						end
					end
				end
			else
				directx.draw_text(0.5, y10, "R = Delete  /  C = CLEAR TASKS ", 5, 0.8, {r=1,g=1,b=1,a=1}, true)
				textline = textline .."PED: ".. modelname.. "\n"
				textline = textline .."GOD: ".. godmodeentity1.. "\n"
				textline = textline .."DEAD: ".. deadentity.. "\n"
				textline = textline .."FOR MISSION: ".. missionentity.. "\n"
				textline = textline .."SPEED: ".. speedentity1.. "\n"
				textline = textline .."HEALTH: ".. healthentity.. "\n"
				--textline = textline .."MODEL HASH: ".. modelhashentity.. "\n"
				textline = textline .."OWNERPED: ".. namefromplayer
				directx.draw_text(x, y, textline, 4, 0.5, {r=1,g=1,b=1,a=1}, true)
				if is_key_just_down('VK_R') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
					entities.delete(handle)
				end
				if is_key_just_down('VK_C') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
					if getcontrole(handle) then
						CLEAR_PED_TASKS(handle)
					else
						util.toast("konnte keine kontrolle bekommen")
					end
				end
			end
		elseif IS_ENTITY_A_VEHICLE(handle) then
			directx.draw_text(0.5, y10, "R = Delete  /  E = GRAVITY GUN  /  F = ENTER VEH  /  G = EXPLODE", 5, 0.8, {r=1,g=1,b=1,a=1}, true)
			local vehiclemodelentity3 = getmodelnamebyhash(modelhashentity)
			textline = textline .."VEHICLE: ".. vehiclemodelentity3.. "\n"
			textline = textline .."GOD: ".. godmodeentity1.. "\n"
			textline = textline .."FOR MISSION: ".. missionentity.. "\n"
			textline = textline .."SPEED: ".. speedentity1.. "\n"
			textline = textline .."HEALTH: ".. healthentity.. "\n"
			--textline = textline .."MODEL HASH: ".. modelhashentity.. "\n"
			textline = textline .."OWNERVEH: ".. namefromplayer
			directx.draw_text(x, y, textline, 4, 0.5, {r=1,g=1,b=1,a=1}, true)
			if is_key_just_down('VK_R') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
				entities.delete(handle)
			end
			if is_key_just_down("VK_F") and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
				if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
					menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
					SET_PED_INTO_VEHICLE(players.user_ped(), handle, -1)
				else
					SET_PED_INTO_VEHICLE(players.user_ped(), handle, -1)
				end
			end
			if is_key_just_down('VK_G') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
				if getcontrole(handle) then
					NETWORK_EXPLODE_VEHICLE(handle, 1, 0, 0)
				else
					util.toast("konnte keine kontrolle bekommen")
				end
			end
			if not schwerkraftan then
				if is_key_just_down('VK_E') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
					menu.trigger_command(menu.ref_by_path("Self>Weapons>Gravity Gun>Gravity Gun"), true)
				end
			end
		elseif IS_ENTITY_AN_OBJECT(handle) then
			directx.draw_text(0.5, y10, "R = Delete  /  E = GRAVITY GUN  /  C = COPY HASH", 5, 0.8, {r=1,g=1,b=1,a=1}, true)
			textline = textline .."OBJECT: ".. modelname.. "\n"
			textline = textline .."VISIBLE: ".. visibleentitiy.. "\n"
			textline = textline .."FOR MISSION: ".. missionentity.. "\n"
			textline = textline .."MODEL HASH: ".. modelhashentity.. "\n"
			textline = textline .."OWNEROBJECT: ".. namefromplayer
			directx.draw_text(x, y, textline, 4, 0.5, {r=1,g=1,b=1,a=1}, true)
			if is_key_just_down('VK_R') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
				entities.delete(handle)
			end
			if is_key_just_down('VK_C') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
				util.copy_to_clipboard(modelhashentity, true)
			end
			if not schwerkraftan then
				if is_key_just_down('VK_E') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
					menu.trigger_command(menu.ref_by_path("Self>Weapons>Gravity Gun>Gravity Gun"), true)
				end
			end
		end
	end
	menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>THROW_GRENADE"), grenade)
	on_stop = menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>MELEE_ATTACK_LIGHT"), lightattack)
	menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>VEH_EXIT"), false)
	menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>ENTER"), false)
	if menu.get_value(menu.ref_by_path("Self>Weapons>Gravity Gun>Gravity Gun")) then
		util.draw_debug_text("Gravity Gun ist AN")
	end
end)

function raycast_gameplay_cam(flag, distance)
    local ptr1, ptr2, ptr3, ptr4 = memory.alloc(), memory.alloc(), memory.alloc(), memory.alloc()
    local cam_rot = GET_GAMEPLAY_CAM_ROT(0)
    local cam_pos = GET_GAMEPLAY_CAM_COORD()
    local direction = v3.toDir(cam_rot)
    local destination = 
    { 
        x = cam_pos.x + direction.x * distance, 
        y = cam_pos.y + direction.y * distance, 
        z = cam_pos.z + direction.z * distance 
    }
    GET_SHAPE_TEST_RESULT(
        START_EXPENSIVE_SYNCHRONOUS_SHAPE_TEST_LOS_PROBE(
            cam_pos.x, 
            cam_pos.y, 
            cam_pos.z, 
            destination.x, 
            destination.y, 
            destination.z, 
            flag, 
            players.user_ped(), 
            1
        ), ptr1, ptr2, ptr3, ptr4)
    local p1 = memory.read_int(ptr1)
    local p2 = memory.read_vector3(ptr2)
    local p3 = memory.read_vector3(ptr3)
    local p4 = memory.read_int(ptr4)
    return {p1, p2, p3, p4}
end

function get_offset_from_gameplay_camera(distance)
	local cam_rot = GET_GAMEPLAY_CAM_ROT(2)
	local cam_pos = GET_GAMEPLAY_CAM_COORD()
	local direction = v3.toDir(cam_rot)
	local destination = v3(direction)
	destination:mul(distance)
	destination:add(cam_pos)

	return destination
end

Entitymanagergravitygun = menu.list(Entitymanager, "Gravity gun", {}, "")


menu.toggle_loop(Entitymanagergravitygun, "Fake Gravity gun", {}, "Ziele auf sachen drauf um sie rum zu bewegen\nFahrezuge kann man auch mit schießen werfen\nmanche objekte können nicht weit weg von seinem spawn punkt die despawnen dann einfach", function()
	local entpointer = memory.alloc()
	local enitity = GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(players.user(), entpointer)
	local handle = memory.read_int(entpointer)
	local holdingnweapon = getcurrentweaponofped(players.user_ped())
	local coords = get_offset_from_gameplay_camera(gravitiygundist)
	local shootthetarget = false
	if not enitity then
		return
	end
	if IS_ENTITY_A_PED(handle) then
		local vehofped = GET_VEHICLE_PED_IS_IN(handle, true)
		if vehofped != 0 then
			handle = vehofped
		else
			if IS_PED_A_PLAYER(handle) then
				return
			end
		end
	end
	if gravitiygunonlyapsniper then
		if not table.contains({584646201, 100416529}, holdingnweapon) then
			return
		end
	end
	if (IS_ENTITY_A_PED(handle) and not gravitiygunPED) or (IS_ENTITY_A_VEHICLE(handle) and not gravitiygunVEHICLE) or (IS_ENTITY_AN_OBJECT(handle) and not gravitiygunOBJECT) then
		return
	end
	--holdingnweapon != tonumber(584646201) or holdingnweapon != tonumber(100416529)
	local hadcollison = GET_ENTITY_COLLISION_DISABLED(handle)
	local ismissionentity = IS_ENTITY_A_MISSION_ENTITY(handle)
	local canmigrade = entities.get_can_migrate(handle)
	repeat
		if not DOES_ENTITY_EXIST(handle) then
			break
		end
		coords = get_offset_from_gameplay_camera(gravitiygundist)
		if entities.request_control(handle) then
			if gravitiygunswitchowner then
				entities.set_can_migrate(handle, false)
			end
			FREEZE_ENTITY_POSITION(handle, true)
			--[[if gravitiyguncollisionoff then
				SET_ENTITY_COLLISION(handle, false, true)
			end]]
			SET_ENTITY_AS_MISSION_ENTITY(handle, true)
			SET_ENTITY_COORDS_NO_OFFSET(handle, coords.x, coords.y, coords.z-0.5, 0,0,0)
			if IS_PED_SHOOTING(players.user_ped()) and IS_ENTITY_A_VEHICLE(handle) then
				shootthetarget = true
				break
			end
		end
		util.yield()
	until not IS_PLAYER_FREE_AIMING(players.user())
	--[[if not hadcollison and gravitiyguncollisionoff then
		SET_ENTITY_COLLISION(handle, true, true)
	end]]
	if not ismissionentity then
		local ent_ptr = memory.alloc_int()
		memory.write_int(ent_ptr, handle)
		SET_ENTITY_AS_NO_LONGER_NEEDED(ent_ptr)
	end
	if not gravitiygunfreezeonletgo then
		FREEZE_ENTITY_POSITION(handle, false)
	end
	if canmigrade and gravitiygunswitchowner then
		entities.set_can_migrate(handle, true)
	end
	if shootthetarget then
		FREEZE_ENTITY_POSITION(handle, false)
		local c1 = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0.0, 0, 0.0)
		local res = raycast_gameplay_cam(-1, 1000.0)
		local dir = {}
		local c2 = {}
		if res[1] ~= 0 then
			c2 = res[2]
			dir['x'] = (c2['x'] - c1['x'])*1000
			dir['y'] = (c2['y'] - c1['y'])*1000
			dir['z'] = (c2['z'] - c1['z'])*1000
		else 
			c2 = get_offset_from_gameplay_camera(1000)
			dir['x'] = (c2['x'] - c1['x'])*1000
			dir['y'] = (c2['y'] - c1['y'])*1000
			dir['z'] = (c2['z'] - c1['z'])*1000
		end
		APPLY_FORCE_TO_ENTITY(handle, 1, dir['x'], dir['y'], dir['z'], 0.0, 0.0, 0.0, 1, false, true, true, true, true)
		util.yield(1000)
	end
end)
gravitiygunonlyapsniper, gravitiygunfreezeonletgo, gravitiygunswitchowner = true, false, true
gravitiygunPED, gravitiygunVEHICLE, gravitiygunOBJECT = true, true, true
gravitiygundist = 30

menu.divider(Entitymanagergravitygun, "SETTINGS")

Entitymanagergravitygundist = menu.slider(Entitymanagergravitygun, "Range to load", {"setdistnearenittys"}, "", 10, 100, gravitiygundist, 5, function(val)
	gravitiygundist = val
end)
gravitiygundist = menu.get_value(Entitymanagergravitygundist)

Entitymanagergravitygunonlyapsniper = menu.toggle(Entitymanagergravitygun, "Only with AP / Sniperrifle", {}, "Gravity gun geht nur mit:\nAP-Pistole\nScharfschützengewehr / sniper rifle", function(value)
	gravitiygunonlyapsniper = value
end, gravitiygunonlyapsniper)
gravitiygunonlyapsniper = menu.get_value(Entitymanagergravitygunonlyapsniper)

Entitymanagergravitygunfreezletgo = menu.toggle(Entitymanagergravitygun, "Freeze position on let go", {}, "", function(value)
	gravitiygunfreezeonletgo = value
end, gravitiygunfreezeonletgo)
gravitiygunfreezeonletgo = menu.get_value(Entitymanagergravitygunfreezletgo)

--[[Entitymanagergravitygundeactivatecollison = menu.toggle(Entitymanagergravitygun, "Deactivate collison while carry", {}, "", function(value)
	gravitiyguncollisionoff = value
end, gravitiyguncollisionoff)
gravitiyguncollisionoff = menu.get_value(Entitymanagergravitygundeactivatecollison)]]

Entitymanagergravitygunswitchowner = menu.toggle(Entitymanagergravitygun, "Switch owner of enitity", {}, "kann manchmal zu bugs kommen einfach sicherheits halber aussaltbar gemacht", function(value)
	gravitiygunswitchowner = value
end, gravitiygunswitchowner)
gravitiygunswitchowner = menu.get_value(Entitymanagergravitygunswitchowner)

menu.divider(Entitymanagergravitygun, "ENTITYS")

EntitymanagergravitygunPED = menu.toggle(Entitymanagergravitygun, "PED", {}, "", function(value)
	gravitiygunPED = value
end, gravitiygunPED)
gravitiygunPED = menu.get_value(EntitymanagergravitygunPED)
EntitymanagergravitygunVEHICLE = menu.toggle(Entitymanagergravitygun, "VEHICLE", {}, "", function(value)
	gravitiygunVEHICLE = value
end, gravitiygunVEHICLE)
gravitiygunVEHICLE = menu.get_value(EntitymanagergravitygunVEHICLE)
EntitymanagergravitygunOBJECT = menu.toggle(Entitymanagergravitygun, "OBJECT", {}, "", function(value)
	gravitiygunOBJECT = value
end, gravitiygunOBJECT)
gravitiygunOBJECT = menu.get_value(EntitymanagergravitygunOBJECT)


--- Context Menu Manager

preset_slot_values = {
    PAUSE_SINGLE_LEFT = 0,
    PAUSE_SINGLE_MIDDLE = 0,
    PAUSE_SINGLE_RIGHT = 0,
    FACE_CREATION_PRESET = 4,
    MPLOBBY_ALL5SLOTS = 2,
    FACE_CREATION_CONFIRM = 0,
    CELEBRATION_WINNER = 2,
    CHARACTER_CREATOR_HERITAGE = 1
}
preset_name_index_map = {
    PAUSE_SINGLE_LEFT = 1,
    PAUSE_SINGLE_MIDDLE = 2,
    PAUSE_SINGLE_RIGHT = 3,
    FACE_CREATION_PRESET = 4,
    MPLOBBY_ALL5SLOTS = 5,
    FACE_CREATION_CONFIRM = 6,
    CELEBRATION_WINNER = 7,
    CHARACTER_CREATOR_HERITAGE = 8
}
preset_name_list = {
    "PAUSE_SINGLE_LEFT",
    "PAUSE_SINGLE_MIDDLE",
    "PAUSE_SINGLE_RIGHT",
    "FACE_CREATION_PRESET",
    "MPLOBBY_ALL5SLOTS",
    "FACE_CREATION_CONFIRM",
    "CELEBRATION_WINNER",
    "CHARACTER_CREATOR_HERITAGE"
}
hotkey_map = {
    BACKSPACE=0x08,
    TAB=0x09,
    RETURN=0X0D,
    SHIFT=0x10,
    CONTROL=0x11,
    ALT=0x12,
    ESC=0x1B,
    SPACE=0x20,
    INSERT=0x2D,
    DEL=0x2E,
    HELP=0x2F,
}
TRACE_FLAG = {
	WORLD = 1,
	VEHICLE = 2,
	PED = 4,
	RAGDOLL = 8,
	OBJECT = 16,
	PICKUP = 32,
	GLASS = 64,
	RIVER = 128,
	FOLIAGE = 256,
	ALL = 511,
}


local cmm = {
    menu_options = {},
}
local menus = {}
local state = {}

local pointx = memory.alloc()
local pointy = memory.alloc()

--util.ensure_package_is_installed('lua/inspect')
--local inspect = require("inspect")

local config = {
    debug_mode = false,
    context_menu_enabled=false,
	only_enable_when_disarmed=true,
	use_aarons_model_hash=true,
    wrap_read_model_with_pcall=false,
	target_switch_ped_veh=false,
	target_ignore_player_veh=true,
	show_target_player_withtags=true,
	ped_preview = {
        enabled=true,
        preset_name="PAUSE_SINGLE_LEFT",
        preset_slot=0,
        pos={
            x=0.0,
            y=-1.0,
            z=0.0,
        },
    },
    target_player_distance=1000,
    target_vehicle_distance=1000,
    target_ped_distance=500,
    target_object_distance=50,
	target_snap_distance={
        player=0.05,
        vehicle=0.04,
        ped=0.02,
        object=0.01,
    },
    color = {
        options_circle={r=1, g=1, b=1, a=0.1},
        option_text={r=1, g=1, b=1, a=1},
        help_text={r=0.8, g=0.8, b=0.8, a=1},
        option_wedge={r=1, g=1, b=1, a=0.3},
        selected_option_wedge={r=1, g=0, b=1, a=0.3},
        crosshair={r=1,g=1,b=1,a=0.8},
        target_ball={r=1,g=0,b=1,a=0.8},
        target_bounding_box={r=1,g=0,b=1,a=1},
        line_to_target={ r=1, g=1, b=1, a=0.5},
    },
    target_ball_size=0.4,
    selection_distance=600.0,
    menu_radius=0.1,
    option_label_distance=0.6,
    option_wedge_deadzone=0.2,
    option_wedge_padding=0.0,
    menu_release_delay=3,
    show_target_name=true,
	show_target_owner=true,
    show_option_help=true,
    menu_options_scripts_dir="lib/Selfmadestuff/Contextstuff",
	trace_flag_options = {
        --{name="All", value=511, enabled=false},
        {name="World", value=1, enabled=true},
        {name="Vehicle", value=2, enabled=true},
        {name="Ped", value=4, enabled=true},
        {name="Ragdoll", value=8, enabled=true},
        {name="Object", value=16, enabled=true},
        {name="Pickup", value=32, enabled=true},
        {name="Glass", value=64, enabled=false},
        {name="River", value=128, enabled=false},
        {name="Foliage", value=256, enabled=true},
    },
    trace_flag_value=0,
}

local CONTEXT_MENUS_DIR = filesystem.scripts_dir()..config.menu_options_scripts_dir
filesystem.mkdirs(CONTEXT_MENUS_DIR)

local function debug_log(text)
    util.log("[ContextMenuManager] "..text)
end

local minimum = memory.alloc()
local maximum = memory.alloc()

cmm.draw_bounding_box = function(target, colour)
    if colour == nil then
        colour = config.color.target_bounding_box_output
    end
    if target.model_hash == nil then
        debug_log("Could not draw bounding box: No model hash set")
        return
    end

    GET_MODEL_DIMENSIONS(target.model_hash, minimum, maximum)
    local minimum_vec = v3.new(minimum)
    local maximum_vec = v3.new(maximum)
    draw_bounding_box_with_dimensions(target.handle, colour, minimum_vec, maximum_vec)
end

---
--- Main Menu Draw Tick
---

local timetodestroypgone = 0
local createphoneoutofding = false

cmm.context_menu_draw_tick = function()
    if not cmm.is_menu_available() then return true end

    if state.is_menu_open then
		cmm.refresh_screen_pos(state.current_target)
    else
		directx.draw_circle(0.5, 0.5, 0.001, config.color.target_ball)
        state.current_target = cmm.find_nearest_target()	
    end

	local target = state.current_target
    if target ~= nil and target.pos ~= nil then
        cmm.draw_selection(target)
        if cmm.is_menu_open_control_pressed() and not createphoneoutofding then
            DISABLE_CONTROL_ACTION(2, 27, true)
            timetodestroypgone += 1
            if not menu.is_open() then
                cmm.open_options_menu(target)
            end
        elseif cmm.is_menu_close_control_pressed() then
            cmm.close_options_menu(target)
            if timetodestroypgone < 15 and timetodestroypgone > 1 then createphoneoutofding = true SET_CONTROL_VALUE_NEXT_FRAME(2, 27, 1.0) else createphoneoutofding = false end
            timetodestroypgone = 0
        end
		if state.is_menu_open then
            cmm.update_menu(target)
        end
    end

    return true
end

cmm.is_menu_open_control_pressed = function()
    return IS_DISABLED_CONTROL_JUST_PRESSED(2, 27) and not IS_PAUSE_MENU_ACTIVE()
end

cmm.is_menu_close_control_pressed = function()
    return not IS_DISABLED_CONTROL_PRESSED(2, 27) or IS_PAUSE_MENU_ACTIVE()
end

cmm.is_menu_available = function()
    if not config.context_menu_enabled then return false end
	if config.disable_in_vehicles then if IS_PED_IN_ANY_VEHICLE(players.user_ped()) then return false end end
	return true
end

cmm.draw_ped_preview = function(target)
    if not config.ped_preview.enabled or target.type ~= "PLAYER" then return end
    if UI3DSCENE_IS_AVAILABLE() then
        if UI3DSCENE_PUSH_PRESET(config.ped_preview.preset_name) then
            UI3DSCENE_ASSIGN_PED_TO_SLOT(
                config.ped_preview.preset_name, target.handle, config.ped_preview.preset_slot,
                config.ped_preview.pos.x, config.ped_preview.pos.y, config.ped_preview.pos.z
            )
            UI3DSCENE_MAKE_PUSHED_PRESET_PERSISTENT()
            UI3DSCENE_CLEAR_PATCHED_DATA()
        end
    end
end

--- Targetting

cmm.get_distance_from_player = function(target)
    local player_pos = GET_ENTITY_COORDS(players.user_ped(), 1)
    if target.handle then
        target.pos = GET_ENTITY_COORDS(target.handle, 1)
        target.distance_from_player = VDIST(player_pos.x, player_pos.y, player_pos.z, target.pos.x, target.pos.y, target.pos.z)
    elseif target.pos then
        target.distance_from_player = VDIST(player_pos.x, player_pos.y, player_pos.z, target.pos.x, target.pos.y, target.pos.z)
    end
end

function expand_target_screen_pos(target)
    local player_pos = GET_ENTITY_COORDS(players.user_ped(), 1)
    target.distance_from_player = VDIST(
        player_pos.x, player_pos.y, player_pos.z,
        target.position.x, target.position.y, target.position.z
    )
    if GET_SCREEN_COORD_FROM_WORLD_COORD(target.position.x, target.position.y, target.position.z, pointx, pointy) then
        target.screen_pos = { x=memory.read_float(pointx), y=memory.read_float(pointy)}
        target.screen_distance = VDIST(0.5, 0.5, 0.0, target.screen_pos.x, target.screen_pos.y, 0.0)
    end
end

function build_handle_target(handle)
    local target = {
        handle=handle,
        position=GET_ENTITY_COORDS(handle),
    }
	cmm.update_target_data(target)
    expand_target_screen_pos(target)
    return target
end

function check_handles_for_nearest_target(handles, result, max_distance, snap_distance)
    if max_distance == nil then max_distance = 9999999 end
    for _, handle in handles do
        if handle ~= players.user_ped() and (handle ~= GET_VEHICLE_PED_IS_IN(players.user_ped(), true)) then
            local target = build_handle_target(handle)
            if target.distance_from_player < max_distance
                and target.screen_distance ~= nil
                and target.screen_distance < snap_distance
                and (
                    result.closest_target.screen_distance == nil
                    or target.screen_distance < result.closest_target.screen_distance
                )
            then
                result.closest_target = target
            end
        end
    end
end

function build_pointer_target(pointer)
    local target = {
        pointer=pointer,
        position=entities.get_position(pointer),
    }
    expand_target_screen_pos(target)
    return target
end

local function check_pointers_for_closest_target(pointers, result, max_distance, max_screen_distance)
    local player_pointer = entities.handle_to_pointer(players.user_ped())
    if result.closest_target.screen_distance == nil then result.closest_target.screen_distance = 9999999 end
    for _, pointer in pointers do
        local target = build_pointer_target(pointer)
        if pointer ~= player_pointer
            and target.distance_from_player < max_distance
            and target.screen_distance ~= nil
            and target.screen_distance < max_screen_distance
            and target.screen_distance < result.closest_target.screen_distance
        then
            result.closest_target = target
        end
    end
end

function get_all_players_as_handles()
    local player_handles = {}
    for _, pid in players.list(false) do
        table.insert(player_handles, GET_PLAYER_PED_SCRIPT_INDEX(pid))
    end
    return player_handles
end

cmm.find_nearest_target = function()
    local result = {
        min_distance = 9999,
        closest_target = {}
    }

    check_handles_for_nearest_target(get_all_players_as_handles(), result, config.target_player_distance, config.target_snap_distance.player)
    --check_handles_for_nearest_target(entities.get_all_vehicles_as_handles(), result, config.target_vehicle_distance, config.target_snap_distance.vehicle)
    --check_handles_for_nearest_target(entities.get_all_peds_as_handles(), result, config.target_ped_distance, config.target_snap_distance.ped)
    --check_handles_for_nearest_target(entities.get_all_objects_as_handles(), result, config.target_object_distance, config.target_snap_distance.object)

    check_pointers_for_closest_target(entities.get_all_vehicles_as_pointers(), result, config.target_vehicle_distance, config.target_snap_distance.vehicle)
    check_pointers_for_closest_target(entities.get_all_peds_as_pointers(), result, config.target_ped_distance, config.target_snap_distance.ped)
    --check_pointers_for_closest_target(entities.get_all_objects_as_pointers(), result, config.target_object_distance, config.target_snap_distance.object)

    if result.closest_target.pointer then
        result.closest_target.handle = entities.pointer_to_handle(result.closest_target.pointer)
    end
    if result.closest_target.handle then
		if IS_ENTITY_A_PED(result.closest_target.handle) then
			if IS_PED_A_PLAYER(result.closest_target.handle) then
				if not config.target_ignore_player_veh then
					if IS_PED_IN_ANY_VEHICLE(result.closest_target.handle) then
						result.closest_target.handle = GET_VEHICLE_PED_IS_IN(result.closest_target.handle, false)
					end
				end
			else
				if not config.target_switch_ped_veh then
					if IS_PED_IN_ANY_VEHICLE(result.closest_target.handle) then
						result.closest_target.handle = GET_VEHICLE_PED_IS_IN(result.closest_target.handle, false)
					end
				end
			end
		end
		if GET_VEHICLE_PED_IS_IN(players.user_ped(), true) != result.closest_target.handle then
        	cmm.expand_target_model(result.closest_target)
        	return result.closest_target
		end
    end

    return cmm.get_raycast_target()
end

---
--- Menu Options
---

cmm.add_context_menu_option = function(menu_option)
    cmm.default_menu_option(menu_option)
    --debug_log("Adding menu option "..menu_option.name or "Unknown")
    table.insert(cmm.menu_options, menu_option)
end

local unique_id_counter = 0
cmm.default_menu_option = function(menu_option)
    if menu_option.name == nil then menu_option.name = "Unknown Name" end
    if menu_option.enabled == nil then menu_option.enabled = true end
    if menu_option.priority == nil then menu_option.priority = 0 end
    if menu_option.id == nil then
        unique_id_counter = unique_id_counter + 1
        menu_option.id = unique_id_counter
    end
end

cmm.empty_menu_option = function()
    return {
        name="",
        priority=-1,
        is_empty=true
    }
end

cmm.refresh_menu_options_from_files = function(directory, path)
    if path == nil then path = "" end
    for _, filepath in ipairs(filesystem.list_files(directory)) do
        if filesystem.is_dir(filepath) then
            local _2, dirname = string.match(filepath, "(.-)([^\\/]-%.?)$")
            cmm.refresh_menu_options_from_files(filepath, path.."/"..dirname)
        else
            local _3, filename, ext = string.match(filepath, "(.-)([^\\/]-%.?)[.]([^%.\\/]*)$")
            if ext == "lua" or ext == "pluto" then
                local menu_option = require(config.menu_options_scripts_dir..path.."/"..filename)
                menu_option.filename = filename.."."..ext
				menu_option.filepath = filepath
                --debug_log("Loading menu option "..config.menu_options_scripts_dir..path.."/"..filename..": "..inspect(menu_option))
                --cc.expand_chat_command_defaults(command, filename, path)
                cmm.add_context_menu_option(menu_option)
            end
        end
    end
end

cmm.refresh_menu_options_from_files(CONTEXT_MENUS_DIR)
table.sort(cmm.menu_options, function(a,b) return a.name < b.name end)

local ENTITY_TYPES = {"PED", "VEHICLE", "OBJECT"}

---
--- Draw Utils
---

local upVector_pointer = memory.alloc()
local rightVector_pointer = memory.alloc()
local forwardVector_pointer = memory.alloc()
local position_pointer = memory.alloc()

cmm.draw_text_with_shadow = function(posx, posy, text, alignment, scale, color, force_in_bounds)
    if alignment == nil then alignment = 5 end
    if scale == nil then scale = 0.5 end
    if color == nil then color = config.color.option_text end
    if force_in_bounds == nil then force_in_bounds = true end
    local shadow_color = {r=0,g=0,b=0,a=0.3}
    local shadow_distance = 0.001
    directx.draw_text(posx + shadow_distance, posy + shadow_distance, text, alignment, scale, shadow_color, force_in_bounds)
    directx.draw_text(posx - shadow_distance, posy - shadow_distance, text, alignment, scale, shadow_color, force_in_bounds)
    directx.draw_text(posx + shadow_distance, posy - shadow_distance, text, alignment, scale, shadow_color, force_in_bounds)
    directx.draw_text(posx - shadow_distance, posy + shadow_distance, text, alignment, scale, shadow_color, force_in_bounds)

    directx.draw_text(posx + shadow_distance, posy, text, alignment, scale, shadow_color, force_in_bounds)
    directx.draw_text(posx, posy + shadow_distance, text, alignment, scale, shadow_color, force_in_bounds)
    directx.draw_text(posx - shadow_distance, posy, text, alignment, scale, shadow_color, force_in_bounds)
    directx.draw_text(posx, posy - shadow_distance, text, alignment, scale, shadow_color, force_in_bounds)

    directx.draw_text(posx, posy, text, alignment, scale, color, force_in_bounds)
end

---
--- Color Menu Outputs
---

cmm.color_menu_output = function(output_color)
    return {
        r=math.floor(output_color.r * 255),
        g=math.floor(output_color.g * 255),
        b=math.floor(output_color.b * 255),
        a=math.floor(output_color.a * 255)
    }
end
config.color.target_ball_output = cmm.color_menu_output(config.color.target_ball)
config.color.target_bounding_box_output = cmm.color_menu_output(config.color.target_bounding_box)

--------------------------
-- RAYCAST
--------------------------

---@param dist number
---@return v3
local function get_offset_from_cam(dist)
    local rot = GET_FINAL_RENDERED_CAM_ROT(2)
    local pos = GET_FINAL_RENDERED_CAM_COORD()
    local dir = rot:toDir()
    dir:mul(dist)
    local offset = v3.new(pos)
    offset:add(dir)
    return offset
end

---@class RaycastResult
---@field didHit boolean
---@field endCoords v3
---@field surfaceNormal v3
---@field hitEntity Entity

---@param dist number
---@param flag? integer
---@return RaycastResult
function get_raycast_result(dist, flag)
    local result = {}
    flag = flag or 511
    local didHit = memory.alloc(1)
    local endCoords = v3.new()
    local normal = v3.new()
    local hitEntity = memory.alloc_int()
    local camPos = GET_FINAL_RENDERED_CAM_COORD()
    local offset = get_offset_from_cam(dist)

    local handle = START_EXPENSIVE_SYNCHRONOUS_SHAPE_TEST_LOS_PROBE(
            camPos.x, camPos.y, camPos.z,
            offset.x, offset.y, offset.z,
            flag,
            players.user_ped(), 7
    )
    GET_SHAPE_TEST_RESULT(handle, didHit, endCoords, normal, hitEntity)

    result.didHit = memory.read_byte(didHit) ~= 0
    result.endCoords = endCoords
    result.surfaceNormal = normal
    result.hitEntity = memory.read_int(hitEntity)
    return result
end

cmm.rebuild_trace_flag_value = function()
    local flag = 0
    for _, trace_flag_option in config.trace_flag_options do
        if trace_flag_option.enabled then
            local flag_value = trace_flag_option.value
            flag = flag | flag_value
        end
    end
    config.trace_flag_value = flag
end
cmm.rebuild_trace_flag_value()

---
--- Polygon Utils
---

function is_point_in_polygon( x, y, vertices)
    local points= {}

    for i=1, #vertices-1, 2 do
        points[#points+1] = { x=vertices[i], y=vertices[i+1] }
    end
    local j = #points, #points
    local inside = false

    for i=1, #points do
        if ((points[i].y < y and points[j].y>=y or points[j].y< y and points[i].y>=y) and (points[i].x<=x or points[j].x<=x)) then
            if (points[i].x+(y-points[i].y)/(points[j].y-points[i].y)*(points[j].x-points[i].x)<x) then
                inside = not inside
            end
        end
        j = i
    end

    return inside
end

function build_vertices_list(wedge_points)
    local vertices = {}
    for _, point in wedge_points do
        table.insert(vertices, point.x)
        table.insert(vertices, point.y)
    end
    return vertices
end

function draw_polygon(wedge_points, draw_color)
    for point_index=1, (#wedge_points/2)-1 do
        local top_point = wedge_points[point_index]
        local bottom_point = wedge_points[#wedge_points - point_index + 1]
        local next_top_point = wedge_points[point_index + 1]
        local next_bottom_point = wedge_points[#wedge_points - point_index]
        directx.draw_triangle(
            top_point.x, top_point.y,
            bottom_point.x, bottom_point.y,
            next_top_point.x, next_top_point.y,
            draw_color
        )
        directx.draw_triangle(
            next_top_point.x, next_top_point.y,
            bottom_point.x, bottom_point.y,
            next_bottom_point.x, next_bottom_point.y,
            draw_color
        )
    end
end

---
--- Trig Utils
---

local pointx = memory.alloc()
local pointy = memory.alloc()

function get_circle_coords(origin, radius, angle_degree)
    local angle_radian = math.rad(angle_degree)
    return {
        x=(radius * math.cos(angle_radian) * 0.9) + origin.x,
        y=(radius * math.sin(angle_radian) * 1.6) + origin.y
    }
end

function reverse_table(tab)
    for i = 1, #tab//2, 1 do
        tab[i], tab[#tab-i+1] = tab[#tab-i+1], tab[i]
    end
    return tab
end

function calculate_point_angles(target, option, option_angle, option_width)
    local width_scale = 1 - config.option_wedge_padding
    local point_angles = {
        option_angle - (option_width / 2 * width_scale),
        option_angle - (option_width / 4 * width_scale),
        option_angle,
        option_angle + (option_width / 4 * width_scale),
        option_angle + (option_width / 2 * width_scale),
    }
    return point_angles
end


function build_wedge_points(point_angles, target)
    local top_points = {}
    local bottom_points = {}
    for _, point_angle in point_angles do
        local top_point = get_circle_coords(target.menu_pos, config.menu_radius, point_angle)
        table.insert(top_points, top_point)
        local bottom_point = get_circle_coords(target.menu_pos, config.menu_radius * config.option_wedge_deadzone, point_angle)
        table.insert(bottom_points, bottom_point)
    end

    local final_points = {}
    for _, top_point in top_points do
        table.insert(final_points, top_point)
    end
    for _, bottom_point in reverse_table(bottom_points) do
        table.insert(final_points, bottom_point)
    end

    return final_points
end

function normalize_angle(angle)
    return (angle + 360) % 360
end

function is_angle_between(angle, left, right)
    local normal_angle = normalize_angle(angle)
    local normal_left = normalize_angle(left)
    local normal_right = normalize_angle(right)
    --util.log("checking if "..normal_angle.." between "..normal_left.." and "..normal_right)
    if (normal_left < normal_right) then
        return (normal_left <= normal_angle and normal_angle <= normal_right)
    else
        return (normal_left <= normal_angle or normal_angle <= normal_right)
    end
end

function get_controls_angle_magnitude()
    local mouse_movement = {
        x=GET_CONTROL_NORMAL(0, 13),
        y=GET_CONTROL_NORMAL(0, 12),
    }
    local magnitude = math.sqrt(mouse_movement.x ^ 2 + mouse_movement.y ^ 2)
    local angle = math.deg(math.atan(mouse_movement.y, mouse_movement.x))
    return angle, magnitude
end

cmm.handle_inputs = function(target)
    DISABLE_CONTROL_ACTION(0, 1, false) --x
    DISABLE_CONTROL_ACTION(0, 2, false) --y
    target.cursor_pos = nil
    target.cursor_angle = nil
    target.cursor_angle_magnitude = nil
    if IS_USING_KEYBOARD_AND_MOUSE(1) then
        SET_MOUSE_CURSOR_THIS_FRAME()
        SET_MOUSE_CURSOR_STYLE(1)
        target.cursor_pos = {
            x=GET_CONTROL_NORMAL(0, 239),
            y=GET_CONTROL_NORMAL(0, 240),
        }
    else
        local angle, magnitude = get_controls_angle_magnitude()
        target.cursor_angle = angle
        target.cursor_angle_magnitude = magnitude
    end
end

cmm.check_option_hotkeys = function(target)
    --PAD.DISABLE_CONTROL_ACTION(2, 245, true) --chat
    for option_index, option in target.relevant_options do
        local hotkey = option.hotkey
		if hotkey then hotkey = hotkey:upper() end
		if hotkey and hotkey_map[hotkey] ~= nil then hotkey = hotkey_map[hotkey] end
        if hotkey ~= nil and util.is_key_down(hotkey) then
            target.selected_option = option
            cmm.execute_selected_action(target)
        end
    end
end

cmm.find_selected_option = function(target)
    for option_index, option in target.relevant_options do
        if target.cursor_pos then
            if is_point_in_polygon(target.cursor_pos.x, target.cursor_pos.y, option.vertices) then
                target.selected_option = option
            elseif target.selected_option == option then
                -- Leaving selection
                target.selected_option.ticks_shown = nil
                target.selected_option = nil
            end
        elseif target.cursor_angle then
            local first_point_angle = option.point_angles[1]
            local last_point_angle = option.point_angles[#option.point_angles]
            local is_option_pointed_at = is_angle_between(target.cursor_angle, first_point_angle, last_point_angle)
            if target.cursor_angle_magnitude > 0.2 then
                if is_option_pointed_at and target.cursor_angle_magnitude > 0.8 then
                    target.selected_option = option
                elseif target.selected_option == option and (not is_option_pointed_at) then
                    target.selected_option = nil
                end
            end
        end
    end
end

cmm.trigger_selected_action = function(target)
    if target.selected_option ~= nil then
        -- Delay execution to make sure this trigger is intentional
        if target.selected_option.ticks_shown == nil then
            target.selected_option.ticks_shown = 0
        elseif target.selected_option.ticks_shown > config.menu_release_delay then
            cmm.execute_selected_action(target)
        else
            util.draw_debug_text("ticks shown = "..target.selected_option.ticks_shown)
            target.selected_option.ticks_shown = target.selected_option.ticks_shown + 1
        end
    end
end

cmm.execute_selected_action = function(target)
    state.is_menu_open = false
    if target.selected_option.execute ~= nil and type(target.selected_option.execute) == "function" then
        util.log("Triggering option "..target.selected_option.name)
        --if cmm.is_target_a_player_in_vehicle(target) then
        --    target.handle = GET_VEHICLE_PED_IS_IN(target.handle, false)
		--	cmm.update_target_data(target)
        --end
        target.selected_option.execute(target)
    end
end

function get_option_wedge_draw_color(target, option)
    local draw_color = config.color.option_wedge
    if target.selected_option == option then
        if target.selected_option.ticks_shown ~= nil then
            if (target.selected_option.ticks_shown/2) % 2 == 0 then
                draw_color = config.color.option_wedge
            else
                draw_color = config.color.selected_option_wedge
            end
        else
            draw_color = config.color.selected_option_wedge
        end
    end
    return draw_color
end

cmm.draw_options_menu = function(target)
    directx.draw_circle(target.menu_pos.x, target.menu_pos.y, config.menu_radius, config.color.options_circle)

    --if target.screen_pos.x > 0 and target.screen_pos.y > 0 then
    --    directx.draw_line(0.5, 0.5, target.screen_pos.x, target.screen_pos.y, config.color.line_to_target)
    --end

    cmm.draw_target_label(target)

    for option_index, option in target.relevant_options do
        if option.name ~= nil then
            local option_text_coords = get_circle_coords(target.menu_pos, config.menu_radius*config.option_label_distance, option.option_angle)
            cmm.draw_text_with_shadow(option_text_coords.x, option_text_coords.y, option.name, 5, 0.5, config.color.option_text, true)

            draw_polygon(option.wedge_points, get_option_wedge_draw_color(target, option))

            if config.show_option_help and target.selected_option == option then
                cmm.draw_text_with_shadow(target.menu_pos.x, target.menu_pos.y + (config.menu_radius * 1.9), option.help, 5, 0.5, config.color.help_text, true)
                if option.hotkey then
                    cmm.draw_text_with_shadow(
                        target.menu_pos.x, target.menu_pos.y + (config.menu_radius * 1.9) + 0.02,
                        "Hotkey: "..option.hotkey, 5, 0.5, config.color.help_text, true
                    )
                end
            end
        end
    end
end

cmm.draw_target_label = function(target)
    if config.show_target_name and target.name ~= nil then
        local label = target.type .. ": " .. target.name
        if config.show_target_owner and target.owner and target.owner ~= target.name then
            label = label .. " (" .. target.owner .. ")"
        end
        cmm.get_distance_from_player(target)
        if target.distance_from_player then
            label = label .. " [" .. roundDecimals(target.distance_from_player, 1) .. "m]"
        end

        if cmm.is_target_a_player_in_vehicle(target) then
            local row_offset = 0.02
            cmm.draw_text_with_shadow(target.menu_pos.x, target.menu_pos.y - (config.menu_radius * 1.9) - row_offset, label, 5, 0.5, config.color.option_text, true)
            local players_vehicle = GET_VEHICLE_PED_IS_IN(target.handle, false)
            label = "VEHICLE: " .. cmm.get_vehicle_name_by_handle(players_vehicle)
            cmm.draw_text_with_shadow(target.menu_pos.x, target.menu_pos.y - (config.menu_radius * 1.9), label, 5, 0.5, config.color.option_text, true)
        else
            cmm.draw_text_with_shadow(target.menu_pos.x, target.menu_pos.y - (config.menu_radius * 1.9), label, 5, 0.5, config.color.option_text, true)
       end
    end
end

function is_menu_option_relevant(menu_option, target)
    -- Disabled options never apply to any target
    if menu_option.enabled == false then return false end
    -- If no applicable_to set then apply to all targets
    if menu_option.applicable_to == nil then return true end
    -- If type is specifically listed as applicable then allow it
    if table.contains(menu_option.applicable_to, target.type) then
        return true
    end
    -- Also include vehicle options for players in vehicles
    --if cmm.is_target_a_player_in_vehicle(target) and table.contains(menu_option.applicable_to, "VEHICLE") then
    --    return true
    --end
    -- Disallow anything else
    return false
end

cmm.is_target_a_player_in_vehicle = function(target)
    return target.type == "PLAYER" and IS_PED_IN_ANY_VEHICLE(target.handle)
end

cmm.deep_table_copy = function(obj)
    if type(obj) ~= 'table' then
        return obj
    end
    local res = setmetatable({}, getmetatable(obj))
    for k, v in pairs(obj) do
        res[cmm.deep_table_copy(k)] = cmm.deep_table_copy(v)
    end
    return res
end

cmm.build_relevant_options = function(target)
    target.relevant_options = {}
    for _, option in cmm.menu_options do
        if is_menu_option_relevant(option, target) then
            table.insert(target.relevant_options, cmm.deep_table_copy(option))
        end
    end
    --if #relevant_options == 1 then table.insert(relevant_options, cmm.empty_menu_option()) end
    table.sort(target.relevant_options, function(a,b) return a.priority > b.priority end)
    cmm.build_option_wedge_points(target)
end

function get_target_type(new_target)
    local entity_type = ENTITY_TYPES[GET_ENTITY_TYPE(new_target.handle)] or "WORLD_OBJECT"
    if entity_type == "PED" and entities.is_player_ped(new_target.handle) then
        return "PLAYER"
    end
    return entity_type
end

function get_player_id_from_handle(handle)
    for _, pid in players.list() do
        local player_ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
        if player_ped == handle then
            return pid
        end
    end
end

cmm.get_vehicle_name_by_model= function(model_hash)
    return util.get_label_text(GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(model_hash))
end

cmm.get_vehicle_name_by_handle = function(handle)
    return cmm.get_vehicle_name_by_model(entities.get_model_hash(handle))
end

function get_target_name(target)
    if target.type == "PLAYER" and target.player_id then
        return GET_PLAYER_NAME(target.player_id)
    elseif target.type == "VEHICLE" then
        return cmm.get_vehicle_name_by_model(target.model_hash)
    end
    return target.model
end

function get_target_owner(target)
    local owner_pid
    if target.type == "PLAYER" then
        owner_pid = get_player_id_from_handle(target.handle)
    elseif target.handle and target.type ~= "WORLD_OBJECT" then
        owner_pid = entities.get_owner(target.handle)
    end
    if owner_pid ~= nil and owner_pid > 0 then
        return GET_PLAYER_NAME(owner_pid)
    end
end

-- credit to the amazing aarroonn
function get_model_hash(handle_or_ptr)
    --debug_log("Loading model hash for "..tostring(handle_or_ptr))
    if handle_or_ptr == nil or not (handle_or_ptr > 0) then return end
    local pointer = handle_or_ptr
    if handle_or_ptr < 0xFFFFFF then
        pointer = entities.handle_to_pointer(handle_or_ptr)
    end
    if pointer == nil or not (pointer > 0) then return end
    local status, model_info
    if config.wrap_read_model_with_pcall then
        status, model_info = pcall(memory.read_long, pointer + 0x20)
        if not status then
            util.toast("Warning: Access Violation for Handle: "..handle_or_ptr.." Pointer:"..pointer, TOAST_ALL)
            return
        end
    else
        --util.log("Reading model hash Handle: "..handle_or_ptr.." Pointer:"..pointer, TOAST_ALL)
        model_info = memory.read_long(pointer + 0x20)
    end
    if model_info ~= 0 then
        return memory.read_int(model_info + 0x18)
    end
end

cmm.build_target_from_pointer = function(handle)
    if not handle then return end
    local target = {}
    return target
end

cmm.update_target_data = function(target)
    target.type = get_target_type(target)
	target.player_id = get_player_id_from_handle(target.handle)
    target.name = get_target_name(target)
    target.owner = get_target_owner(target)
end

cmm.expand_target_model = function(target)
    target.model_hash = entities.get_model_hash(target.handle)
    if target.model_hash then
        target.model = util.reverse_joaat(target.model_hash)
    end
    cmm.update_target_data(target)
    target.pos = GET_ENTITY_COORDS(target.handle, true)
    cmm.expand_target_position(target)
end

cmm.build_target_from_handle = function(handle)
    if not handle then return end
    local target = {}
    target.handle = handle
    cmm.expand_target_model(target)
    return target
end

cmm.build_target_from_position = function(position)
    local target = {}
    target.type = "COORDS"
    target.pos = { x=roundDecimals(position.x, 1), y=roundDecimals(position.y, 1), z=roundDecimals(position.z, 1)}
    target.name = target.pos.x..","..target.pos.y
    cmm.expand_target_position(target)
    return target
end

cmm.expand_target_position = function(target)
    target.menu_pos = { x=0.5, y=0.5, }
    cmm.build_relevant_options(target)
    target.screen_pos = { x=0.5, y=0.5, }
    cmm.refresh_screen_pos(target)
end

cmm.build_target_from_raycast_result = function(raycastResult)
    local model_hash
    if raycastResult.didHit then
        --util.log("Loading model hash from raycast: "..raycastResult.hitEntity)
        -- Aaron's model hash function works for WORLD OBJECTs that dont normally return an entity type
        -- but sometimes causes memory ACCESS_VIOLATION errors
        if config.use_aarons_model_hash then
            model_hash = get_model_hash(raycastResult.hitEntity)
        else
            local entity_type = GET_ENTITY_TYPE(raycastResult.hitEntity)
            util.log("Loading entity type "..entity_type)
            if entity_type > 0 then
                model_hash = entities.get_model_hash(raycastResult.hitEntity)
            end
        end
    end

    if config.debug_mode then
        util.draw_debug_text("didhit = "..raycastResult.didHit)
        util.draw_debug_text("handle = "..raycastResult.hitEntity)
        util.draw_debug_text("endcoords = "..raycastResult.endCoords.x..","..raycastResult.endCoords.y)
        util.draw_debug_text("hash = "..tostring(model_hash))
    end

    if raycastResult.didHit and model_hash ~= nil then
        -- Handle Entity Target
        if raycastResult.hitEntity ~= nil and DOES_ENTITY_EXIST(raycastResult.hitEntity) then
            return cmm.build_target_from_handle(raycastResult.hitEntity)
        end
    end
end

--local flag = TRACE_FLAG.VEHICLE | TRACE_FLAG.OBJECT | TRACE_FLAG.MOVER | TRACE_FLAG.PED | TRACE_FLAG.GLASS

cmm.get_raycast_target = function()
    local raycastResult

    -- Raycast for Entity Objects
    raycastResult = get_raycast_result(config.selection_distance, config.trace_flag_value)
    local target = cmm.build_target_from_raycast_result(raycastResult)
    if target then return target end

    -- Raycast for World Coords
    raycastResult = get_raycast_result(config.selection_distance, TRACE_FLAG.ALL)
    if raycastResult.endCoords.x ~= 0 and raycastResult.endCoords.y ~= 0 then
        return cmm.build_target_from_position(raycastResult.endCoords)
    end
end

cmm.refresh_screen_pos = function(target)
    if not target then return end
    if target.handle then
        target.pos = GET_ENTITY_COORDS(target.handle, true)
    end
    if target.pos and GET_SCREEN_COORD_FROM_WORLD_COORD(target.pos.x, target.pos.y, target.pos.z, pointx, pointy) then
        target.screen_pos = { x=memory.read_float(pointx), y=memory.read_float(pointy)}
    else
        target.screen_pos = {x=0, y=0}
    end
end

cmm.update_menu = function(target)
    cmm.handle_inputs(target)
    cmm.check_option_hotkeys(target)
    cmm.find_selected_option(target)
    cmm.draw_options_menu(target)
    cmm.draw_ped_preview(target)
end

cmm.open_options_menu = function(target)
    if not state.is_menu_open then
        target.selected_option = nil
        target.cursor_pos = { x=0.5, y=0.5, }
        SET_CURSOR_POSITION(target.cursor_pos.x, target.cursor_pos.y)
        state.is_menu_open = true
        -- Re-opening the menu while a trigger is executing cancels the trigger
        if target.selected_option then target.selected_option.ticks_shown = nil end
    end
end

cmm.close_options_menu = function(target)
    if state.is_menu_open then
        cmm.trigger_selected_action(target)
    end
    if not target.selected_option then
        state.is_menu_open = false
    end
end

cmm.draw_pointer_line = function(target)
    cmm.refresh_screen_pos(target)
    local pos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0.0, 0.0, 0.0)
    if target.screen_pos.x ~= 0 and target.screen_pos.y ~= 0
            and GET_SCREEN_COORD_FROM_WORLD_COORD(pos.x, pos.y, pos.z, pointx, pointy) then
        local player_pos = { x=memory.read_float(pointx), y=memory.read_float(pointy)}
        directx.draw_line(player_pos.x, player_pos.y, target.screen_pos.x, target.screen_pos.y, config.color.target_bounding_box)
    end
end

cmm.draw_selection = function(target)
    if target.type == "COORDS" then
        util.draw_sphere(
            target.pos,
            config.target_ball_size,
            config.color.target_ball_output.r,
            config.color.target_ball_output.g,
            config.color.target_ball_output.b,
            config.color.target_ball_output.a,
            40
        )
    else
        cmm.draw_bounding_box(target)
		cmm.draw_pointer_line(target)
    end
end

cmm.build_option_wedge_points = function(target)
    -- If only one option then assume two so the menu isnt just a single circle
    local num_options = math.max(#target.relevant_options, 2)
    -- Split circle up into n slices of width `option_width` degrees
    target.option_width = 360 / num_options
    for option_index, option in target.relevant_options do
        if option.name ~= nil then
            option.option_angle = ((option_index-1) * target.option_width) - 90
            option.point_angles = calculate_point_angles(target, option, option.option_angle, target.option_width)
            option.wedge_points = build_wedge_points(option.point_angles, target)
            option.vertices = build_vertices_list(option.wedge_points)
        end
    end
end

menu.toggle_loop(Entitymanagercontextmenu, "Context Menu enabled", {}, "Right-click on in-game objects to open context menu.", function()
    config.context_menu_enabled = true
    cmm.context_menu_draw_tick()
end, function()
    config.context_menu_enabled = false
end)

---
--- Menu Options
---

menus.menu_options = menu.list(Entitymanagercontextmenu, "Menu Options", {}, "Enable or disable specific context menu options.")
menus.menu_options:action("Open ContextMenus Folder", {}, "Add ContextMenu scripts to this folder", function()
    util.open_folder(CONTEXT_MENUS_DIR)
end)

function build_menu_option_description(menu_option)
    local text = menu_option.help or ""
    if menu_option.author then text = text.."\nAuthor: "..menu_option.author end
    if menu_option.filename then text = text.."\nFilename: "..menu_option.filename end
    if menu_option.filepath then text = text.."\nFilepath: "..menu_option.filepath end
    return text
end

menus.menu_options:divider("Menu Options")
for _, menu_option in cmm.menu_options do
    menu_option.menu = menus.menu_options:list(menu_option.name, {"cmmconfig"..menu_option.name}, "Configuration options for this specific menu option")
    menu_option.menu:toggle("Enabled", {}, "Enabled options will show up in menu", function(value)
        menu_option.enabled = value
    end, menu_option.enabled)
    menu_option.menu:text_input("Hotkey", {"cmmhotkey"..menu_option.name}, "Press this key while the menu is open to select this option", function(value)
        menu_option.hotkey = value
    end, menu_option.hotkey or "")
    menu_option.menu:slider("Priority", {"cmmpriority"..menu_option.name}, "Higher priority options appear higher in the menu order", -1000, 1000, menu_option.priority, 1, function(value)
        menu_option.priority = value
    end)
    -- build_menu_option_description(menu_option)
    if menu_option.config_menu ~= nil then
        menu_option.menu:divider("Config")
        menu_option.config_menu(menu_option.menu)
    end
end

---
--- Settings Menu
---

menus.settings = menu.list(Entitymanagercontextmenu, "Settings", {}, "Configuration options for this script.")
menus.settings:toggle("Disable In Vehicles", {}, "Only display the menu when on foot, outside of a vehicle", function(value)
    config.disable_in_vehicles = value
end, config.disable_in_vehicles)

menus.settings:divider("Targeting")

menus.settings:toggle("Switch to NPC in veh possible", {}, "Makes it possible to change to npc in veh", function(value)
    config.target_switch_ped_veh = value
end, config.target_switch_ped_veh)
menus.settings:toggle("Ignore player vehicle", {}, "ignores the players vehicle so the player is on focus", function(value)
    config.target_ignore_player_veh = value
end, config.target_ignore_player_veh)

menus.settings_snap_distance = menus.settings:list("Snap Distance", {}, "How close your crosshair needs to be to an entity to snap to it")
menus.settings_snap_distance:slider_float("Player Snap Distance", {"cmmsnapdistanceplayer"}, "How close your crosshair needs to be to a player to snap to it", 0, 100, math.floor(config.target_snap_distance.player * 100), 1, function(value)
    config.target_snap_distance.player = value / 100
end)
menus.settings_snap_distance:slider_float("Vehicle Snap Distance", {"cmmsnapdistancevehicle"}, "How close your crosshair needs to be to a vehicle to snap to it", 0, 100, math.floor(config.target_snap_distance.vehicle * 100), 1, function(value)
    config.target_snap_distance.vehicle = value / 100
end)
menus.settings_snap_distance:slider_float("Ped Snap Distance", {"cmmsnapdistanceped"}, "How close your crosshair needs to be to a ped to snap to it", 0, 100, math.floor(config.target_snap_distance.ped * 100), 1, function(value)
    config.target_snap_distance.ped = value / 100
end)
menus.settings_snap_distance:slider_float("Object Snap Distance", {"cmmsnapdistanceobject"}, "How close your crosshair needs to be to a object to snap to it", 0, 100, math.floor(config.target_snap_distance.object * 100), 1, function(value)
    config.target_snap_distance.object = value / 100
end)

menus.settings_target_distances = menus.settings:list("Target Distances", {}, "How far away an entity can be and still be targeted.")
menus.settings_target_distances:slider("Target Player Distance", {"cmmtargetplayerdistance"}, "The range that other players are targetable", 1, 5000, config.target_player_distance, 10, function(value)
    config.target_player_distance = value
end)
menus.settings_target_distances:slider("Target Vehicle Distance", {"cmmtargetvehicledistance"}, "The range that vehicles are targetable", 1, 5000, config.target_vehicle_distance, 10, function(value)
    config.target_vehicle_distance = value
end)
menus.settings_target_distances:slider("Target Ped Distance", {"cmmtargetpeddistance"}, "The range that peds are targetable", 1, 5000, config.target_ped_distance, 10, function(value)
    config.target_ped_distance = value
end)
menus.settings_target_distances:slider("Target Object Distance", {"cmmtargetobjectdistance"}, "The range that objects are targetable", 1, 5000, config.target_object_distance, 10, function(value)
    config.target_object_distance = value
end)
menus.settings_target_distances:slider("Target World Distance", {"cmmtargetworlddistance"}, "The range that world coords are targetable", 1, 600, config.selection_distance, 10, function(value)
    config.selection_distance = value
end)

menus.settings_trace_flags = menus.settings:list("Trace Flags", {}, "Set what kind of entities you can target")
for _, trace_flag_option in config.trace_flag_options do
    menus.settings_trace_flags:toggle(trace_flag_option.name, {}, "", function(value)
        trace_flag_option.enabled = value
        cmm.rebuild_trace_flag_value()
    end, trace_flag_option.enabled)
end

menus.settings:divider("Display")

menus.settings_show_target_texts = menus.settings:list("Show Target Texts", {}, "Show various text options on target")
menus.settings_show_target_texts:toggle("Show Target Name", {}, "Should the target model name be displayed above the menu", function(value)
    config.show_target_name = value
end, config.show_target_name)
menus.settings_show_target_texts:toggle("Show Target Owner", {}, "Should the player that owns the object be displayed above the menu in paranthesis", function(value)
    config.show_target_owner = value
end, config.show_target_owner)
menus.settings_show_target_texts:toggle("Show Option Help", {}, "Should the selected option help text be displayed below the menu", function(value)
    config.show_option_help = value
end, config.show_option_help)


menus.settings:slider("Target Ball Size", {"cmmtargetballsize"}, "The size of the world target cursor ball", 5, 140, config.target_ball_size * 100, 5, function(value)
    config.target_ball_size = value / 100
end)
menus.settings:slider("Menu Radius", {"cmmmenuradius"}, "The size of the context menu disc", 5, 25, config.menu_radius * 100, 1, function(value)
    config.menu_radius = value / 100
end)
menus.settings:slider("Deadzone", {"cmmdeadzone"}, "The center of the menu where no option is selected", 5, 30, config.option_wedge_deadzone * 100, 1, function(value)
    config.option_wedge_deadzone = value / 100
end)
menus.settings:slider("Option Padding", {"cmmoptionpadding"}, "The spacing between options", 0, 25, config.option_wedge_padding * 100, 1, function(value)
    config.option_wedge_padding = value / 100
end)

menus.settings_player_previews = menus.settings:list("Player Previews", {}, "Options about displaying previews when targeting other players")
menus.settings_player_previews:toggle("Enable Player Previews", {}, "Display previews of the players model when targeting", function(value)
    config.ped_preview.enabled = value
end, config.ped_preview.enabled)
menus.settings_player_previews:list_select("Preset Name", {"cmmplayerpreviewpresetname"}, "The selected preset name used for the rendering.", preset_name_list, preset_name_index_map[config.ped_preview.preset_name], function(value, menu_name)
    config.ped_preview.preset_name = menu_name
    menu.set_value(menus.settings_player_previews_preset_slot, config.ped_preview.preset_slot)
    menu.set_max_value(menus.settings_player_previews_preset_slot, preset_slot_values[config.ped_preview.preset_name])
end)
menus.settings_player_previews_preset_slot = menus.settings_player_previews:slider("Preset Slot", {"cmmplayerpreviewpresetslot"}, "The selected preset slot used for the rendering.", 0, preset_slot_values[config.ped_preview.preset_name], 0, 1, function(value)
    config.ped_preview.preset_slot = value
end)
menus.settings_player_previews:slider("Player Preview Pos X", {"cmmplayerpreviewposx"}, "", -20, 20, config.ped_preview.pos.x * 10, 1, function(value)
    config.ped_preview.pos.x = value / 10
end)
menus.settings_player_previews:slider("Player Preview Pos Y", {"cmmplayerpreviewposy"}, "", -100, 10, config.ped_preview.pos.y * 10, 1, function(value)
    config.ped_preview.pos.y = value / 10
end)
menus.settings_player_previews:slider("Player Preview Pos Z", {"cmmplayerpreviewposz"}, "", -20, 20, config.ped_preview.pos.z * 10, 1, function(value)
    config.ped_preview.pos.z = value / 10
end)

menus.settings_colors = menus.settings:list("Colors")
menus.settings_colors:colour("Target Ball Color", {"cmmcolortargetball"}, "The ball cursor when no specific entity is selected", config.color.target_ball, true, function(color)
    config.color.target_ball = color
    config.color.target_ball_output = cmm.color_menu_output(config.color.target_ball)
end)
menus.settings_colors:colour("Target Bounding Box Color", {"cmmcolortargetboundingbox"}, "The bounding box cursor when a specific entity is selected", config.color.target_bounding_box, true, function(color)
    config.color.target_bounding_box = color
    config.color.target_bounding_box_output = cmm.color_menu_output(config.color.target_bounding_box)
end)
menus.settings_colors:colour("Menu Circle Color", {"cmmcolorcirclecolor"}, "The menu circle color", config.color.options_circle, true, function(color)
    config.color.options_circle = color
end)
menus.settings_colors:colour("Option Wedge Color", {"cmmcolorwedgecolor"}, "An individual option wedge color", config.color.option_wedge, true, function(color)
    config.color.option_wedge = color
end)
menus.settings_colors:colour("Selected Option Wedge Color", {"cmmcolorselectedwedgecolor"}, "The currently selected option wedge color", config.color.selected_option_wedge, true, function(color)
    config.color.selected_option_wedge = color
end)
menus.settings_colors:colour("Line to Target Color", {"cmmcolortargetcolor"}, "Line from menu to target color", config.color.line_to_target, true, function(color)
    config.color.line_to_target = color
end)










CLEAR_AREA_RANGE = 100
function clearAreaOfEntities(entitie, range)
    local rangesq = range*range
    local pc = players.get_position(players.user())
		if entitie == "ped" then
			for _, ped in pairs(entities.get_all_peds_as_handles()) do
				local cc = GET_ENTITY_COORDS(ped)
	            if (VDIST2(pc.x, pc.y, pc.z, cc.x, cc.y, cc.z) <= rangesq) and not IS_PED_A_PLAYER(ped) then
	                entities.delete(ped)
				end
			end
		end
		if entitie == "veh" then
			local currentVehicle = entities.get_user_vehicle_as_handle(true)
			local persoveh = entities.get_user_personal_vehicle_as_handle()
	        for _, vehicle in pairs(entities.get_all_vehicles_as_handles()) do
				local cc = GET_ENTITY_COORDS(vehicle)
	            if not (currentVehicle == vehicle) and (VDIST2(pc.x, pc.y, pc.z, cc.x, cc.y, cc.z) <= rangesq) then
	                local vehData = getTargetVehicleData(vehicle)
	                if vehData.player == -1 and not (vehicle == currentVehicle) and not (vehicle == persoveh) then
	                    entities.delete(vehicle)
	                end
	            end
	        end
		end
		if entitie == "obj" then
			for _, object in pairs(entities.get_all_objects_as_handles()) do
				local cc = GET_ENTITY_COORDS(object)
	            if (VDIST2(pc.x, pc.y, pc.z, cc.x, cc.y, cc.z) <= rangesq) then
	                entities.delete(object)
	            end
	        end
		end
		if entitie == "pickup" then
			for _, pickups in pairs(entities.get_all_pickups_as_handles()) do
				local cc = GET_ENTITY_COORDS(pickups)
	            if (VDIST2(pc.x, pc.y, pc.z, cc.x, cc.y, cc.z) <= rangesq) then
	                entities.delete(pickups)
	            end
	        end
		end
end

function getAreaOfEntities(tbl, range)
    local rangesq = range*range
    local pc = GET_ENTITY_COORDS(players.user_ped())
    for _, v in pairs(tbl) do
        local cc = entities.get_position(v)
        if (VDIST2(pc.x, pc.y, pc.z, cc.x, cc.y, cc.z) <= rangesq) then
            local h = entities.pointer_to_handle(v)
			local playervehicle = entities.get_user_vehicle_as_handle(true)
            if IS_ENTITY_AN_OBJECT(h) then
				if IS_OBJECT_A_PICKUP(h) then
               		return h
				else
					return h
				end
			elseif IS_ENTITY_A_PED(h) and not IS_PED_A_PLAYER(h) then
				return h
			elseif IS_ENTITY_A_VEHICLE(h) and not (playervehicle == h) then
				return h
			else 
				return nil
            end
        end
    end
end

--local x = entities.get_model_hash(h)
menu.toggle_loop(Entitymanagercleararea, "Clear Area of Peds", {"clearpeds"}, "", function ()
	clearAreaOfEntities("ped", CLEAR_AREA_RANGE)
end)
menu.toggle_loop(Entitymanagercleararea, "Clear Area of Vehicles", {"clearvehs"}, "spieler werden ignoriert", function ()
    clearAreaOfEntities("veh", CLEAR_AREA_RANGE)
end)
menu.toggle_loop(Entitymanagercleararea, "Clear Area of Objects", {"clearobjs"}, "", function ()
    clearAreaOfEntities("obj", CLEAR_AREA_RANGE)
end)
menu.action(Entitymanagercleararea, "Clear Area of Pickups", {"clearpickups"}, "", function ()
    clearAreaOfEntities("pickup", CLEAR_AREA_RANGE)
end)
menu.toggle_loop(Entitymanagercleararea, "Delete all", {"deleteall"}, "", function ()
    clearAreaOfEntities("ped",CLEAR_AREA_RANGE)
	clearAreaOfEntities("veh", CLEAR_AREA_RANGE)
	clearAreaOfEntities("obj", CLEAR_AREA_RANGE)
	clearAreaOfEntities("pickup", CLEAR_AREA_RANGE)
	util.yield(200)
end)
menu.action(Entitymanagercleararea, "Clear ALL Ropes", {"clearropes"}, "", function()
    for i = 0, 100 do
        DELETE_CHILD_ROPE(i)
    end
end)
menu.slider(Entitymanagercleararea, "Clear Area Range", {"cleararearange"}, "", 0, 10000, 100, 50, function (value)
    CLEAR_AREA_RANGE = value
end)

menu.toggle(player_zeug, "player join nachricht", {}, "", function(on_toggle)
	if on_toggle then
		player_join = true
	else 
		player_join = false
	end
end)

menu.toggle(player_zeug, "Kick leute mit host token spoof", {}, "geht nur auf leute die nach dir in eine sitzung joinen und nicht auf leute wo du gerade rein joinst", function(on_toggle)
	if on_toggle then
		kickhosttokenspoof = true
	else 
		kickhosttokenspoof = false
	end
end)

menu.toggle_loop(player_zeug, "Script Host Addict", {}, "A faster version of script host kleptomaniac", function()
    if players.get_script_host() ~= players.user() and not util.is_session_transition_active() then
        menu.trigger_commands("scripthost")
    end
end)

menu.toggle_loop(player_zeug, "Anti modder scripthost", {}, "gibt dir script host wenn ein spieler der modder ist script host ist/wird\nHat kein effekt auf freunde", function()
	local pid = players.get_script_host()
    if players.get_script_host() ~= players.user() and not util.is_session_transition_active() and not PlayerisFriend(pid) then
		if players.is_marked_as_modder(pid) then
			util.toast("Script host wurde dir gegeben")
        	menu.trigger_commands("scripthost")
		end
    end
end)

local anti_laender_zeug = menu.list(player_zeug, "Anti Länder zeug", {}, "")
local leanderauswahl = menu.list(anti_laender_zeug, "länder auswahl", {}, "")
local ESP = menu.list(player_zeug, "ESP", {}, "")
local antivehicleaction = menu.list(player_zeug, "Anti vehicle action", {}, "")
local translator = menu.list(player_zeug, "Translator", {}, "")
--local selfmadeplayerhistory = menu.list(player_zeug, "Player history", {}, "")


local enabled, enableOnAim = false, false
local xValue, yValue, scaleValue, fovset = 0, 0, 35, 10
local color = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 }
local maxDistance = 400
local showDistance, showWanted, showRank, showLanguage, showName, showTags, showHealth, showArmor, showKD, showMoney, showWeapon, showInMyVehicle, showVehicle, showSpeed,
	hideInterior, showBounty, showorgandowner, showorgmembers, showVehicleidname, drawlineespp, drawboxespp = true, false, false, false, true, true, false, false, false, false, true, true, true, false, false, false, false, false, false, true, true

	function getName(pid, inVehicle)
	    local value = ""
	    if showName or inVehicle then
	        value = players.get_name(pid)
	    end
	    local tags = ""
	    if showTags then
	        tags = players.get_tags_string(pid)
	    end
	    if (showTags or inVehicle) and tags:len() > 0 then
	        value = value .. " [" .. tags .. "]"
	    end
	    local preName = ""
	    if not inVehicle then
	        if showWanted then
	            local wanted = GET_PLAYER_WANTED_LEVEL(pid)
	            if wanted > 0 then
	                preName = wanted .. "* "
	            end
	        end
	        if showRank then
	            preName = preName .. "(" .. players.get_rank(pid) .. ") "
	        end
	    end
	    if showLanguage then
	        preName = preName .. "[" .. getLanguage(pid) .. "] "
	    end
	    return preName .. value
	end

	function renderESP()
		if not enabled then
	        return false
	    end
	    if not util.is_session_started() or IS_PAUSE_MENU_ACTIVE() then
	        return
	    end
	    if enableOnAim and not IS_PLAYER_FREE_AIMING(players.user()) then
	        return
	    end
		local gameX, gameY = memory.alloc(1), memory.alloc(1)
	    local myPed = players.user_ped()
		local myPos = getPlayerPosition()
		if players.get_spectate_target(players.user()) != -1 then
			myPos = players.get_position(players.get_spectate_target(players.user()))
		end
	    for _, pid in players.list(false) do
	        local ped = GET_PLAYER_PED(pid)
			if deactivateOnAim and IS_PLAYER_FREE_AIMING(players.user()) then
				if IS_PED_FACING_PED(myPed, ped, fovset) then
					goto continue
				end
			end
	        if IS_PLAYER_DEAD(pid) and not IS_ENTITY_ON_SCREEN(ped) or
	            (hideInterior and getInterior(pid) and not table.contains({"cayoPerico", "ussLex"}, getInterior(pid))) then
	            goto continue
	        end
	        local pPos = getPlayerPosition(pid)
	        local dist = myPos:distance(pPos)
	        if dist > maxDistance then
	            goto continue
	        end
	        local vehicle = getVehicle(ped)
	        local isMyVehicle = false
	        if vehicle then
	            local driver = GET_PED_IN_VEHICLE_SEAT(vehicle, -1)
	            if driver ~= ped and driver ~= myPed and IS_PED_A_PLAYER(driver) then
	                goto continue
	            elseif driver == myPed then
	                if not showInMyVehicle then
	                    goto continue
	                end
	                isMyVehicle = true
	            end
	        end
	        local posToUse = pPos
	        if vehicle and not isMyVehicle then
	            posToUse = GET_ENTITY_COORDS(vehicle)
	        end
	        GET_SCREEN_COORD_FROM_WORLD_COORD(posToUse.x, posToUse.y, posToUse.z + 1, gameX, gameY)
	        local screenX, screenY = memory.read_float(gameX), memory.read_float(gameY)
	        local valuesToDisplay = {}
	        local playersInVehicle = ""
			local vehidname = util.reverse_joaat(players.get_vehicle_model(pid))
	        if vehicle and not isMyVehicle then
	            local maxPassengers = GET_VEHICLE_MAX_NUMBER_OF_PASSENGERS(vehicle)
	            for i = 0, maxPassengers do
	                if not IS_VEHICLE_SEAT_FREE(vehicle, i, false) then
	                    local vehPed = GET_PED_IN_VEHICLE_SEAT(vehicle, i)
	                    if IS_PED_A_PLAYER(vehPed) then
	                        playersInVehicle = playersInVehicle .. getName(NETWORK_GET_PLAYER_INDEX_FROM_PED(vehPed), true) .. ", "
	                    end
	                end
	            end
	        end
	        if showDistance then
	            valuesToDisplay[#valuesToDisplay + 1] = math.floor(dist)
	        end
	        local nameLine = getName(pid)
	        if nameLine:len() > 0 then
	            valuesToDisplay[#valuesToDisplay + 1] = nameLine
	        end
	        if playersInVehicle:len() > 0 then
	            valuesToDisplay[#valuesToDisplay + 1] = "in Vehicle" .. ": " .. playersInVehicle:gsub(", $", "")
	        end
			local orgowner = players.get_boss(pid)
			if showorgandowner then
				if orgowner != -1 then
					local orgtype = getorgtype(orgowner)
					if orgtype != "false" then
						if orgowner == pid then
							valuesToDisplay[#valuesToDisplay + 1] = orgtype.. " [OWNER]"
						else
							valuesToDisplay[#valuesToDisplay + 1] = orgtype.. " [".. players.get_name(orgowner).. "]"
						end
					end
				end
			end
			local orgmembers = ""
			if showorgmembers then
				if orgowner != -1 then
					local orgmem = getorganisationplayers(pid)
					if orgmem != {} then
						for orgmem as orgmember do
							if orgmember != orgowner then
								nameoforgmembers = players.get_name(orgmember)
								orgmembers = orgmembers .. nameoforgmembers .. ","
							end
						end
					end
				end
			end
			if orgmembers:len() > 0 then
				valuesToDisplay[#valuesToDisplay + 1] = "Orgmembers: ".. orgmembers:gsub(", $", "")
			end
	        local hpData = getHealth(ped)
	        if showHealth or showArmor then
	            local textline = ""
	            if showHealth then
	                textline = "H: " .. hpData.health .. "/" .. hpData.maxHealth .. " "
	            end
	            if showArmor then
	                textline = textline .. "A: " .. hpData.armor .. "/50"
	            end
	            valuesToDisplay[#valuesToDisplay + 1] = textline
	        end
	        if showBounty and players.get_bounty(pid) then
	            valuesToDisplay[#valuesToDisplay + 1] = "$$" .. players.get_bounty(pid)
	        end
	        if showMoney or showKD then
	            local textline = ""
	            if showKD then
	                textline = "KD " .. getKD(pid) .. " "
	            end
	            if showMoney then
	                textline = textline .. "$" .. getMoney(pid, true)
	            end
	            valuesToDisplay[#valuesToDisplay + 1] = textline
	        end
	        if showWeapon then
	            local weapon = getWeapon(ped)
	            if weapon then
	                valuesToDisplay[#valuesToDisplay + 1] = weapon
	            end
	        end
	        if (showVehicle or showSpeed or showVehicleidname) and vehicle then
	            local textline = ""
	            if showVehicle then
	                textline = getmodelnamebyhash(players.get_vehicle_model(pid)) .. " "
	            end
				if showVehicleidname then
					textline = textline .. "["..vehidname.."]" .. " "
				end
	            if showSpeed and getSpeed(vehicle, true) > 0 then
	                textline = textline .. getSpeed(vehicle)
	            end
	            valuesToDisplay[#valuesToDisplay + 1] = textline
	        end
	        local text = table.concat(valuesToDisplay, "\n")
	        directx.draw_text(screenX + xValue, screenY + yValue, text, 5, scaleValue, color, false)
			if drawlineespp then
				DRAW_LINE(myPos.x, myPos.y, myPos.z, pPos.x, pPos.y, pPos.z, 255, 0, 0, 255)
			end
			if drawboxespp then
				draw_bounding_box(ped)
			end
	        ::continue::
	    end
	end
	
enabledToggle = menu.toggle(ESP, "Enable ESP Player", {"ESP"}, "", function(on_toggle)
	if on_toggle then
		enabled = true
		util.create_tick_handler(renderESP)
	else
		enabled = false
	end
end)
local ESPSettings = menu.list(ESP, "Settings", {}, "")

enableOnAimToggle = menu.toggle(ESPSettings, "enableOnAimOnly", {}, "", function(on)
	enableOnAim = on
end, enableOnAim)
enableOnAim = menu.get_value(enableOnAimToggle)
deactivateOnAimToggle = menu.toggle(ESPSettings, "DeactivateOnAim", {}, "", function(on)
	deactivateOnAim = on
end, deactivateOnAim)
deactivateOnAim = menu.get_value(deactivateOnAimToggle)
drawlineesppToggle = menu.toggle(ESPSettings, "Draw line", {}, "", function(on)
	drawlineespp = on
end, drawlineespp)
drawlineespp = menu.get_value(drawlineesppToggle)
drawboxesppToggle = menu.toggle(ESPSettings, "Draw Box", {}, "", function(on)
	drawboxespp = on
end, drawboxespp)
drawboxespp = menu.get_value(drawboxesppToggle)
fovslider = menu.slider(ESPSettings, "FOV", {}, "", 1, 30, fovset, 1, function(val)
	fovset = val
end)
hideInteriorToggle = menu.toggle(ESPSettings, "hideInterior", {}, "", function(on)
	hideInterior = on
end, hideInterior)
hideInterior = menu.get_value(hideInteriorToggle)
local positionSubmenu = menu.list(ESPSettings, "position", {}, "")
xSlider = menu.slider(positionSubmenu, "XPos", {}, "", -10, 10, xValue, 1, function(val)
	xValue = val / 200
end)
--xValue = menu.get_value(xSlider) / 100
ySlider = menu.slider(positionSubmenu, "YPos", {}, "", -10, 10, yValue, 1, function(val)
	yValue = val / 200
end)
--yValue = menu.get_value(ySlider) / 100
scaleSlider = menu.slider(positionSubmenu, "scale", {}, "", 1, 200, scaleValue, 1, function(val)
	scaleValue = val / 100
end)
scaleValue = menu.get_value(scaleSlider) / 100
colorRef = menu.colour(ESPSettings, "color", {}, "", color, true, function(c)
	color = c
end)
maxDistSlider = menu.slider(ESPSettings, "maxDist", {"setespdist"}, "", 10, 10000, maxDistance, 10, function(val)
	maxDistance = val
end)
maxDistance = menu.get_value(maxDistSlider)

distToggle = menu.toggle(ESP, "showDistance", {}, "", function(on)
	showDistance = on
end, showDistance)
showDistance = menu.get_value(distToggle)
wantedToggle = menu.toggle(ESP, "showWanted", {}, "", function(on)
	showWanted = on
end, showWanted)
showWanted = menu.get_value(wantedToggle)
rankToggle = menu.toggle(ESP, "showRank", {}, "", function(on)
	showRank = on
end, showRank)
showRank = menu.get_value(rankToggle)
langToggle = menu.toggle(ESP, "showLanguage", {}, "", function(on)
	showLanguage = on
end, showLanguage)
showLanguage = menu.get_value(langToggle)
nameToggle = menu.toggle(ESP, "showName", {}, "", function(on)
	showName = on
end, showName)
showName = menu.get_value(nameToggle)
tagsToggle = menu.toggle(ESP, "showTags", {}, "", function(on)
	showTags = on
end, showTags)
showTags = menu.get_value(tagsToggle)
organdownerToggle = menu.toggle(ESP, "showorgandorgOwner", {}, "", function(on)
	showorgandowner = on
end, showorgandowner)
showorgandowner = menu.get_value(organdownerToggle)
orgmembersToggle = menu.toggle(ESP, "showorgmembers", {}, "", function(on)
	showorgmembers = on
end, showorgmembers)
showorgmembers = menu.get_value(orgmembersToggle)
hpToggle = menu.toggle(ESP, "showHealth", {}, "", function(on)
	showHealth = on
end, showHealth)
showHealth = menu.get_value(hpToggle)
armorToggle = menu.toggle(ESP, "showArmor", {}, "", function(on)
	showArmor = on
end, showArmor)
showArmor = menu.get_value(armorToggle)
kdToggle = menu.toggle(ESP, "showKD", {}, "", function(on)
	showKD = on
end, showKD)
showKD = menu.get_value(kdToggle)
bountyToggle = menu.toggle(ESP, "showBounty", {}, "", function(on)
	showBounty = on
end, showBounty)
showBounty = menu.get_value(bountyToggle)
moneyToggle = menu.toggle(ESP, "showMoney", {}, "", function(on)
	showMoney = on
end, showMoney)
showMoney = menu.get_value(moneyToggle)
weaponToggle = menu.toggle(ESP, "showWeapon", {}, "", function(on)
	showWeapon = on
end, showWeapon)
showWeapon = menu.get_value(weaponToggle)
myVehicleToggle = menu.toggle(ESP, "showInMyVehicle", {}, "", function(on)
		showInMyVehicle = on
	end, showInMyVehicle)
showInMyVehicle = menu.get_value(myVehicleToggle)
vehicleToggle = menu.toggle(ESP, "showVehicle", {}, "", function(on)
	showVehicle = on
end, showVehicle)
showVehicle = menu.get_value(vehicleToggle)
vehicleidnameToggle = menu.toggle(ESP, "showVehicle ID name", {}, "", function(on)
	showVehicleidname = on
end, showVehicleidname)
showVehicleidname = menu.get_value(vehicleidnameToggle)
speedToggle = menu.toggle(ESP, "showSpeed", {}, "", function(on)
	showSpeed = on
end, showSpeed)
showSpeed = menu.get_value(speedToggle)

function getplayertokick(pid)
	if Russian_Federation then
		if pidlanguage(pid) == "Russian Federation" then
			return pid
		end
	end
	if Ukraine then
		if pidlanguage(pid) == "Ukraine" then
			return pid
		end
	end
	if Poland then
		if pidlanguage(pid) == "Poland" then
			return pid
		end
	end
	if France then
		if pidlanguage(pid) == "France" then
			return pid
		end
	end
	if Italy then
		if pidlanguage(pid) == "Italy" then
			return pid
		end
	end
	if Romania then
		if pidlanguage(pid) == "Romania" then
			return pid
		end
	end
	if Czech_Republic then
		if pidlanguage(pid) == "Czech_Republic" then
			return pid
		end
	end
	if Germany then
		if pidlanguage(pid) == "Germany" then
			return pid
		end
	end
	if Austria then
		if pidlanguage(pid) == "Austria" then
			return pid
		end
	end
	return "false"
end

--[[russentimer = 1
local function russenkick(pid)
	if kickrussen then
		if not util.is_session_transition_active() then
			local pidtokick = getplayertokick(pid)
			if pidtokick == "false" then
			else
				if PlayerisFriend(pidtokick) then
				else
					local playername = players.get_name(pidtokick)
					menu.trigger_commands("kick".. playername)
					menu.trigger_commands("kick".. playername)
					--util.toast(playername .."test2", TOAST_ALL)
					repeat
						util.yield()
						russentimer += 1
					until (players.exists(pidtokick) == false) or (russentimer == 3000)
					russentimer = 1
					util.toast(playername.. " wurde gekickt grund: Russe ", TOAST_ALL)
				end
			end
		end
	end
end

players.on_join(russenkick)]]

menu.toggle(leanderauswahl, "Russian Federation", {}, "", function(on_toggle)
	if on_toggle then
		Russian_Federation = true
	else 
		Russian_Federation = false
	end
end)
menu.toggle(leanderauswahl, "Ukraine", {}, "", function(on_toggle)
	if on_toggle then
		Ukraine = true
	else 
		Ukraine = false
	end
end)
menu.toggle(leanderauswahl, "Poland", {}, "", function(on_toggle)
	if on_toggle then
		Poland = true
	else 
		Poland = false
	end
end)
menu.toggle(leanderauswahl, "France", {}, "", function(on_toggle)
	if on_toggle then
		France = true
	else 
		France = false
	end
end)
menu.toggle(leanderauswahl, "Italy", {}, "", function(on_toggle)
	if on_toggle then
		Italy = true
	else 
		Italy = false
	end
end)
menu.toggle(leanderauswahl, "Romania", {}, "", function(on_toggle)
	if on_toggle then
		Romania = true
	else 
		Romania = false
	end
end)
menu.toggle(leanderauswahl, "Czech Republic", {}, "", function(on_toggle)
	if on_toggle then
		Czech_Republic = true
	else 
		Czech_Republic = false
	end
end)
menu.toggle(leanderauswahl, "Germany", {}, "", function(on_toggle)
	if on_toggle then
		Germany = true
	else 
		Germany = false
	end
end)
menu.toggle(leanderauswahl, "Austria", {}, "", function(on_toggle)
	if on_toggle then
		Austria = true
	else 
		Austria = false
	end
end)

menu.toggle(anti_laender_zeug, "Kick Länder", {}, "kickt Länder die nachjoinen", function(on_toggle)
	if on_toggle then
		kickrussen = true
	else 
		kickrussen = false
	end
end)

menu.action(anti_laender_zeug, "Länder aus lobby kicken", {}, "kickt aus deiner lobby jeden der ausgewählten länder", function()
	if (not Czech_Republic) and (not Romania) and (not Italy) and (not France) and (not Poland) and (not Ukraine) and (not Russian_Federation) and (not Germany)and (not Austria) then
		util.toast("keine länder ausgewählt")
		goto end
	end
	for players.list(false, false, true) as pid do
		local pidtokick = getplayertokick(pid)
		if pidtokick == "false" then
		else
			if PlayerisFriend(pidtokick) then
			else
				playername = players.get_name(pidtokick)
				menu.trigger_commands("kick".. playername)
				menu.trigger_commands("kick".. playername)
				util.toast(playername.. " wird gekickt grund: einer der ausgewählten länder", TOAST_ALL)
			end
		end
	end
	::end::
end)

function loadleanguasplayers(pid, language)
	local wascreated = false
	for _, commandref in pairs(menu.get_children(anti_laender_zeug)) do
		if _ > 5 then
			if string.contains(menu.get_menu_name(commandref), language) then
				menu.attach_after(commandref,menu.action(menu.shadow_root(), players.get_name(pid).."   ("..language..")", {}, "Drauf drücken zum kicken", function()
					local pid = pid
					menu.trigger_commands("kick"..players.get_name(pid))
					for _, commandref in pairs(menu.get_children(anti_laender_zeug)) do
						if _ > 5 then
							if string.contains(menu.get_menu_name(commandref), players.get_name(pid)) then
								menu.delete(commandref)
							end
						end
					end
				end))
				wascreated = true
				break
			end
		end
	end
	if not wascreated then
	menu.action(anti_laender_zeug, players.get_name(pid).."   ("..language..")", {}, "Drauf drücken zum kicken", function()
		local pid = pid
		menu.trigger_commands("kick"..players.get_name(pid))
		for _, commandref in pairs(menu.get_children(anti_laender_zeug)) do
			if _ > 5 then
				if string.contains(menu.get_menu_name(commandref), players.get_name(pid)) then
					menu.delete(commandref)
				end
			end
		end
	end)
	end
end

menu.action(anti_laender_zeug, "ausgewählte länder in der lobby", {}, "sagt wie viele spieler von den ausgewählten ländern in der lobby sind", function()
	local russencounter, ukrainecounter, polandcounter, francecounter, italycounter, romaniacounter, czechcounter, germanycoutner, Austriacoutner = 0, 0, 0, 0, 0, 0, 0, 0, 0
	local textline = ""
	local notselectet = false
	local hostpid = players.get_host()
	for _, commandref in pairs(menu.get_children(anti_laender_zeug)) do
		if _ > 5 then
			menu.delete(commandref)
		end
	end
	for players.list(false, false, true) as pid do
			if Russian_Federation and pidlanguage(pid) == "Russian Federation" then
				russencounter += 1
				loadleanguasplayers(pid, "Russian")
			end
			if Ukraine and pidlanguage(pid) == "Ukraine" then
				ukrainecounter += 1
				loadleanguasplayers(pid, "Ukraine")
			end
			if Poland and pidlanguage(pid) == "Poland" then
				polandcounter += 1
				loadleanguasplayers(pid, "Poland")
			end
			if France and pidlanguage(pid) == "France" then
				francecounter += 1
				loadleanguasplayers(pid, "France")
			end
			if Italy and pidlanguage(pid) == "Italy" then
				italycounter += 1
				loadleanguasplayers(pid, "Italy")
			end
			if Romania and pidlanguage(pid) == "Romania" then
				romaniacounter += 1
				loadleanguasplayers(pid, "Romania")
			end
			if Czech_Republic and pidlanguage(pid) == "Czech_Republic" then
				czechcounter += 1
				loadleanguasplayers(pid, "Czech_Republic")
			end
			if Germany and pidlanguage(pid) == "Germany" then
				germanycoutner += 1
				loadleanguasplayers(pid, "Germany")
			end
			if Austria and pidlanguage(pid) == "Austria" then
				Austriacoutner += 1
				loadleanguasplayers(pid, "Austria")
			end
	end
	if (not Czech_Republic) and (not Romania) and (not Italy) and (not France) and (not Poland) and (not Ukraine) and (not Russian_Federation) and (not Germany)and (not Austria) then
		notselectet = true
		util.toast("keine länder ausgewählt")
	end
	if Russian_Federation then
		textline = "\n" ..tostring(russencounter).. " Russian"
	end
	if Ukraine then
		textline = textline.. "\n" ..tostring(ukrainecounter).. " Ukraine"
	end
	if Poland then
		textline = textline.. "\n" ..tostring(polandcounter).. " Poland"
	end
	if France then
		textline = textline.. "\n" ..tostring(francecounter).. " France"
	end
	if Italy then
		textline = textline.. "\n" ..tostring(italycounter).. " Italy"
	end
	if Romania then
		textline = textline.. "\n" ..tostring(romaniacounter).. " Romania"
	end
	if Czech_Republic then
		textline = textline.. "\n" ..tostring(czechcounter).. " Czech_Republic"
	end
	if Germany then
		textline = textline.. "\n" ..tostring(germanycoutner).. " Germany"
	end
	if Austria then
		textline = textline.. "\n" ..tostring(Austriacoutner).. " Austria"
	end
	if textline != "" then
		textline = string.replace(textline, "\n", "", 1)
		util.toast(textline)
	end
end)

menu.divider(anti_laender_zeug, "Players")

timer6 = 1
function kickhosttoken(pid)
	if kickhosttokenspoof then
	if not util.is_session_transition_active() then
		util.yield(5)
		local hostqueue = players.get_host_queue_position(pid)
		if hostkickfriends then
			local pidname = players.get_name(pid)
			--util.toast(pidname.. " test 2 ".. hostqueue)
			timer6 = 1
			if hostqueue == 1 then
				if players.is_marked_as_modder(pid) then
					menu.trigger_commands("kick ".. pidname)
					menu.trigger_commands("kick ".. pidname)
					util.toast(pidname.. " wurde gekicked Grund: Host Token Spoof", TOAST_ALL)
				end
			end
		else
			if not PlayerisFriend(pid) then
				local pidname = players.get_name(pid)
				--util.toast(pidname.. " test 2 ".. hostqueue)
				timer6 = 1
				if hostqueue == 1 then
					if players.is_marked_as_modder(pid) then
						menu.trigger_commands("kick ".. pidname)
						menu.trigger_commands("kick ".. pidname)
						menu.trigger_commands("kick ".. pidname)
						menu.trigger_commands("kick ".. pidname)
						menu.trigger_commands("kick ".. pidname)
						util.toast(pidname.. " wurde gekicked Grund: Host Token Spoof", TOAST_ALL)
					end
				end
			end
		end
	end
	end
end

players.on_join(kickhosttoken)
players.on_join(playerjoinmassge)

local vehicletablefotactions = {}
function sortKeys(a, b)
	local ta, tb = type(a), type(b)
 
 
	if ta == tb and (ta == 'string' or ta == 'number') then
	   return (a) < (b)
	end
 
	local dta = defaultTypeOrders[ta] or 100
	local dtb = defaultTypeOrders[tb] or 100
 
 
	return dta == dtb and ta < tb or dta < dtb
 end

 function vehicle_spawn_list(root)
    local general_list = root
    local all_vehicles = util.get_vehicles()

    local vehicles = util.get_vehicles()
    table.sort(all_vehicles, function(a, b)
        if a.class != b.class then
            return lang.get_string(a.class) < lang.get_string(b.class)
        end
        return a.name < b.name
    end)
    
    local current_class
    local current_class_list
    for all_vehicles as vehicle do
        if current_class != vehicle.class then
            current_class = vehicle.class
            current_class_list = general_list:list(vehicle.class)
        end

		--(util.get_label_text(vehicle.name)
        local vehicle_name = util.get_label_text(vehicle.name)
        if vehicle_name == "NULL" then
			vehicle_name = getmodelnamebyhash(util.joaat(vehicle.name))
            --continue
       	end
		local vehhash1 = util.joaat(vehicle.name)

        local action = current_class_list:toggle(vehicle_name, {"antivehicle"..vehhash1}, "", function(on_toggle)
			local vehname = vehicle.name
			local realvehname = util.get_label_text(vehname)
			local vehhash = util.joaat(vehicle.name)
			if on_toggle then
				local vehhash = menu.action(vehiclesactivate,realvehname, {"antivehicleactivate"..vehhash}, "drück einfach drauf wenn du es raus nehmen willst", function()
					menu.trigger_commands("antivehicle"..vehhash)
				end)
				table.insert(vehicletablefotactions, vehname)
			else
				if menu.is_ref_valid(menu.ref_by_command_name("antivehicleactivate"..vehhash)) then
					menu.delete(menu.ref_by_command_name("antivehicleactivate"..vehhash))
				end
				for a, vehhashtable in ipairs(vehicletablefotactions) do
					if vehhashtable == vehname then
						table.remove(vehicletablefotactions, a)
					end
				end
			end
        end)
    end
end

antiactionvehicles = menu.list(antivehicleaction, "vehicles auswahl", {}, "commands einfach ignorieren sind nur eine hilfe für mich")
vehiclesactivate = menu.list(antiactionvehicles, "aktivierte vehicle", {}, "")
antivehiclesettings = menu.list(antivehicleaction, "Settings", {}, "")

local maxDistanceantiaction = 1000
local antiactionfriends, antiactionnotify, antiactionsearchclear = false, true, true

maxDistSliderantiaction = menu.slider(antivehiclesettings, "Dist", {"setactiondist"}, "random fahrzeuge können erst von dir ab ~ 800 gesehen werden\nfahrzeuge wie z.b. oppressor MKII wird auf der karte angezeigt als besonderes fahrzeug das geht von überall (meistens)", 10, 10000, maxDistanceantiaction, 10, function(val)
	maxDistanceantiaction = val
end)
maxDistanceantiaction = menu.get_value(maxDistSliderantiaction)
friendsToggle = menu.toggle(antivehiclesettings, "Freunde auch", {}, "", function(on)
	antiactionfriends = on
end, antiactionfriends)
antiactionfriends = menu.get_value(friendsToggle)
notifyactionToggle = menu.toggle(antivehiclesettings, "Notify bekommen", {}, "", function(on)
	antiactionnotify = on
end, antiactionnotify)
antiactionnotify = menu.get_value(notifyactionToggle)

--[[menu.text_input(antiactionvehicles, "addveh", {"addtoantiveh"}, "WICHITG!!!!!!\ndort muss der id name vom auto rein.\num zu schauen wie der id name ist geh zum spawn menu von stand und gib das fahrzeug ein was du willst dann steht dort als befehl der id name\nich habe bei meinem esp ein anzeige gemacht wo man sehen kann was der name ist (id name)", function(input)
	local hash = util.joaat(input)
	for util.get_vehicles() as vehicles do
		local hashveh = util.joaat(vehicles.name)
		if hash == hashveh then
			if menu.is_ref_valid(menu.ref_by_command_name("antivehicle"..hash)) then
				menu.trigger_commands("antivehicle"..hash.. " on")
				util.toast(getmodelnamebyhash(hash).. " wurde zur liste hinzugefügt")
			else
				util.toast("["..input.. "] gibt es nicht in dieser liste")
			end
		end
	end
	menu.set_value(menu.ref_by_command_name("addtoantiveh"), "")
end)]]

local searchvehciletable = {}
function clearsearchlist()
	for searchvehciletable as vehicle do
		local hash = util.joaat(vehicle)
		local valid = menu.is_ref_valid(antivehactiontablelist[hash])
			if valid then
				--menu.delete(menu.ref_by_command_name("antivehiclesearchactivate"..hash))
				menu.delete(antivehactiontablelist[hash])
				menu.collect_garbage()
				--util.yield()
			end
	end
	searchvehciletable = {}
end

antivehiclessearch = menu.list(antiactionvehicles, "Search", {}, "")

menu.divider(antiactionvehicles, "VEHICLE")

searchclreaactionToggle = menu.toggle(antivehiclessearch, "Auto clear search", {}, "", function(on)
	antiactionsearchclear = on
end, antiactionsearchclear)
antiactionsearchclear = menu.get_value(searchclreaactionToggle)

menu.action(antivehiclessearch, "Clear list", {}, "", function()
	clearsearchlist()
	--util.toast(menu.get_active_list_cursor_text(true, true))
	stringtoread = string.replace(menu.get_active_list_cursor_text(true, true), "2/", "")
	if tonumber(stringtoread) > 3 then
		for _, ref in pairs(menu.get_children(antivehiclessearch)) do
			if _ > 3 then
				menu.delete(ref)
			end
		end
	end
end)
searchforvehicleantiveh = menu.text_input(antivehiclessearch, "Search", {"searchofvehicles"}, "such nicht während es gerade die aktuelle suche läd = mega läg vlt auch fehler", function(input)
	if antiactionsearchclear then
		clearsearchlist()
	end
	if input == "" then
		goto end
	end
	for util.get_vehicles() as vehicle do
		local hash = util.joaat(vehicle.name)
		local vehiclename =	getmodelnamebyhash(hash)
		local stringsetting = vehiclename.. " ".. vehicle.name
		stringsetting = stringsetting:lower()
		input = input:lower()
		if string.match(stringsetting, input) then --or string.match(vehicle.name, input) then
			if table.contains(searchvehciletable, vehicle.name) then
				goto dontcreate
			end
			table.insert(searchvehciletable, vehicle.name)
			antivehactiontablelist[hash] = menu.action(antivehiclessearch,vehiclename .."  [".. vehicle.name.."]" , {"antivehiclesearchactivate"..hash}, "drück einfach drauf", function()
				local hash1 = hash
				local vehiclena = vehiclename
					local getvalue = menu.get_value(menu.ref_by_command_name("antivehicle"..hash))
				if getvalue then
					menu.trigger_commands("antivehicle"..hash1.. " off")
					util.toast(vehiclena.." Wurde aus liste entfernt")
				else
					menu.trigger_commands("antivehicle"..hash1.. " on")
					util.toast(vehiclena.." Wurde zur liste hinzugefügt")
				end
			end)
		end
		::dontcreate::
	end
	::end::
	menu.set_help_text(searchforvehicleantiveh, "such nicht während es gerade die aktuelle suche läd = mega läg vlt auch fehler\nLastInput: "..input)
	menu.set_value(menu.ref_by_command_name("searchofvehicles"), "")
end)

menu.toggle_loop(antivehicleaction, "kick of vehicle", {}, "dadurch kann er das fahrzeug meistens nicht mehr benutzen und muss es neu rufen", function()
	local timer = 0
	for players.list(false, true, true) as pid do
		local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
		if IS_PED_IN_ANY_VEHICLE(ped) then
			local vehicle = GET_VEHICLE_PED_IS_USING(ped)
			local vehicleofpid = players.get_vehicle_model(pid)
			local pidname = players.get_name(pid)
			local myPos = players.get_position(players.user())
			local pPos = getPlayerPosition(pid)
	        local dist = myPos:distance(pPos)
			local fullvehname = getmodelnamebyhash(vehicleofpid)
			if PlayerisFriend(pid) and not antiactionfriends then
				goto continue
			end
			--local modelhash = entities.get_model_hash(vehicle)
			if vehicletablefotactions != {} and vehicleofpid != 0 then
				for vehicletablefotactions as vehname do
					local hash = util.joaat(vehname)
					if hash == vehicleofpid then
						if dist < maxDistanceantiaction then
							SET_VEHICLE_EXCLUSIVE_DRIVER(vehicle, players.user_ped(), 0)
							repeat
								util.yield()
								timer += 1
								vehicleofpid = players.get_vehicle_model(pid)
							until vehicleofpid == 0 or timer == 200
							if timer == 200 then
								if antiactionnotify then
									util.toast(pidname.."  Konnte ihn nicht aus dem fahrzeug kicken")
								end
							else
								if antiactionnotify then
									util.toast(pidname.. " wurde aus dem ".. fullvehname .." gekickt")
								end
							end
							timer = 0
						end
					end
				end
			end
		end
		::continue::
	end
end)
menu.toggle_loop(antivehicleaction, "kick of vehicle V2", {}, "benutzt stand sein player vehicle kick\nwürde ich nicht so empfehlen spamt dann halt gut benachrichtigungen", function()
	local timer = 0
	for players.list(false, true, true) as pid do
		local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
		if IS_PED_IN_ANY_VEHICLE(ped) then
			local vehicle = GET_VEHICLE_PED_IS_USING(ped)
			local vehicleofpid = players.get_vehicle_model(pid)
			local pidname = players.get_name(pid)
			local myPos = players.get_position(players.user())
			local pPos = getPlayerPosition(pid)
	        local dist = myPos:distance(pPos)
			local fullvehname = getmodelnamebyhash(vehicleofpid)
			if PlayerisFriend(pid) and not antiactionfriends then
				goto continue
			end
			--local modelhash = entities.get_model_hash(vehicle)
			if vehicletablefotactions != {} and vehicleofpid != 0 then
				for vehicletablefotactions as vehname do
					local hash = util.joaat(vehname)
					if hash == vehicleofpid then
						if dist < maxDistanceantiaction then
							menu.trigger_commands("vehkick"..pidname)
							repeat
								util.yield()
								timer += 1
								vehicleofpid = players.get_vehicle_model(pid)
							until vehicleofpid == 0 or timer == 200
							if timer == 200 then
								if antiactionnotify then
									util.toast(pidname.."  Konnte ihn nicht aus dem fahrzeug kicken")
								end
							else
								if antiactionnotify then
									util.toast(pidname.. " wurde aus dem ".. fullvehname .." gekickt")
								end
							end
							timer = 0
						end
					end
				end
			end
		end
		::continue::
	end
end)
menu.toggle_loop(antivehicleaction, "EMP vehicle", {}, "", function()
	local timer = 0
	for players.list(false, true, true) as pid do
		local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
		if IS_PED_IN_ANY_VEHICLE(ped) then
			local vehicle = GET_VEHICLE_PED_IS_USING(ped)
			local vehicleofpid = players.get_vehicle_model(pid)
			local pidname = players.get_name(pid)
			local disvehbyemp = GET_IS_VEHICLE_DISABLED_BY_EMP(vehicle)
			local myPos = players.get_position(players.user())
			local pPos = getPlayerPosition(pid)
	        local dist = myPos:distance(pPos)
			local fullvehname = getmodelnamebyhash(vehicleofpid)
			if PlayerisFriend(pid) and not antiactionfriends then
				goto continue
			end
			if disvehbyemp then
				goto continue
			end
			--local modelhash = entities.get_model_hash(vehicle)
			if vehicletablefotactions != {} and vehicleofpid != 0 then
				for vehicletablefotactions as vehname do
					local hash = util.joaat(vehname)
					if hash == vehicleofpid then
						if dist < maxDistanceantiaction then
							--menu.trigger_commands("delveh"..pidname)
							if getcontrole(vehicle) then
								repeat
									util.yield()
									timer += 1
									menu.trigger_commands("empveh"..pidname)
									disvehbyemp = GET_IS_VEHICLE_DISABLED_BY_EMP(vehicle)
								until disvehbyemp or timer == 150
								if timer == 150 then
									if antiactionnotify then
										util.toast(pidname.."  Sein fahrzeug konnte nicht mit EMP versetzt werden")
									end
								elseif disvehbyemp then
									if antiactionnotify then
										util.toast(pidname.. "  wurde sein ".. fullvehname .." mit EMP versetzt")
									end
								end
								timer = 0
							else
								if antiactionnotify then
									util.toast(pidname.. "  konnte keine kontrolle bekommen")
								end
							end
						end
					end
				end
			end
		end
		::continue::
	end
end)
menu.toggle_loop(antivehicleaction, "Delete vehicle", {}, "", function()
	local timer = 0
	for players.list(false, true, true) as pid do
		local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
		if IS_PED_IN_ANY_VEHICLE(ped) then
			local vehicle = GET_VEHICLE_PED_IS_USING(ped)
			local vehicleofpid = players.get_vehicle_model(pid)
			local pidname = players.get_name(pid)
			local myPos = players.get_position(players.user())
			local pPos = getPlayerPosition(pid)
	        local dist = myPos:distance(pPos)
			local fullvehname = getmodelnamebyhash(vehicleofpid)
			if PlayerisFriend(pid) and not antiactionfriends then
				goto continue
			end
			--local modelhash = entities.get_model_hash(vehicle)
			if vehicletablefotactions != {} and vehicleofpid != 0 then
				for vehicletablefotactions as vehname do
					local hash = util.joaat(vehname)
					if hash == vehicleofpid then
						if dist < maxDistanceantiaction then
							--menu.trigger_commands("delveh"..pidname)
							if getcontrole(vehicle) then
								entities.delete(vehicle)
								repeat
									util.yield()
									timer += 1
									vehicleofpid = players.get_vehicle_model(pid)
								until vehicleofpid == 0 or timer == 200 or (not isinveh)
								if timer == 200 then
									if antiactionnotify then
										util.toast(pidname.."  Sein fahrzeug konnte nicht gelöscht werden")
									end
								else
									if antiactionnotify then
										util.toast(pidname.. "  wurde sein ".. fullvehname .." gelöscht")
									end
								end
								timer = 0
							else
								if antiactionnotify then
									util.toast(pidname.. "  konnte keine kontrolle bekommen")
								end
							end
						end
					end
				end
			end
		end
		::continue::
	end
end)
menu.toggle_loop(antivehicleaction, "Explode vehicle", {}, "", function()
	local timer = 0
	for players.list(false, true, true) as pid do
		local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
		if IS_PED_IN_ANY_VEHICLE(ped) then
			local vehicle = GET_VEHICLE_PED_IS_USING(ped)
			local vehicleofpid = players.get_vehicle_model(pid)
			local health = GET_VEHICLE_ENGINE_HEALTH(vehicle)
			local pidname = players.get_name(pid)
			local myPos = players.get_position(players.user())
			local pidtags = players.get_tags_string(pid)
			local pPos = getPlayerPosition(pid)
	        local dist = myPos:distance(pPos)
			local fullvehname = getmodelnamebyhash(vehicleofpid)
			if PlayerisFriend(pid) and not antiactionfriends then
				goto continue
			end
			if players.is_godmode(pid) then
				goto continue
			end
			--local modelhash = entities.get_model_hash(vehicle)
			if vehicletablefotactions != {} and vehicleofpid != 0 then
				for vehicletablefotactions as vehname do
					local hash = util.joaat(vehname)
					if hash == vehicleofpid then
						if dist < maxDistanceantiaction then
							if GET_ENTITY_CAN_BE_DAMAGED(vehicle) then
								if health > 0 and not IS_PED_DEAD_OR_DYING(ped, 1) then
									repeat
										util.yield()
										timer += 1
										health = GET_VEHICLE_ENGINE_HEALTH(vehicle)
										pPos = getPlayerPosition(pid)
										ADD_EXPLOSION(pPos.x, pPos.y, pPos.z, 6, 100, true, false, 0.0, false)
									until (health < 0) or (timer > 200)
									if timer > 200 then
										if antiactionnotify then
											util.toast(pidname.."  Konnte ihn nicht Töten/fahrzeug zerstören")
										end
									elseif health < 0 then
										if antiactionnotify then
											util.toast(pidname.. " Sein ".. fullvehname .." ist zerstört")
										end
									end
									timer = 0
								end
							end
						end
					end
				end
			end
		end
		::continue::
	end
end)




local LangKeys = {}
local LangName = {}
local LangIndexes = {}
local LangLookupByName = {}
local LangLookupByKey = {}
local PlayerSpooflist = {}
local PlayerSpoof = {}

for i=1,#tables.Languages do
	local Language = tables.Languages[i]
	LangKeys[i] = Language.Name
	LangName[i] = Language.Name
	LangIndexes[Language.Key] = i
	LangLookupByName[Language.Name] = Language.Key
	LangLookupByKey[Language.Key] = Language.Name
end

table.sort(LangKeys)

function encode(text)
	return string.gsub(text, "%s", "+")
end

local translationonoff = false

menu.toggle(translator, "Toggle Translator", {}, "", function(value)
	translationonoff = value 
end)

targetlangmenu = menu.list_select(translator, "Target Language", {}, "You need to click to aply change", LangName, 24, function(s)
	targetlang = LangLookupByName[LangKeys[s]]
end)


tradlocamenu = menu.list_select(translator, "Location of Traducted Message", {}, "You need to click to aply change", {"Team Chat not networked", "Team Chat networked", "Global Chat not networked", "Global Chat networked", "Notification"}, 5, function(s)
	Tradloca = s
end)

traductself = true
menu.toggle(translator, "Traduct Yourself", {}, "", function(on)
	traductself = on	
end, true)
traductsamelang = false
menu.toggle(translator, "Traduct even if the language is the same as the desired one", {}, "might not work correctly because google is dumb", function(on)
	traductsamelang = on	
end)

traductmymessage = menu.list(translator, "Send Traducted message")
finallangmenu = menu.list_select(traductmymessage, "Final Language", {"finallang"}, "Final Languge of your message.																	  You need to click to aply change", LangName, 1, function(s)
   targetlangmessagesend = LangLookupByName[LangKeys[s]]
end)

menu.action(traductmymessage, "Send Message", {"Sendmessage"}, "Input the text For your message", function(on_click)
    util.toast("Please input your message")
    menu.show_command_box("Sendmessage ")
end, function(on_command)
    mytext = on_command
    async_http.init("translate.googleapis.com", "/translate_a/single?client=gtx&sl=auto&tl="..targetlangmessagesend.."&dt=t&q="..encode(mytext), function(Sucess)
		if Sucess ~= "" then
			translation, original, sourceLang = Sucess:match("^%[%[%[\"(.-)\",\"(.-)\",.-,.-,.-]],.-,\"(.-)\"")
			for _, pId in ipairs(players.list()) do
				chat.send_targeted_message(pId, players.user(),string.gsub(translation, "%+", " "), false)
			end
		end
	end)
    async_http.dispatch()
end)
botsend = false
ran = 0
chat.on_message(function(packet_sender, message_sender, text, team_chat)
	if not translationonoff then
		return
	end
	if not botsend then
		if not traductself and (packet_sender == players.user()) then
		else
		async_http.init("translate.googleapis.com", "/translate_a/single?client=gtx&sl=auto&tl="..targetlang.."&dt=t&q="..encode(text), function(Sucess)
			local textline = ""
			if Sucess ~= "" then
				translation, original, sourceLang = Sucess:match("^%[%[%[\"(.-)\",\"(.-)\",.-,.-,.-]],.-,\"(.-)\"")
				if not traductsamelang and (string.sub(sourceLang,0,2) == "en") or (string.sub(sourceLang,0,2) == "de") then
					goto end
				end
				if not traductsamelang and (sourceLang == targetlang) then
					goto end
				end
				if string.match(string.gsub(translation, "%+", " "), original) then
					goto end
				end
				if LangLookupByKey[string.sub(sourceLang,0,2)] != nil and (Tradloca == 5) then
					textline = LangLookupByKey[string.sub(sourceLang,0,2)].." TO "..LangLookupByKey[targetlang].."\n"
				end
				textline = textline.. players.get_name(packet_sender).." : "..string.gsub(translation, "%+", " ")
					if (Tradloca == 1) then	
						chat.send_message(textline, true, true, false)
					end if (Tradloca == 2) then
						botsend = true
						chat.send_message(textline, true, true, true)
					end if (Tradloca == 3) then
						chat.send_message(textline, false, true, false)
					end if (Tradloca == 4) then
						botsend = true
						chat.send_message(textline, false, true, true)
					end if (Tradloca == 5) then
						util.toast(textline, TOAST_ALL)
					end
				::end::
			end
		end)
		async_http.dispatch()
		end
	end
	botsend = false
end)

run = 0
while run<10 do 
	Tradloca = menu.get_value(tradlocamenu)
	targetlangmessagesend = LangLookupByName[LangKeys[menu.get_value(finallangmenu)]]
	targetlang = LangLookupByName[LangKeys[menu.get_value(targetlangmenu)]]
	util.yield()
	run = run+1
end



menu.action(player_zeug, "Get Host", {}, "kickt die leute die vor dir host werden\njoa geht irgendwie geht halt nicht direkt",function()
	local phostpos = players.get_host_queue_position(players.user())
	local textline = ""
	for players.list(false, true, true) as pid do
		local hostposition = players.get_host_queue_position(pid)
		if players.get_host() != pid then
			if hostposition < phostpos then
				if players.exists(pid) then
					textline = textline.. "\n" ..players.get_name(pid).. "  :kicked"
					menu.trigger_commands("kick"..players.get_name(pid))
				end
			end
		end
	end
	if players.get_host() != players.user() then
		menu.trigger_commands("kick"..players.get_name(players.get_host()))
	end
	if textline:len() > 0 then
		textline = string.replace(textline, "\n", "", 1)
		util.toast(textline)
	end
end)

menu.action(player_zeug, "amount to get host", {}, "wie viele leute gekickt werden und ob ein freund dazwischen ist",function()
	local phostpos = players.get_host_queue_position(players.user())
	local numberofplayers = 0
	local isfriend = false
	for players.list(false, true, true) as pid do
		local hostposition = players.get_host_queue_position(pid)
		if hostposition < phostpos then
			numberofplayers += 1
			if PlayerisFriend(pid) then
				isfriend = true
			end
		end
	end
	if isfriend then
		util.toast(numberofplayers.. " Freund ist darunter")
	else
		util.toast(numberofplayers)
	end
end)

local playerlisttable = {}
local playersactiontable = {}
local playersactionexcludeselectedtable = {}

--[[menu.action(customselection, "toast player in list", {}, "", function(on_toggle)
	for playersactiontable as pid do
		util.toast(players.get_name(pid))
	end
end)]]

excludeselectedtoggle = menu.toggle(customselection, "Exclude selected", {}, "dabei wirst du automatisch nicht mit gezählt", function(on_toggle)
	if on_toggle then
		excludeselected1 = menu.attach_after(dividercustom1,menu.action(menu.shadow_root(), "Exclude Selected ON", {}, "",function()
			menu.set_value(excludeselectedtoggle, false)
		end))
		excludeselected2 = menu.attach_after(dividercustom2,menu.action(menu.shadow_root(), "Exclude Selected ON", {}, "",function()
			menu.set_value(excludeselectedtoggle, false)
		end))
		excludeselected3 = menu.attach_after(dividercustom3,menu.action(menu.shadow_root(), "Exclude Selected ON", {}, "",function()
			menu.set_value(excludeselectedtoggle, false)
		end))
		excludeselected4 = menu.attach_after(dividercustom4,menu.action(menu.shadow_root(), "Exclude Selected ON", {}, "",function()
			menu.set_value(excludeselectedtoggle, false)
		end))
		excludeselected5 = menu.attach_after(dividercustom5,menu.action(menu.shadow_root(), "Exclude Selected ON", {}, "",function()
			menu.set_value(excludeselectedtoggle, false)
		end))
		excludeselected = true
	else
		menu.delete(excludeselected1)
		menu.delete(excludeselected2)
		menu.delete(excludeselected3)
		menu.delete(excludeselected4)
		menu.delete(excludeselected5)
		excludeselected = false
	end
end)

actionlistcustomselection = menu.list(customselection, "Actions", {}, "")
actionlistcustomselectionteleport = menu.list(actionlistcustomselection, "TP", {}, "")
actionlistcustomselectionfriendly = menu.list(actionlistcustomselection, "Friendly", {}, "")
actionlistcustomselectiontrolling = menu.list(actionlistcustomselection, "Trolling", {}, "")
actionlistcustomselectionkickcrash = menu.list(actionlistcustomselection, "Kick / crash", {}, "")

-- Teleport things custom selection
menu.action(actionlistcustomselectionteleport, "Teleport to me", {}, "teils möglich sehr bugy", function()
	local textline = "Teleport for:"
	for playersactiontable as pid do
		textline = textline.. "\n".. players.get_name(pid)
		menu.trigger_commands("summon" .. players.get_name(pid))
		util.yield(1000)
		repeat
			util.yield()
			spectateplayer = players.get_spectate_target(players.user())
		until spectateplayer == -1
	end
	util.toast(textline)
end)
menu.action(actionlistcustomselectionteleport, "Teleport to me Apatment", {}, "", function()
	local textline = "Teleport (apartment) for:"
	for playersactiontable as pid do
		textline = textline.. "\n".. players.get_name(pid)
		menu.trigger_commands("aptme" .. players.get_name(pid))
		util.yield(300)
	end
	util.toast(textline)
end)

menu.toggle(actionlistcustomselectionteleport, "Apartments anzeigen", {}, "Die werden mit Zahlen angezeigt", function(on_toggle)
	if on_toggle then
		menu.trigger_commands("showapartments " .. "on")
	else
		menu.trigger_commands("showapartments " .. "off")
	end
end)


-- Friendly things custom selection
menu.action(actionlistcustomselectionfriendly, "Auto heal ON", {}, "", function()
	local textline = "Auto heal ON for:"
	for playersactiontable as pid do
		textline = textline.. "\n".. players.get_name(pid)
		menu.trigger_commands("autoheal" .. players.get_name(pid) .. " on")
		util.yield()
	end
	util.toast(textline)
end)
menu.action(actionlistcustomselectionfriendly, "Auto heal OFF", {}, "", function()
	local textline = "Auto heal OFF for:"
	for playersactiontable as pid do
		textline = textline.. "\n".. players.get_name(pid)
		menu.trigger_commands("autoheal" .. players.get_name(pid) .. " off")
		util.yield()
	end
	util.toast(textline)
end)
menu.action(actionlistcustomselectionfriendly, "Never wanted ON", {}, "", function()
	local textline = "Never wanted ON for:"
	for playersactiontable as pid do
		textline = textline.. "\n".. players.get_name(pid)
		menu.trigger_commands("bail" .. players.get_name(pid) .. " on")
		util.yield()
	end
	util.toast(textline)
end)
menu.action(actionlistcustomselectionfriendly, "Never wanted OFF", {}, "", function()
	local textline = "Never wanted OFF for:"
	for playersactiontable as pid do
		textline = textline.. "\n".. players.get_name(pid)
		menu.trigger_commands("bail" .. players.get_name(pid) .. " off")
		util.yield()
	end
	util.toast(textline)
end)
menu.action(actionlistcustomselectionfriendly, "OTR ON", {}, "", function()
	local textline = "OTR on for:"
	for playersactiontable as pid do
		textline = textline.. "\n".. players.get_name(pid)
		menu.trigger_commands("giveotr" .. players.get_name(pid) .. " on")
	end
	util.toast(textline)
end)
menu.action(actionlistcustomselectionfriendly, "OTR OFF", {}, "", function()
	local textline = "OTR OFF for:"
	for playersactiontable as pid do
		textline = textline.. "\n".. players.get_name(pid)
		menu.trigger_commands("giveotr" .. players.get_name(pid) .. " off")
		util.yield()
	end
	util.toast(textline)
end)
-- Trolling things custom selection
menu.action(actionlistcustomselectiontrolling, "Vehicle Kick", {}, "", function()
	local textline = "Vehicle kick for:"
	for playersactiontable as pid do
		textline = textline.. "\n".. players.get_name(pid)
		menu.trigger_commands("vehkick" .. players.get_name(pid))
		util.yield()
	end
	util.toast(textline)
end)
menu.action(actionlistcustomselectiontrolling, "Freeze ON", {}, "", function()
	local textline = "Freeze ON for:"
	for playersactiontable as pid do
		textline = textline.. "\n".. players.get_name(pid)
		menu.trigger_commands("freeze" .. players.get_name(pid).. " on")
		util.yield()
	end
	util.toast(textline)
end)
menu.action(actionlistcustomselectiontrolling, "Freeze ON", {}, "", function()
	local textline = "Freeze OFF for:"
	for playersactiontable as pid do
		textline = textline.. "\n".. players.get_name(pid)
		menu.trigger_commands("freeze" .. players.get_name(pid).. " off")
		util.yield()
	end
	util.toast(textline)
end)

-- Kick / Crash things custom selection
menu.action(actionlistcustomselectionkickcrash, "Modder Kicken", {}, "", function()
	local textline = "Modder kick for:"
	for playersactiontable as pid do
		if players.is_marked_as_modder(pid) then
			textline = textline.. "\n".. players.get_name(pid)
			menu.trigger_commands("kick" .. players.get_name(pid))
			util.yield()
		end
	end
	util.toast(textline)
end)
menu.action(actionlistcustomselectionkickcrash, "Kicken", {}, "", function()
	local textline = "Kick for:"
	for playersactiontable as pid do
		textline = textline.. "\n".. players.get_name(pid)
		menu.trigger_commands("kick" .. players.get_name(pid))
		util.yield()
	end
	util.toast(textline)
end)
menu.action(actionlistcustomselectionkickcrash, "Crash", {}, "", function()
	local textline = "Crash for:"
	for playersactiontable as pid do
		textline = textline.. "\n".. players.get_name(pid)
		menu.trigger_commands("crash" .. players.get_name(pid))
		menu.trigger_commands("crash" .. players.get_name(pid))
		menu.trigger_commands("footlettuce" .. players.get_name(pid))
		menu.trigger_commands("footlettuce" .. players.get_name(pid))
		menu.trigger_commands("slaughter" .. players.get_name(pid))
		menu.trigger_commands("slaughter" .. players.get_name(pid))
		menu.trigger_commands("steamroll" .. players.get_name(pid))
		menu.trigger_commands("steamroll" .. players.get_name(pid))
		util.yield()
	end
	util.toast(textline)
end)

dividercustom1 = menu.divider(actionlistcustomselection, "PLAYERS")
dividercustom2 = menu.divider(actionlistcustomselectionteleport, "PLAYERS")
dividercustom3 = menu.divider(actionlistcustomselectionfriendly, "PLAYERS")
dividercustom4 = menu.divider(actionlistcustomselectiontrolling, "PLAYERS")
dividercustom5 = menu.divider(actionlistcustomselectionkickcrash, "PLAYERS")
menu.toggle(customselection, "load players", {}, "die liste wird die ganze zeit aktualisiert also vlt nicht dauer an lassen\nsollte aber nichts passieren wenn man es an lässt", function(on_toggle)
	if on_toggle then
		creatplayerlistincustom = true
		util.create_tick_handler(loadplayerlistcustom)
	else
		creatplayerlistincustom = false
	end
end)
playertable[-1] = menu.divider(customselection, "PLAYERS")

function comma_value(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

function loadplayerlistcustom()
	if not creatplayerlistincustom then
		for i = 0, 32 do
			if playertable[i] != nil then
				if menu.is_ref_valid(playertable[i]) then
					tableremove(playerlisttable, i)
					menu.delete(playertable[i])
					menu.set_menu_name(playertable[-1], "PLAYERS")
				end
			end
		end
		handleplayeractionlist()
		return false
	end
	local numberofplayersinlobby = 0
	for players.list(true,true,true) as pid do
		if players.exists(pid) then
			local textline = "PID: ".. pid
			local orgmemberstext = ""
			local Pname = players.get_name(pid)
			local Pnamewithtags = players.get_name_with_tags(pid)
			local ipdata = get_ip_data(tostring(soup.IpAddr(players.get_connect_ip(pid))))
			textline = textline.. "\nHost queue pos: ".. players.get_host_queue_position(pid)
			if players.get_boss(pid) != -1 then
				textline = textline.. "\nORG Type: ".. getorgtype(players.get_boss(pid))
				textline = textline.. "\nOwner: ".. players.get_name(players.get_boss(pid))
				local orgmemberstable = getorganisationplayers(pid)
				for orgmemberstable as pidorgs do
					if players.get_boss(pid) != pidorgs then
						orgmemberstext = orgmemberstext ..", ".. players.get_name(pidorgs)
					end
				end
				orgmemberstext = string.replace(orgmemberstext, ", ", "" , 1)
				if orgmemberstext:len() > 0 then
					textline = textline.. "\nmembers: ".. orgmemberstext
				end
			end
			if players.get_bounty(pid) != nil then
				textline = textline.. "\nBounty: ".. players.get_bounty(pid)
			end
			numberofplayersinlobby += 1
			textline = textline.. "\n"
			textline = textline.. "\nRank: ".. players.get_rank(pid)
			textline = textline.. "\nMoney: ".. comma_value(players.get_money(pid))
			textline = textline.. "\nWallet: ".. comma_value(players.get_wallet(pid))
			textline = textline.. "\nBank: ".. comma_value(players.get_bank(pid))
			textline = textline.. "\nKD: ".. roundDecimals(players.get_kd(pid), 2)
			textline = textline.. "\n"
			textline = textline.. "\nIP: ".. tostring(soup.IpAddr(players.get_connect_ip(pid)))
			textline = textline.. "\nLand: ".. ipdata.country
			textline = textline.. "\nRegion: ".. ipdata.state
			textline = textline.. "\nStadt: ".. ipdata.city
			if not table.contains(playerlisttable, pid) then
				table.insert(playerlisttable, pid)
				local pidtoatach = getpidtoattach(pid)
				playertable[pid] = menu.attach_after(playertable[pidtoatach] ,menu.toggle(menu.shadow_root(), Pname, {}, textline, function(on_toggle)
				end))
			else
				if menu.is_ref_valid(playertable[pid]) then
					menu.set_menu_name(playertable[pid], Pnamewithtags)
					menu.set_help_text(playertable[pid], textline)
				end
			end
		end
		::end::
	end
	handleplayeractionlist()
	menu.set_menu_name(playertable[-1], "PLAYERS ["..numberofplayersinlobby.."]")
end

function handleplayeractionlist()
	if excludeselected then
		for pid = 0, 32 do
			if playertable[pid] != nil then
				if pid == players.user() then
					tableremove(playersactiontable, pid)
					goto end
				end
				if menu.is_ref_valid(playertable[pid]) then
					if not menu.get_value(playertable[pid]) then
						if not table.contains(playersactiontable, pid) then
							deleteparents_in_custom(pid)
							tableremove(playersactionexcludeselectedtable, pid)
							table.insert(playersactiontable, pid)
						end
					else
						if table.contains(playersactiontable, pid) then
							deleteparents_in_custom(pid)
							tableremove(playersactiontable, pid)
							goto end
						end
						if not table.contains(playersactionexcludeselectedtable, pid) then
							table.insert(playersactionexcludeselectedtable, pid)
							createparents_in_custom(pid, menu.get_help_text(playertable[pid]))
						end
						tableremove(playersactiontable, pid)
					end
				else
					deleteparents_in_custom(pid)
					tableremove(playersactiontable, pid)
					tableremove(playersactionexcludeselectedtable, pid)
				end
			end
			::end::
		end
	else
		for pid = 0, 32 do
			if playertable[pid] != nil then
				if pid == players.user() then
					tableremove(playersactiontable, pid)
					goto end
				end
				if menu.is_ref_valid(playertable[pid]) then
					if menu.get_value(playertable[pid]) then
						if table.contains(playersactionexcludeselectedtable, pid) then
							deleteparents_in_custom(pid)
							tableremove(playersactionexcludeselectedtable, pid)
							goto end
						end
						if not table.contains(playersactiontable, pid) then
							createparents_in_custom(pid, menu.get_help_text(playertable[pid]))
							table.insert(playersactiontable, pid)
						end
					else
						deleteparents_in_custom(pid)
						tableremove(playersactiontable, pid)
						tableremove(playersactionexcludeselectedtable, pid)
					end
				else
					deleteparents_in_custom(pid)
					tableremove(playersactiontable, pid)
					tableremove(playersactionexcludeselectedtable, pid)
				end
			end
			::end::
		end
	end
end

players.on_leave(function(pid)
	if playertable[pid] != nil then
		if menu.is_ref_valid(playertable[pid]) then
			menu.delete(playertable[pid])
			tableremove(playerlisttable, pid)
		end
	end
end)

local fireworktablelist = {}
local fireworktablelistexists = {}

local fireworklist = menu.list(misc, "Firework", {}, "")
local fireworkcolourselect = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 }
ptfnamesel = "scr_indep_firework_starburst"
ptfnamelib = "scr_indep_fireworks"
hashofobj = util.joaat("ind_prop_firework_01")
hashofobjname = "ind_prop_firework_01"
timetowait = 1000

function handlefireworklist()
	if not togglehandlefireowrklist then
		return false
	end
	for fireworktablelistexists as object do
		if fireworkdrawline then
			if DOES_ENTITY_EXIST(object) then
				for i=1, 6 do
					if menu.is_focused(fireworktablelist[object]) or menu.is_focused(fireworktablelist[object..i]) then
						local myPos = players.get_position(players.user())
						local pPos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(object, 0, 0, 0)
						DRAW_LINE(myPos.x, myPos.y, myPos.z, pPos.x, pPos.y, pPos.z, 255, 0, 0, 255)
					end
				end
			end
		end
		if not DOES_ENTITY_EXIST(object) then
			menu.set_value(fireworktablelist[object.. 3], false)
			util.yield(20)
			menu.delete(fireworktablelist[object])
			tableremove(fireworktablelistexists, object)
		end
	end
end

menu.action(fireworklist, "Spawn a Firework", {}, "", function()
	local playeroffset = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +0.5, 0)
	local fireowrkpos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +0.5, +1)
	local Object
	groundofz = get_ground_z(playeroffset)
	v3.setZ(playeroffset, groundofz)
	if withanimationyes then
		request_anim_dict("anim@mp_fireworks")
		TASK_PLAY_ANIM(players.user_ped(), "anim@mp_fireworks", "place_firework_1_rocket", 8.0, 8.0, -1, 0, 0.0, false, false, false)
		util.yield(1000)
		Object = entities.create_object(hashofobj, playeroffset)
		while IS_ENTITY_PLAYING_ANIM(players.user_ped(), "anim@mp_fireworks", "place_firework_1_rocket", 3) do
			util.yield()
			if isanykeypressed() then
				break
			end
		end
		CLEAR_PED_TASKS_IMMEDIATELY(players.user_ped())
	else
		Object = entities.create_object(hashofobj, playeroffset)
	end
	if not fireworksrot then
		PLACE_OBJECT_ON_GROUND_PROPERLY(Object)
	end
	entities.set_can_migrate(Object, false)
	fireworktablelist[Object] = menu.list(fireworklistfirework, hashofobjname, {}, "")
	fireworktablelist[Object.. 1] = menu.action(fireworktablelist[Object], "delete", {}, "", function()
		entities.delete(Object)
	end)
	fireworktablelist[Object.. 2] = menu.action(fireworktablelist[Object], "Firework shoot", {}, "", function()
		local objecte = Object
		local offsetobject = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(objecte, 0, 0, 0)
		if fireworksrandomeffect then
			local effectrandom = math.random( 1,4 )
			menu.set_value(fireworklistselect,effectrandom)
		end
		local rot = GET_ENTITY_ROTATION(objecte, 5)
		Streamptfx(ptfnamelib)
		START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(ptfnamesel, offsetobject.x, offsetobject.y, offsetobject.z,  rot.x, rot.y, rot.z, 1.0, false, false, false, false)
		SET_PARTICLE_FX_NON_LOOPED_COLOUR(fireworkcolourselect.r, fireworkcolourselect.g, fireworkcolourselect.b)
		if fireworksdeleteafteruse then
			util.yield(200)
			entities.delete(objecte)
		end
	end)
	fireworktablelist[Object.. 3] = menu.toggle_loop(fireworktablelist[Object], "Firework shoot loop", {}, "Interval einstellen bei settings\nwird random in eine richtung schießen in die das firework zeigt", function()
		local objecte = Object
		local offsetobject = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(objecte, 0, 0, 0)
		local rot = GET_ENTITY_ROTATION(objecte, 5)
		if fireworksrandomeffect then
			local effectrandom = math.random( 1,4 )
			menu.set_value(fireworklistselect,effectrandom)
		end
		local coordrandom = math.random( -10, 10)
		local coordrandom2 = math.random( -10, 10)
		if coordrandom > 0 then
			rot.x = rot.x + coordrandom
		else
			rot.x = rot.x - coordrandom
		end
		if coordrandom2 > 0 then
			rot.y = rot.y + coordrandom
		else
			rot.y = rot.y - coordrandom
		end
		Streamptfx(ptfnamelib)
		START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(ptfnamesel, offsetobject.x, offsetobject.y, offsetobject.z,  rot.x, rot.y, rot.z, 1.0, false, false, false, false)
		SET_PARTICLE_FX_NON_LOOPED_COLOUR(fireworkcolourselect.r, fireworkcolourselect.g, fireworkcolourselect.b)
		util.yield(timetowait)
	end)
	fireworktablelist[Object.. 4] = menu.toggle(fireworktablelist[Object], "Freeze position", {}, "", function(on_toggle)
		local objecte = Object
		if on_toggle then
			FREEZE_ENTITY_POSITION(objecte, true)
		else
			FREEZE_ENTITY_POSITION(objecte, false)
		end
	end)
	fireworktablelist[Object.. 5] = menu.action(fireworktablelist[Object], "Richtig auf boden stellen", {}, "berügsichtigt den boden und passt es dazu an", function(on_toggle)
		local objecte = Object
		getcontrole(objecte)
		PLACE_OBJECT_ON_GROUND_PROPERLY(objecte)
	end)
	fireworktablelist[Object.. 6] = menu.action(fireworktablelist[Object], "Rotation auf 0 stellen", {}, "damit wird er genau nach oben gucken", function(on_toggle)
		local objecte = Object
		getcontrole(objecte)
		SET_ENTITY_ROTATION(objecte, 0.0, 0.0, 0.0, 5, true)
	end)
	table.insert(fireworktablelistexists, Object)
	util.toast("Spawend Firework")
end)

fireworklistfirework = menu.list(fireworklist, "Firework List", {}, "", function(on_click)
	togglehandlefireowrklist = true
	util.create_tick_handler(handlefireworklist)
end, function(on_back)
	togglehandlefireowrklist = false
end)

fireworkalllist = menu.list(fireworklistfirework, "ALL Fireworks", {}, "")
menu.action(fireworkalllist, "delete", {}, "", function()
	local counteroffirework = 0
	for fireworktablelistexists as Object do
		entities.delete(Object)
		counteroffirework += 1
	end
	util.toast(counteroffirework.. " Fireworks Deleted")
end)
menu.action(fireworkalllist, "Firework Shoot", {}, "", function()
	local counteroffirework = 0
	for fireworktablelistexists as Object do
		local offsetobject = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(Object, 0, 0, 0)
		local rot = GET_ENTITY_ROTATION(Object, 5)
		if fireworksrandomeffect then
			local effectrandom = math.random( 1,4 )
			menu.set_value(fireworklistselect,effectrandom)
		end
		Streamptfx(ptfnamelib)
		START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(ptfnamesel, offsetobject.x, offsetobject.y, offsetobject.z,  rot.x, rot.y, rot.z, 1.0, false, false, false, false)
		SET_PARTICLE_FX_NON_LOOPED_COLOUR(fireworkcolourselect.r, fireworkcolourselect.g, fireworkcolourselect.b)
		counteroffirework += 1
		if fireworksdeleteafteruse then
			util.yield(50)
			entities.delete(Object)
		end
	end
	util.toast(counteroffirework.. " Fireworks Shootet")
end)
menu.toggle_loop(fireworkalllist, "Firework Shoot Loop", {}, "Interval einstellen bei settings\nwird random in eine richtung schießen in die das firework zeigt", function()
	for fireworktablelistexists as Object do
		local offsetobject = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(Object, 0, 0, 0)
		local rot = GET_ENTITY_ROTATION(Object, 5)
		if fireworksrandomeffect then
			local effectrandom = math.random( 1,4 )
			menu.set_value(fireworklistselect,effectrandom)
		end
		--local colour1, colour2, colour3 = math.random( 100,255 ), math.random( 100,255 ), math.random( 100,255 )
		local coordrandom = math.random( -10, 10)
		local coordrandom2 = math.random( -10, 10)
		if coordrandom > 0 then
			rot.x = rot.x + coordrandom
		else
			rot.x = rot.x - coordrandom
		end
		if coordrandom2 > 0 then
			rot.y = rot.y + coordrandom
		else
			rot.y = rot.y - coordrandom
		end
		Streamptfx(ptfnamelib)
		START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(ptfnamesel, offsetobject.x, offsetobject.y, offsetobject.z,  rot.x, rot.y, rot.z, 1.0, false, false, false, false)
		SET_PARTICLE_FX_NON_LOOPED_COLOUR(fireworkcolourselect.r, fireworkcolourselect.g, fireworkcolourselect.b)
		util.yield(math.random( 100,200 ))
	end
	util.yield(timetowait)
end)
menu.toggle(fireworkalllist, "Freeze Position", {}, "", function(on_toggle)
	local counteroffirework = 0
	for fireworktablelistexists as Object do
		getcontrole(Object)
		if on_toggle then
			FREEZE_ENTITY_POSITION(Object, true)
			counteroffirework += 1
		else
			FREEZE_ENTITY_POSITION(Object, false)
			counteroffirework += 1
		end
	end
	if on_toggle then
		util.toast(counteroffirework.. " Fireworks Freezed")
	else
		util.toast(counteroffirework.. " Fireworks UnFreezed")
	end
end)
menu.action(fireworkalllist, "Richitg auf den Boden stellen", {}, "berügsichtigt den boden und passt es dazu an", function()
	local counteroffirework = 0
	for fireworktablelistexists as Object do
		getcontrole(Object)
		PLACE_OBJECT_ON_GROUND_PROPERLY(Object)
		counteroffirework += 1
	end
	util.toast(counteroffirework.. " Fireworks set Properly on ground")
end)
menu.action(fireworkalllist, "Rotation auf 0 stellen", {}, "damit wird er genau nach oben gucken", function()
	local counteroffirework = 0
	for fireworktablelistexists as Object do
		getcontrole(Object)
		SET_ENTITY_ROTATION(Object, 0.0, 0.0, 0.0, 5, true)
		counteroffirework += 1
	end
	util.toast(counteroffirework.. " Fireworks put on Rot = 0")
end)

menu.action(fireworklist, "nur firework", {}, "Schießt ein firework etwas weiter vor dir", function()
	local playeroffset = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +0.5, -1)
	local fireowrkpos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +10, 0)
	Streamptfx(ptfnamelib)
	START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(ptfnamesel, fireowrkpos.x, fireowrkpos.y, fireowrkpos.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	SET_PARTICLE_FX_NON_LOOPED_COLOUR(fireworkcolourselect.r, fireworkcolourselect.g, fireworkcolourselect.b)
end)

menu.toggle_loop(fireworklist, "Random firework arround you", {}, "schießt random Firework arround you", function()
	local playeroffset = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +0.5, -1)
	local fireowrkpos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +10, 0)
	if fireworksrandomeffect then
		local effectrandom = math.random( 1,4 )
		menu.set_value(fireworklistselect,effectrandom)
	end
	local coordrandom = math.random( -20, 20)
	local coordrandom2 = math.random( -20, 20)
	if coordrandom > 0 then
		fireowrkpos.x = fireowrkpos.x + coordrandom
	else
		fireowrkpos.x = fireowrkpos.x - coordrandom
	end
	if coordrandom2 > 0 then
		fireowrkpos.y = fireowrkpos.y + coordrandom
	else
		fireowrkpos.y = fireowrkpos.y - coordrandom
	end
	Streamptfx(ptfnamelib)
	START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(ptfnamesel, fireowrkpos.x, fireowrkpos.y, fireowrkpos.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	SET_PARTICLE_FX_NON_LOOPED_COLOUR(fireworkcolourselect.r, fireworkcolourselect.g, fireworkcolourselect.b)
	util.yield(400)
end)







slaxdom = require("lib/slaxdom")
--slaxml = require("lib/slaxml")
--lunajson = require("lunajson")
local iniparser = require("iniparser")
local fail_text = "This file failed to load properly and may be of an unsupported format. Please submit a bug report on Discord and attach the vehicle you just tried loading."
local instruction_text = "\nHold shift and ctrl while clicking an option to delete this item from your directory.\nHold space and click an option to add this itemto your favorites."


function request_anim_dict(dict)
    request_time = os.time()
    if not DOES_ANIM_DICT_EXIST(dict) then
        return
    end
    REQUEST_ANIM_DICT(dict)
    while not HAS_ANIM_DICT_LOADED(dict) do
        if os.time() - request_time >= 10 then
            break
        end
        util.yield()
    end
end

function request_model_load(hash)
    request_time = os.time()
    if not IS_MODEL_VALID(hash) then
        return
    end
   	REQUEST_MODEL(hash)
    while not HAS_MODEL_LOADED(hash) do
        if os.time() - request_time >= 10 then
            break
        end
        util.yield()
    end
end

function hasValue( tbl, str )
    local f = false
    for i = 1, #tbl do
        if type( tbl[i] ) == "table" then
            f = hasValue( tbl[i], str )  --  return value from recursion
            if f then break end  --  if it returned true, break out of loop
        elseif tbl[i] == str then
            return true
        end
    end
    return f
end

function split_str(inputstr, sep)
    return string.split(inputstr, sep)
end

function to_boolean(text)
    if text == 'true' or text == "1" then
        return true
    end
    return false
end

function get_element_text(el)
    local pieces = {}
    for _,n in ipairs(el.kids) do
      if n.type=='element' then pieces[#pieces+1] = get_element_text(n)
      elseif n.type=='text' then pieces[#pieces+1] = n.value
      end
    end
    return table.concat(pieces)
end

store_dir = filesystem.store_dir() .. '\\LanceSpooner\\'

if not filesystem.is_dir(store_dir) then
    filesystem.mkdirs(store_dir)
    if not SCRIPT_SILENT_START then
        util.toast("Welcome to LanceSpooner!")
        util.toast("Put your vehicles and maps into Lua Scripts / store / LanceSpooner / vehicles or maps :)")
    end
end

if filesystem.is_dir(filesystem.scripts_dir() .. '\\menyoo vehicles') or filesystem.is_dir(filesystem.scripts_dir() .. '\\menyoo maps') and not SCRIPT_SILENT_START then
    --util.toast("You have the old menyoo vehicles directory! Things have moved.")
    --util.toast("Put your vehicles and maps into Lua Scripts / store / LanceSpooner / vehicles or maps to be able to spawn them :). Remove the old directory to remove this message.")
end

vehicles_dir = store_dir .. '\\vehicles\\'
if not filesystem.is_dir(vehicles_dir) then
    filesystem.mkdir(vehicles_dir)
end


maps_dir = store_dir .. '\\maps\\'
if not filesystem.is_dir(maps_dir) then
    filesystem.mkdir(maps_dir)
end

function parse_xml(path)
    -- does this path even exist?
    if not filesystem.exists(path) then
        util.toast("Error parsing XML. File doesn\'t exist?")
        return
    end
    -- break file into string
    local xml = io.open(path):read('*all')
    -- dom that shit ;)
    local dom = slaxdom:dom(xml, {stripWhitespace=true})
    -- return our dominant superior ;)
    return dom
end

all_vehicles = {}
all_maps = {}

favorite_vehicles = {}
favorite_maps = {}

function search_vehicle(query)
    local finds = {}
    for i, path in ipairs(filesystem.list_files(vehicles_dir)) do
        local v_name = path:gsub(vehicles_dir, '')
        if string.endswith(v_name, '.ini') or string.endswith(v_name, '.xml') or string.endswith(v_name, '.json') then
            if string.contains(string.lower(v_name), query) then
                finds[#finds + 1] = v_name
            end
        end
    end
    return finds
end

function search_map(query)
    local finds = {}
    for i, path in ipairs(filesystem.list_files(maps_dir)) do
        local m_name = path:gsub(maps_dir, '')
        if string.endswith(m_name, '.xml')then
            if string.contains(string.lower(m_name), query) then
                finds[#finds + 1] = m_name
            end
        end
    end
    return finds
end

local v_search_results_action 
local m_search_results_action

function get_file_type(file_path)
    local _, _, ext = string.match(file_path, "(.-)([^\\/]-%.?)[.]([^%.\\/]*)$")
    return ext
end

menu.action(Menyoveh, "Load new maps/vehicles", {}, "spam es lieber nicht sonst nix gut einmal drücken reicht", function()
	util.yield()
	get_all_vehicles_in_dir()
	get_all_maps_in_dir()
	util.toast("Listen wurden geupdatet")
end)

menu.divider(Menyoveh, "Vehicles")

menu.action(Menyoveh, "Search vehicle", {"lssearchv"}, "", function(click_type)
    menu.show_command_box("lssearchv" .. " ")
    end, function(on_command)
        local results = search_vehicle(on_command)
        if #results == 0 then 
            util.toast("No results :(")
        else
            menu.set_list_action_options(v_search_results_action, results)
            menu.trigger_commands("lsvsearchresults")
        end
end)

function load_vehicle(path)
    local ext = get_file_type(path) 
    pluto_switch ext do 
        case "xml": 
            menyoo_load_vehicle(path)
            break 
        case "ini":
            ini_load_vehicle(path:gsub(vehicles_dir, ''))
            break 
        case "json":
            --json_load_vehicle(path)
            util.toast("das ist eine json file die geht nicht")
            break 
       -- pluto_default:
         --   util.toast("This is not a supported file.")
    end
end

function load_map(path)
    local ext = get_file_type(path) 
    pluto_switch ext do 
        case "xml": 
            menyoo_load_map(path)
            break
       -- pluto_default:
          --  util.toast("This is not a supported file.")
    end
end

function favorite_vehicle(file_name)
    local full_path = vehicles_dir .. '\\' .. file_name
    local half_path = vehicles_dir .. '\\'
    os.rename(full_path, half_path .. '[F] ' .. file_name)
    util.toast(file_name .. " added to favorites!")
    get_all_vehicles_in_dir()
end

function favorite_map(file_name)
    local full_path = maps_dir .. '\\' .. file_name
    local half_path = maps_dir .. '\\'
    os.rename(full_path, half_path .. '[F] ' .. file_name)
    util.toast(file_name .. " added to favorites!")
    get_all_maps_in_dir()
end

local load_vehicle_action = menu.list_action(Menyoveh, "Load vehicle", {}, "Load a vehicle. " .. instruction_text, all_vehicles, function(index, value)
    local path = vehicles_dir .. '\\' .. value
    if util.is_key_down(0x10) and util.is_key_down(0x11) then
        os.remove(path)
        util.toast(value .. " deleted! :)")
        get_all_vehicles_in_dir()
    elseif util.is_key_down(0x20) then 
        favorite_vehicle(value)
    else
        load_vehicle(vehicles_dir .. '\\' .. value)
    end
end)

loaded_vehicles_root = menu.list(Menyoveh, "Currently loaded vehicles", {"lancespoonerloadedvehicles"}, "Vehicles you have spawned")


menu.divider(Menyoveh, "Maps")
menu.action(Menyoveh, "Search map", {"lssearchmap"}, "", function(click_type)
    menu.show_command_box("lssearchmap" .. " ")
    end, function(on_command)
        local results = search_map(on_command)
        if #results == 0 then 
            util.toast("No results :(")
        else
            menu.set_list_action_options(m_search_results_action, results)
            menu.trigger_commands("lsmsearchresults")
        end
end)

local load_map_action = menu.list_action(Menyoveh, "Load map", {}, "Load a map. " .. instruction_text, all_maps, function(index, value)
    local path = maps_dir .. '\\' .. value
    if util.is_key_down(0x10) and util.is_key_down(0x11) then
        os.remove(path)
        util.toast(value .. " deleted! :)")
        get_all_maps_in_dir()
    elseif util.is_key_down(0x20) then 
        favorite_map(value)
    else
        load_map(path)
    end
end)
loaded_maps_root = menu.list(Menyoveh, "Currently loaded maps", {"lancespoonerloadedmaps"}, "Maps you have loaded")

menu.divider(Menyoveh, "Favorites")

local load_favorite_vehicle_action = menu.list_action(Menyoveh, "Favorite vehicles", {}, "Load a vehicle.", favorite_vehicles, function(index, value)
    load_vehicle(vehicles_dir .. '\\' .. value)
end)

local load_favorite_map_action = menu.list_action(Menyoveh, "Favorite maps", {}, "Load a map.", favorite_maps, function(index, value)
    load_map(maps_dir .. '\\' .. value)
end)

function get_all_vehicles_in_dir()
    local temp_vehicles = {}
    local temp_favorite_vehicles = {}
    local temp_favorite_maps = {}
    local supported_formats = {'.xml', '.ini', '.json'}
    for i, path in ipairs(filesystem.list_files(vehicles_dir)) do
        for _, fmt in pairs(supported_formats) do 
            if string.match(path:gsub(vehicles_dir, ''), fmt) then
                temp_vehicles[#temp_vehicles + 1] = path:gsub(vehicles_dir, '')
                if string.startswith(path:gsub(vehicles_dir, ''), '[F]') then 
                    temp_favorite_vehicles[#temp_favorite_vehicles+1] = path:gsub(vehicles_dir, '')
                end
            end
        end
    end

    all_vehicles = temp_vehicles
    favorite_vehicles = temp_favorite_vehicles
    menu.set_list_action_options(load_vehicle_action, all_vehicles)
    menu.set_list_action_options(load_favorite_vehicle_action, favorite_vehicles)
end

function get_all_maps_in_dir()
    local temp_maps = {}
    local temp_favorite_maps = {}
    for i, path in ipairs(filesystem.list_files(maps_dir)) do
        if string.match(path:gsub(maps_dir, ''), '.xml') then
            temp_maps[#temp_maps + 1] = path:gsub(maps_dir, '')
            if string.startswith(path:gsub(maps_dir, ''), '[F]') then 
                temp_favorite_maps[#temp_favorite_maps+1] = path:gsub(maps_dir, '')
            end
        end
    end


    all_maps = temp_maps
    favorite_maps = temp_favorite_maps
    menu.set_list_action_options(load_map_action, all_maps)
    menu.set_list_action_options(load_favorite_map_action, favorite_maps)
end

get_all_vehicles_in_dir()
get_all_maps_in_dir()

menu.divider(Menyoveh, "Misc")
v_search_results = {}
v_search_results_action = menu.list_action(Menyoveh, "Vehicle search results", {"lsvsearchresults"}, instruction_text, v_search_results, function(index, value)
    local path = vehicles_dir .. '\\' .. value
    if util.is_key_down(0x10) and util.is_key_down(0x11) then
        os.remove(path)
        util.toast(value .. " deleted! :)")
        get_all_vehicles_in_dir()
        menu.set_list_action_options(v_search_results_action, {})
    elseif util.is_key_down(0x20) then 
        favorite_vehicle(value)
        menu.set_list_action_options(v_search_results_action, {})
    else
        load_vehicle(path)
    end
end)

m_search_results = {}
m_search_results_action = menu.list_action(Menyoveh, "Map search results", {"lsmsearchresults"}, instruction_text, m_search_results, function(index, value)
    local path = maps_dir .. '\\' .. value
    if util.is_key_down(0x10) and util.is_key_down(0x11) then
        os.remove(path)
        util.toast(value .. " deleted! :)")
        get_all_maps_in_dir()
        menu.set_list_action_options(m_search_results_action, {})
    elseif util.is_key_down(0x20) then 
        favorite_map(value)
        menu.set_list_action_options(m_search_results_action, {})
    else
        menyoo_load_map(path)
    end
end)

function menyoo_preprocess_ped(ped, att_data, entity_initial_handles)
    local ped_data = {}
    isped = true
    entity = ped
    menyoo_preprocess_entity(ped, att_data)
    if #entity_initial_handles > 0 then
        entity_initial_handles[att_data['InitialHandle']] = ped
    end
    for a,b in pairs(att_data['PedProperties'].kids) do
        local name = b.name
        local val = get_element_text(b)
        if name == 'PedProps' or name == 'PedComps' or name == 'TaskSequence' then
            ped_data[name] = b 
        else
            ped_data[name] = val
        end
    end
    local task_data = {}
    if att_data['TaskSequence'] ~= nil then
        for a,b in pairs(att_data['TaskSequence'].kids) do
            for c,d in pairs(b.kids) do
                task_data[d.name] = get_element_text(d)
            end
        end
    end
    local props = menyoo_build_properties_table(ped_data['PedProps'].kids)
    for k,v in pairs(props) do
        k = k:gsub('_', '')
        v = split_str(v, ',')
        SET_PED_PROP_INDEX(ped, k, tonumber(v[1]), tonumber(v[2]), true, 0)
    end
    local comps = menyoo_build_properties_table(ped_data['PedComps'].kids)
    for k,v in pairs(comps) do
        k = k:gsub('_', '')
        v = split_str(v, ',')
        SET_PED_COMPONENT_VARIATION(ped, k, tonumber(v[1]), tonumber(v[2]), tonumber(v[2]))
    end
    SET_PED_CAN_RAGDOLL(ped, to_boolean(ped_data['CanRagdoll']))
	if ped_data['Armour'] != nil then
    	SET_PED_ARMOUR(ped, ped_data['Armour'])
	end
    GIVE_WEAPON_TO_PED(ped, ped_data['CurrentWeapon'], 999, false, true)
    -- skipping over relationship groups, fuck that shit, seriously
    -- anim shit
    if task_data['AnimDict'] ~= nil then
        request_anim_dict(task_data['AnimDict'])
        local duration = tonumber(task_data['Duration'])
        local flag = tonumber(task_data['Flag'])
        local speed = tonumber(task_data['Speed'])
        TASK_PLAY_ANIM(ped, task_data['AnimDict'], task_data['AnimName'], 8.0, 8.0, duration, flag, speed, false, false, false)
    elseif ped_data['AnimDict'] ~= nil then
        request_anim_dict(ped_data['AnimDict'])
        TASK_PLAY_ANIM(ped, ped_data['AnimDict'], ped_data['AnimName'], 8.0, 8.0, -1, 1, 1.0, false, false, false)
    end
end

function nil_handler(val, default)
    if val == nil then
        val = default
    end
    return val
end

function menyoo_preprocess_entity(entity, data)
    data['Dynamic'] = nil_handler(data['Dynamic'], true)
    data['FrozenPos'] = nil_handler(data['FrozenPos'], true)
    data['OpacityLevel'] = nil_handler(data['OpacityLevel'], 255)
    data['IsInvincible'] = nil_handler(data['IsInvincible'], false)
    data['IsVisible'] = nil_handler(data['IsVisible'], true)
    data['HasGravity'] = nil_handler(data['HasGravity'], false)
    data['IsBulletProof'] = nil_handler(data['IsBulletProof'], false)
    data['IsFireProof'] = nil_handler(data['IsFireProof'], false)
    data['IsExplosionProof'] = nil_handler(data['IsExplosionProof'], false)
    data['IsMeleeProof'] = nil_handler(data['IsMeleeProof'], false)
    FREEZE_ENTITY_POSITION(entity, to_boolean(data['FrozenPos']))
    if tonumber(data['OpacityLevel']) ~= 255 then 
        SET_ENTITY_ALPHA(entity, tonumber(data['OpacityLevel']), false)
    end
    SET_ENTITY_INVINCIBLE(entity, to_boolean(data['IsInvincible']))
    SET_ENTITY_VISIBLE(entity, to_boolean(data['IsVisible']), 0)
    SET_ENTITY_HAS_GRAVITY(entity, to_boolean(data['HasGravity']))
    SET_ENTITY_PROOFS(entity, to_boolean(data['IsBulletProof']), to_boolean(data['IsFireProof']), to_boolean(data['IsExplosionProof']), false, to_boolean(data['IsMeleeProof']), false, true, false)
end

function menyoo_preprocess_car(vehicle, data)
    local colors = menyoo_build_properties_table(data['Colours'].kids)
    local neons = menyoo_build_properties_table(data['Neons'].kids)
    local doorsopen = menyoo_build_properties_table(data['DoorsOpen'].kids)
    local doorsbroken = menyoo_build_properties_table(data['DoorsBroken'].kids)
    if data['TyresBursted'] ~= nil then
        local tyresbursted = menyoo_build_properties_table(data['TyresBursted'].kids)
        for k,v in pairs(tyresbursted) do
            -- fucking menyoo.. here they go mixing up wheel indexes with strings
            k = k:gsub('_', '')
            local cure_menyoo_aids = {['FrontLeft'] = 0, ['FrontRight'] = 1, [2] = 2, [3] = 3, ['BackLeft'] = 4, ['BackRight'] = 5, [6]=6, [7]=7, [8]=8}
			if cure_menyoo_aids[k] != nil then
				SET_VEHICLE_TYRE_BURST(vehicle, cure_menyoo_aids[k], false, 0.0)
			end
        end
    end
    local mods = menyoo_build_properties_table(data['Mods'].kids)
    local mod_extras = menyoo_build_properties_table(data['ModExtras'].kids)
    if mod_extras ~= nil then 
        for k,v in pairs(mod_extras) do
            k = k:gsub('_', '')
            SET_VEHICLE_EXTRA(vehicle, k, not to_boolean(v))
        end
    end
    
    for k,v in pairs(neons) do
        local comp = {['Left']=0, ['Right']=1, ['Front']=2, ['Back']=3}
		if comp[k] != nil then
       	 	SET_VEHICLE_NEON_ENABLED(vehicle, comp[k], to_boolean(v))
		end
    end

    SET_VEHICLE_WHEEL_TYPE(vehicle, tonumber(data['WheelType']))
    for k,v in pairs(mods) do
        k = k:gsub('_', '')
        v = split_str(v, ',')
		if tonumber(v[1]) != nil then
        	SET_VEHICLE_MOD(vehicle, tonumber(k), tonumber(v[1]), to_boolean(v[2]))
		end
    end


    for k,v in pairs(colors) do
        colors[k] = tonumber(v)
    end

    SET_VEHICLE_COLOURS(vehicle, colors['Primary'], colors['Secondary'])
    SET_VEHICLE_EXTRA_COLOURS(vehicle, colors['Pearl'], colors['Rim'])
    SET_VEHICLE_TYRE_SMOKE_COLOR(vehicle, colors['tyreSmoke_R'], colors['tyreSmoke_G'], colors['tyreSmoke_B'])
    SET_VEHICLE_EXTRA_COLOUR_5(vehicle, colors['LrInterior'])
    SET_VEHICLE_EXTRA_COLOUR_6(vehicle, colors['LrDashboard'])
    local livery = tonumber(data['Livery'])
    if livery == -1 then
        livery = 0
    end
    SET_VEHICLE_LIVERY(vehicle, livery)
    SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle, data['NumberPlateText'])
	if tonumber(data['NumberPlateTextIndex']) != nil then
    	SET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(vehicle, tonumber(data['NumberPlateTextIndex']))
	end
    -- wheel invis here
    -- engine sound name here
    SET_VEHICLE_WINDOW_TINT(vehicle, tonumber(data['WindowTint']))
    SET_VEHICLE_TYRES_CAN_BURST(vehicle, to_boolean(data['BulletProofTyres']))
     SET_VEHICLE_DIRT_LEVEL(vehicle, tonumber(data['DirtLevel']))
    SET_VEHICLE_ENVEFF_SCALE(vehicle, tonumber(data['PaintFade']))
    SET_CONVERTIBLE_ROOF_LATCH_STATE(vehicle, tonumber(data['RoofState']))
    SET_VEHICLE_SIREN(vehicle, to_boolean(data['SirenActive']))
    SET_VEHICLE_ENGINE_ON(vehicle, to_boolean(data['EngineOn']), true, false)
    -- not sure how to set lights on
    SET_VEHICLE_RADIO_LOUD(vehicle, to_boolean(data['IsRadioLoud']))
	if tonumber(data['LockStatus']) != nil then
    	SET_VEHICLE_DOORS_LOCKED(vehicle, tonumber(data['LockStatus']))
	end
    if data['EngineHealth'] ~= nil then
        SET_VEHICLE_ENGINE_HEALTH(vehicle, tonumber(data['EngineHealth']))
    end
end

function menyoo_build_properties_table(kids)
    if kids ~= nil then
        local table = {}
        for k,v in pairs(kids) do
            local name = v.name
            local val = get_element_text(v)
            table[name] = val
        end
        return table
    end
    return nil
end

function get_net_objects()
	local objects <const> = entities.get_all_objects_as_handles()
	local net_objects <const> = {}
	for i = 1, #objects do
		if NETWORK_GET_ENTITY_IS_NETWORKED(objects[i]) then
			net_objects[#net_objects + 1] = objects[i]
		end
	end
	return net_objects
end

function get_net_peds()
	local peds <const> = entities.get_all_peds_as_handles()
	local net_peds <const> = {}
	for i = 1, #peds do
		if NETWORK_GET_ENTITY_IS_NETWORKED(peds[i]) then
			net_peds[#net_peds + 1] = peds[i]
		end
	end
	return net_peds
end

function get_net_vehicles()
	local vehicles <const> = entities.get_all_vehicles_as_handles()
	local net_vehicles <const> = {}
	for i = 1, #vehicles do
		if NETWORK_GET_ENTITY_IS_NETWORKED(vehicles[i]) then
			net_vehicles[#net_vehicles + 1] = vehicles[i]
		end
	end
	return net_vehicles
end

function send_spawn_counter_msg(counterobj, counterped, counterveh)
	util.toast(string.format("%s\n%s: %i\n%s: %i\n%s: %i", 
		"Spawned", 
		"Peds",
		counterped,
		"Vehicles",
		counterveh,
		"Objects",
		counterobj),
        TOAST_ALL
	)
end

function get_max_networked_vehicles()
	return GET_MAX_NUM_NETWORK_VEHICLES() > 128 and 128 or GET_MAX_NUM_NETWORK_VEHICLES()
end

function send_is_networked_msg(counterobj, counterped, counterveh, network_status)
	if network_status == "is_networked" then
		util.toast("The map/vehicle will be visible to other people.", TOAST_ALL)
	elseif counterobj <= GET_MAX_NUM_NETWORK_OBJECTS() and counterped <= GET_MAX_NUM_NETWORK_PEDS() and counterveh <= get_max_networked_vehicles() then
		util.toast("The map/vehicle can be networked if you clear all entities. Currently there are other networked entities taking up space.", TOAST_ALL)
	else
		util.toast(
			string.format(
				"The map/vehicle won't be visible to other players, it has too many entities. Networked maps/vehicles supports max:\n%i objects\n%i vehicles\n%i peds.",
				GET_MAX_NUM_NETWORK_OBJECTS(),
				get_max_networked_vehicles(),
				GET_MAX_NUM_NETWORK_PEDS()
			), TOAST_ALL
		)
	end
end


function menyoo_load_map(path)
    local all_entities = {}
    util.toast("Your map is loading!...")
    local entity_initial_handles = {}
    local xml_tbl = parse_xml(path).root
    local counterobj, counterped, counterveh = 0, 0, 0
    -- n appears to be the enum of the kid, k is the actual kid table
    local data = {}
    for a,b in pairs(xml_tbl.kids) do
        local vproperties = {}
        local pproperties = {}
        local name = b.name
        local isvehicle = false
        local isped = false
        if name == 'ReferenceCoords' then
            for k,v in pairs(b.kids) do
                if v.name == 'X' then
                    mmblip_x = tonumber(get_element_text(v))
                elseif v.name == 'Y' then
                    mmblip_y = tonumber(get_element_text(v))
                elseif v.name == 'Z' then
                    mmblip_z = tonumber(get_element_text(v))
                end
            end
            mmblip = ADD_BLIP_FOR_COORD(mmblip_x, mmblip_y, mmblip_z)
            SET_BLIP_SPRITE(mmblip, 77)
            SET_BLIP_COLOUR(mmblip, 48)
        end
        if name == 'Placement' then
            for c,d in pairs(b.kids) do
                if d.name == 'PositionRotation' then
                    for e, f in pairs(d.kids) do
                        data[f.name] = get_element_text(f)
                    end
                elseif d.name == 'VehicleProperties' then
                    isvehicle = true
                    for n, p in pairs(d.kids) do
                        local prop_name = p.name
                        if prop_name == 'Colours' or prop_name == 'Neons' or prop_name == 'Mods' or prop_name == 'DoorsOpen' or prop_name == 'DoorsBroken' or prop_name == 'TyresBursted' then
                            vproperties[prop_name] = p
                        else
                            vproperties[prop_name]  = get_element_text(p)
                        end
                    end
                elseif d.name == 'PedProperties' then
                    isped = true
                    pproperties[d.name] = d
                else
                    data[d.name] = get_element_text(d)
                end
            end
            mmpos = {}
            mmpos.x = tonumber(data['X'])
            mmpos.y = tonumber(data['Y'])
            mmpos.z = tonumber(data['Z'])
            mmrot = {}
            mmrot.pi = tonumber(data['Pitch'])
            mmrot.ro = tonumber(data['Roll'])
            mmrot.ya = tonumber(data['Yaw'])
            if IS_MODEL_VALID(data['ModelHash']) then
                local mment = 0
                if isvehicle then
                    request_model_load(data['ModelHash'])
                    mment = entities.create_vehicle(data['ModelHash'], mmpos, mmrot.ya)
                    entities.set_can_migrate(mment, false)
                    menyoo_preprocess_entity(mment, data)
                    menyoo_preprocess_car(mment, vproperties)
                    counterveh += 1
                elseif isped then
                    request_model_load(data['ModelHash'])
                    mment = entities.create_ped(0, data['ModelHash'], mmpos, mmrot.ya)
                    entities.set_can_migrate(mment, false)
                    menyoo_preprocess_ped(mment, pproperties, {})
                    menyoo_preprocess_entity(mment, data)
                    counterped += 1
                else
                    request_model_load(data['ModelHash'])
                    mment = entities.create_object(data['ModelHash'], mmpos)
                    entities.set_can_migrate(mment, false)
                    menyoo_preprocess_entity(mment, data)
                    counterobj += 1
                end
                table.insert(all_entities, mment)
                SET_ENTITY_ROTATION(mment, mmrot.pi, mmrot.ro, mmrot.ya, 2, true)
            else
                util.toast("Some invalid models were found. Make sure you aren\'t using XML\'s that require mods.")
            end
        end
    end
    if mmblip == nil then 
        util.toast("There was an issue loading this map. Make sure the XML is a Menyoo XML.")
        return 
    end
    mm_maproot = menu.list(loaded_maps_root, path:gsub(maps_dir, "") .. ' [' .. mmblip .. ']', {"lancespoonerloadedmaps" .. mmblip}, mmblip)
    menu.action(mm_maproot, "Teleport to map", {"menyoomteleportto" .. mmblip}, "Teleport to this map.", function(on_click)
        SET_ENTITY_COORDS_NO_OFFSET(PLAYER_PED_ID(), mmpos.x, mmpos.y, mmpos.z, false, false, false)
    end)

    menu.action(mm_maproot, "Delete map", {"menyoomdelete" .. mmblip}, "", function(on_click)
        for k,v in pairs(all_entities) do
            entities.delete(v)
        end
        menu.delete(mm_maproot)
        -- apparently remove blip is fucked, so we set sprite to invis as a failsafe
        util.remove_blip(mmblip)
    end)
    local network_status = 
        counterobj <= GET_MAX_NUM_NETWORK_OBJECTS() - #get_net_objects() 
        and counterped <= GET_MAX_NUM_NETWORK_PEDS() - #get_net_peds() 
        and counterveh <= get_max_networked_vehicles() - #get_net_vehicles()
        and "is_networked" or "is_not_networked"

    send_spawn_counter_msg(counterobj, counterped, counterveh)
    send_is_networked_msg(counterobj, counterped, counterveh, network_status)
    util.toast("Map load complete. Look for a magenta-colored L on your map.")
end

function menyoo_load_vehicle(path)
    our_ped = players.user_ped()
    local counterobj, counterped, counterveh = 0, 0, 0
    local all_entities = {}
    local entity_initial_handles = {}
    local data = {}
    local vproperties = {}
    local xml_tbl = parse_xml(path).root
    local initial_handle_index = 0
    -- n appears to be the enum of the kid, k is the actual kid table
    for k,v in pairs(xml_tbl.kids) do
        local name = v.name
        if name == 'VehicleProperties' then
            for n, p in pairs(v.kids) do
                local prop_name = p.name
                if prop_name == 'Colours' or prop_name == 'Neons' or prop_name == 'Mods' or prop_name == 'DoorsOpen' or prop_name == 'DoorsBroken' or prop_name == 'TyresBursted' then
                    vproperties[prop_name] = p
                else
                    vproperties[prop_name]  = get_element_text(p)
                end
            end
        else
            if name == 'SpoonerAttachments' then
                data[name] = v
            else
                local el_text = get_element_text(v)
                data[name] = el_text
            end
        end
    end
    if data['ModelHash'] == nil then 
        util.toast(fail_text)
        return 
    end
    request_model_load(data['ModelHash'])
    local coords = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(our_ped, 0.0, 5.0, 0.0)
    local vehicle = entities.create_vehicle(data['ModelHash'], coords, GET_ENTITY_HEADING(our_ped))
    table.insert(all_entities, vehicle)
    SET_ENTITY_INVINCIBLE(vehicle, true)
    SET_PED_INTO_VEHICLE(our_ped, vehicle, -1)
    if data['InitialHandle'] == nil then
        initial_handle_index = initial_handle_index + 1
        data['InitialHandle'] = initial_handle_index
    end
    entity_initial_handles[data['InitialHandle']] = vehicle
    -- apply natives that can apply to any entity
    menyoo_preprocess_entity(vehicle, data)
    menyoo_preprocess_car(vehicle, vproperties)
    -- vehicle-specific natives
    -- now for the attachments...
    local attachments = data['SpoonerAttachments']
    all_attachments = {}
    if attachments ~= nil then
        for a,b in pairs(attachments.kids) do
            local vproperties = {}
            -- each item here should be "attachment" element
            local att_data = {}
            for c,d in pairs(b.kids) do
                local name = d.name
                local val = get_element_text(d)
                if name == 'PedProperties' or name == 'Attachment' or name == 'TaskSequence' then
                    att_data[name] = d
                elseif name == 'VehicleProperties' then
                    for n, p in pairs(d.kids) do
                        local prop_name = p.name
                        if prop_name == 'Colours' or prop_name == 'Neons' or prop_name == 'Mods' or prop_name == 'DoorsOpen' or prop_name == 'DoorsBroken' or prop_name == 'TyresBursted' then
                            vproperties[prop_name] = p
                        else
                            vproperties[prop_name]  = get_element_text(p)
                        end
                    end
                else
                    att_data[name] = val
                end
            end
            request_model_load(att_data['ModelHash'])
            -- 1 = ped, 2 = vehicle, 3 = object
            local attachment_info = menyoo_build_properties_table(att_data['Attachment'].kids)
            local entity = nil
            local isped = false
            if att_data['Type'] == '1' then
                local ped = entities.create_ped(0, att_data['ModelHash'], coords, GET_ENTITY_HEADING(players.user_ped()))
                menyoo_preprocess_ped(ped, att_data, entity_initial_handles)
                entities.set_can_migrate(ped, false)
                entity = ped
                counterped += 1
            elseif att_data['Type'] == '2' then
                local veh = entities.create_vehicle(att_data['ModelHash'], coords, GET_ENTITY_HEADING(players.user_ped()))
                entities.set_can_migrate(veh, false)
                entity = veh
                menyoo_preprocess_entity(veh, att_data)
                menyoo_preprocess_car(veh, vproperties)
                counterveh += 1
            elseif att_data['Type'] == '3' then
				v3.setZ(coords, v3.getZ(coords) -10)
                local obj = entities.create_object(att_data['ModelHash'], coords)
                entities.set_can_migrate(obj, false)
                entity = obj
                menyoo_preprocess_entity(obj, att_data)
                counterobj += 1
                -- obj code
            end
            table.insert(all_entities, entity)
            SET_ENTITY_INVINCIBLE(entity, true)
            local bone = tonumber(attachment_info['BoneIndex'])
            local x = tonumber(attachment_info['X'])
            local y = tonumber(attachment_info['Y'])
            local z = tonumber(attachment_info['Z'])
            local pitch = tonumber(attachment_info['Pitch'])
            local yaw = tonumber(attachment_info['Yaw'])
            local roll = tonumber(attachment_info['Roll'])
            all_attachments[entity] = {}
            all_attachments[entity]['attachedto'] = attachment_info['AttachedTo']
            all_attachments[entity]['bone'] = bone
            all_attachments[entity]['x'] = x
            all_attachments[entity]['y'] = y
            all_attachments[entity]['z'] = z
            all_attachments[entity]['pitch'] = pitch
            all_attachments[entity]['yaw'] = yaw
            all_attachments[entity]['roll'] = roll
            all_attachments[entity]['isped'] = isped
        end
        for k, v in pairs(all_attachments) do
			if entity_initial_handles[v['attachedto']] != nil then
           		ATTACH_ENTITY_TO_ENTITY(k, entity_initial_handles[v['attachedto']], v['bone'], v['x'], v['y'], v['z'], v['pitch'], v['roll'], v['yaw'], true, false, true, v['isped'], 2, true, 0)
			end
		end
    end
    local this_blip = ADD_BLIP_FOR_ENTITY(vehicle)
    SET_BLIP_SPRITE(this_blip, 77)
    SET_BLIP_COLOUR(this_blip, 47)
    local this_veh_root = menu.list(loaded_vehicles_root, path:gsub(vehicles_dir .. '\\', ''), {"lancespoonerv" .. vehicle}, tostring(this_blip))
    menu.action(this_veh_root, "Delete", {"deletelancespoonerv" .. vehicle}, "Delete this vehicle. Make it cease to exist.", function(on_click)
        for k,v in pairs(all_entities) do
            entities.delete(v)
        end
        menu.delete(this_veh_root)
        util.remove_blip(this_blip)
    end)
    menu.action(this_veh_root, "Teleport inside", {"teleportemenyoov" .. vehicle}, "", function(on_click)
        SET_PED_INTO_VEHICLE(PLAYER_PED_ID(), vehicle, -1)
    end)
    local network_status = 
        counterobj <= GET_MAX_NUM_NETWORK_OBJECTS() - #get_net_objects() 
        and counterped <= GET_MAX_NUM_NETWORK_PEDS() - #get_net_peds() 
        and counterveh <= get_max_networked_vehicles() - #get_net_vehicles()
        and "is_networked" or "is_not_networked"
    
    send_spawn_counter_msg(counterobj, counterped, counterveh)
    send_is_networked_msg(counterobj, counterped, counterveh, network_status)
    return vehicle
end

function ini_preprocess_vehicle(vehicle, data, ini_type, veh_index) 
    -- vehicle is a handle to an already-spawned vehicle
    if ini_type == 1 then
        SET_VEHICLE_COLOURS(vehicle, data.Primary or 0, data.Secondary or 0)
        SET_VEHICLE_TYRE_SMOKE_COLOR(vehicle, data.SmokeR or 0, data.SmokeG or 0, data.SmokeB or 0)
        SET_VEHICLE_NEON_COLOUR(vehicle, data.NeonR or 0, data.NeonG or 0, data.NeonB or 0)
        SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle, "LANCE")
        SET_VEHICLE_DIRT_LEVEL(vehicle, data.Dirt or 0)
        SET_VEHICLE_ENVEFF_SCALE(vehicle, data.PaintFade or 0)
        SET_VEHICLE_WHEEL_TYPE(vehicle, data.Wheels or 0)
        SET_VEHICLE_EXTRA_COLOURS(vehicle, data.Pearl or 0, data.WheelColor or 0)
        SET_VEHICLE_WINDOW_TINT(vehicle, data.Tint or 0)

        if data['BulletProofTires'] == 1 then 
            SET_VEHICLE_TYRES_CAN_BURST(vehicle, false)
        end
        for i=1, 4 do 
            if data['Neon' .. i] == 1 then 
                SET_VEHICLE_NEON_ENABLED(vehicle, i, true)
            end
        end

        for i=0, 48 do
            if data[i] ~= nil then 
                -- idk how we even determine if a car has custom tires in this format
                SET_VEHICLE_MOD(vehicle, i, data[i], false)
            end
        end

        for i=1, 9 do 
            SET_VEHICLE_EXTRA(vehicle, i, if data['extra' .. i] == 0 then true else false)
        end

    elseif ini_type == 2 then
        local v_mods = data['Vehicle Mods']
        local v_extras = data['Vehicle Extras']
        local v_toggles = data['Vehicle Toggles']
        local data = data.Vehicle 
        SET_VEHICLE_COLOURS(vehicle, data['primary paint'] or 0, data['secondary paint'] or 0)
        SET_VEHICLE_TYRE_SMOKE_COLOR(vehicle, data['tyre smoke red'] or 0, data['tyre smoke green'] or 0, data['tyre smoke blue'] or 0)
        SET_VEHICLE_NEON_COLOUR(vehicle, data['neon red'] or 0, data['neon green'] or 0, data['neon blue'] or 0)
        SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle, "LANCE")
        SET_VEHICLE_DIRT_LEVEL(vehicle, data['dirt level'] or 0)
        --SET_VEHICLE_ENVEFF_SCALE(vehicle, data.PaintFade or 0)
        SET_VEHICLE_WHEEL_TYPE(vehicle, data['wheel type'] or 0)
        SET_VEHICLE_EXTRA_COLOURS(vehicle, data['pearlescent colour'] or 0, data['wheel colour'] or 0)
        SET_VEHICLE_WINDOW_TINT(vehicle, data['window tint'] or 0)
        SET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(vehicle, data['plate index'] or 0)

        if data['bulletproof tyres'] == 1 then 
            SET_VEHICLE_TYRES_CAN_BURST(vehicle, false)
        end

        for i=1, 4 do 
            if data['neon ' .. i] == 1 then 
                SET_VEHICLE_NEON_ENABLED(vehicle, i, true)
            end
        end

        for i= 1, 7 do 
            if data['door ' .. i .. ' state'] == 1 then
                SET_VEHICLE_DOOR_OPEN(vehicle, i, false, true)
            end
        end

        for i=0, 48 do
            if v_mods[i] ~= nil then 
                -- idk how we even determine if a car has custom tires in this format
                SET_VEHICLE_MOD(vehicle, i, v_mods[i], false)
            end
        end

        for i=1, 9 do 
            SET_VEHICLE_EXTRA(vehicle, i, if v_extras[i] == 0 then true else false)
        end

        for i=17, 22 do 
            TOGGLE_VEHICLE_MOD(vehicle, i, if v_toggles[i] == 1 then true else false)
        end

    elseif ini_type == 3 then
        SET_VEHICLE_COLOURS(vehicle, data.PrimaryPaint or 0, data.SecondaryPaint or 0)
        if data.PrimaryPaint == -1 then 
            SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(vehicle, data.PrimaryR or 0, data.PrimaryG or 0, data.PrimaryB or 0)
        end 
        if data.SecondaryPaint == -1 then 
            SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(vehicle, data.SecondaryR, data.SecondaryG, data.SecondaryB)
        end
        SET_VEHICLE_MOD_COLOR_1(vehicle, data.PrimaryPaintT or 0, data.PrimaryPaint or 0, data.Pearlescent or 0)
        SET_VEHICLE_MOD_COLOR_2(vehicle, data.SecondaryPaintT or 0, data.SecondaryPaint or 0)
        SET_VEHICLE_TYRE_SMOKE_COLOR(vehicle, data.SmokeR or 0, data.SmokeG or 0, data.SmokeB or 0)
        SET_VEHICLE_NEON_COLOUR(vehicle, data.NeonR or 0, data.NeonG or 0, data.NeonB or 0)
        SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle, "LANCE")
        --SET_VEHICLE_DIRT_LEVEL(vehicle, data.Dirt or 0)
        SET_VEHICLE_ENVEFF_SCALE(vehicle, data.PaintFade or 0)
        SET_VEHICLE_WHEEL_TYPE(vehicle, data.Wheels or 0)
        SET_VEHICLE_EXTRA_COLOURS(vehicle, data.Pearlescent or 0, data.WheelsColor or 0)
        SET_VEHICLE_WINDOW_TINT(vehicle, data.WindowTint or 0)
        SET_VEHICLE_EXTRA_COLOUR_6(vehicle, data.DashColor)
        SET_VEHICLE_EXTRA_COLOUR_5(vehicle, data.DashLightColor)

        if data.BulletProof == 1 then 
            SET_VEHICLE_TYRES_CAN_BURST(vehicle, false)
        end
        if data.NeonEnabled == 1 then
            for i=1, 4 do 
                SET_VEHICLE_NEON_ENABLED(vehicle, i, true)
            end
        end

        for i=0, 48 do
            if data[i] ~= nil then 
                SET_VEHICLE_MOD(vehicle, i, data[i], data.CustomTyres)
            end
        end

        for i=17, 22 do 
            TOGGLE_VEHICLE_MOD(vehicle, i, if data['TOGGLE_' .. i] == 1 then true else false)
        end

        for i=1, 9 do 
            SET_VEHICLE_EXTRA(vehicle, i, if data['Extra_' .. i] == 0 then true else false)
        end

    elseif ini_type == 4 then 
        util.toast("This INI is only partially supported. Sorry if things look weird or some things are missing.")
        local v_root = data['Vehicle' .. veh_index]
        local v_mods = data['Vehicle' .. veh_index .. "Mods"]
        local v_extras = data['Vehicle' .. veh_index .. "Extras"]
        local v_toggles = data['Vehicle' .. veh_index .. "Toggles"]
        local v_smoke = data['Vehicle' .. veh_index .. "TireSmoke"]
        local v_neon = data['Vehicle' .. veh_index .. "Neon"]
        local v_neon_color = data['Vehicle' .. veh_index .. "NeonColor"]
        local v_paintfade = data['Vehicle' .. veh_index .. "PaintFade"]
        local v_color_main = data['Vehicle' .. veh_index .. "VehicleColors"]
        local v_color_extra = data['Vehicle' .. veh_index .. "ExtraColors"]
        local v_color_custom_p = data['Vehicle' .. veh_index .. "CustomPrimaryColor"]
        local v_color_custom_s = data['Vehicle' .. veh_index .. "CustomSecondaryColor"]
        local v_wheel_type = data['Vehicle' .. veh_index .. "WheelType"]
        local v_plate = data['Vehicle' .. veh_index .. "Numberplate"]
        local v_window_tint = data['Vehicle' .. veh_index .. "WindowTint"]
        local v_is_custom_primary = data['Vehicle' .. veh_index .. "IsCustomPrimary"]
        local v_is_custom_secondary = data['Vehicle' .. veh_index .. "IsCustomSecondary"]
        local data = data['Vehicle' .. veh_index]

        for i=0, 49 do
            if data['M' .. tostring(i)] ~= nil then 
                SET_VEHICLE_MOD(vehicle, i, v_mods['M' .. i], false)
            end
        end

        for i=0, 49 do 
            TOGGLE_VEHICLE_MOD(vehicle, i, v_toggles['T' .. i])
        end

        for i=1, 13 do 
            SET_VEHICLE_EXTRA(vehicle, i, v_extras['E' .. i])
        end

        for i=1, 4 do 
            SET_VEHICLE_NEON_ENABLED(vehicle, i, v_neon["Enabled" .. i])
        end

        SET_ENTITY_DYNAMIC(vehicle, v_root.Dynamic)
        SET_ENTITY_VISIBLE(vehicle, v_root.Visible, 0)
        SET_VEHICLE_COLOURS(vehicle, v_color_main.Primary or 0, v_color_main.Secondary or 0)
        if v_is_custom_primary['bool'] then 
            SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(v_color_custom_p.r or 0, v_color_custom_p.g or 0, v_color_custom_p.b or 0)
        end

        if v_is_custom_secondary['bool'] then 
            SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(v_color_custom_s.r or 0, v_color_custom_s.g or 0, v_color_custom_s.b or 0)
        end

        SET_VEHICLE_EXTRA_COLOURS(vehicle, v_color_extra.Pearl or 0, v_color_extra.Wheel or 0)

    
        SET_VEHICLE_TYRE_SMOKE_COLOR(vehicle, v_smoke.R or 0, v_smoke.G or 0, v_smoke.B or 0)
        SET_VEHICLE_NEON_COLOUR(vehicle, v_neon_color.R or 0, v_neon_color.G or 0, v_neon_color.B or 0)
        SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle, "LANCE")
        --SET_VEHICLE_DIRT_LEVEL(vehicle, data.Dirt or 0)
        SET_VEHICLE_ENVEFF_SCALE(vehicle, v_paintfade.PaintFade or 0)
        SET_VEHICLE_WHEEL_TYPE(vehicle, v_wheel_type or 0)
        SET_VEHICLE_WINDOW_TINT(vehicle, v_window_tint or 0)
        SET_ENTITY_INVINCIBLE(vehicle, v_root.Invincible or false)
        SET_ENTITY_HAS_GRAVITY(vehicle, v_root.Gravity or true)
        FREEZE_ENTITY_POSITION(vehicle, v_root.Freeze or false)
        SET_ENTITY_RENDER_SCORCHED(vehicle, v_root.ScorchedRender or false)
        if v_root.Alpha ~= 255 and v_root.Alpha ~= nil then
            SET_ENTITY_ALPHA(vehicle, v_root.Alpha, false)
        end
        SET_VEHICLE_DIRT_LEVEL(vehicle, v_root.Dirt or 0.0) 
        SET_VEHICLE_ENGINE_ON(vehicle, v_root.IsEngineOn, true, false)
        SET_VEHICLE_LIGHT_MULTIPLIER(vehicle, v_root.HeadlightMultiplier or 1.0)
    end
end

function tprint (tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
      formatting = string.rep("  ", indent) .. k .. ": "
      if type(v) == "table" then
        print(formatting)
        tprint(v, indent+1)
      elseif type(v) == 'boolean' then
        print(formatting .. tostring(v))      
      else
        print(formatting .. v)
      end
    end
  end

function ini_load_vehicle(file_name)
    local data
    success, data = pcall(iniparser.parse, file_name, vehicles_dir)
    if not success then 
        util.toast("Something bad happened when trying to load this INI! Please check the INI file and try again. ")
    end
    local all_entities = {}
    local ini_type = -1
    -- determine type of ini file 
    -- type 1 has no spaces in it (i.e Airship.xml). 
    -- type 2 does and has  lowercase shit (420 Hydra.ini). it's also extremely stupid
    -- type 3 is extremely similar to type 1, but has values like PrimaryPaintT (BayWatch Blazer.xml)
    -- type 4 has an "AllObjects", "AllPeds", "AllVehicles" section in the ini (4tire_bike.ini)
    -- type 5 has AllObjects and AllVehicles (Boat-fsx.ini) (seems like theres an iniparser glitch in this one)
    -- type 6 is like type 2, but some keys are different, namely the numbers for attachments are called "Attached Object x" (Tankamid.ini)

    if data.Vehicle.model == nil and data.Vehicle.PrimaryPaintT == nil and data.AllVehicles.Count == nil then 
        ini_type = 1
    elseif data.Vehicle.model ~= nil and data['Attached Object 1'].model == nil then 
        ini_type = 2
    elseif data.Vehicle.model == nil and data.Vehicle.PrimaryPaintT ~= nil then 
        ini_type = 3
    elseif data.AllObjects.Count ~= nil and data.AllVehicles.Count ~= nil and data.AllPeds.Count ~= nil then 
        ini_type = 4
    elseif data.Vehicle.model ~= nil and data['Attached Object 1'].model ~= nil then 
        ini_type = 6
    end


    if ini_type == -1 then
        util.toast("This ini type is not supported (yet??)! Sorry :(")
        return
    end
    -- there is also an ini type 6...
    local initial_vehicle
    local v_count = 1
    local success = false
    if ini_type == 1 then 
        local v_hash = data['Vehicle']['Model']
        if v_hash == nil then 
            util.toast(fail_text)
            return
        end
        local c = players.get_position(players.user())
        request_model_load(v_hash)
        initial_vehicle = entities.create_vehicle(v_hash, c, GET_ENTITY_HEADING(players.user_ped()))
        all_entities[#all_entities+1] = initial_vehicle
        ini_preprocess_vehicle(initial_vehicle, data['Vehicle'], ini_type)
        local attachment_index = 0
        while true do 
            if data[tostring(attachment_index)].Model == nil then 
                success = true
                break
            end
            local here = data[tostring(attachment_index)]
            request_model_load(here.Model)
            local this_ent = entities.create_object(here.Model, players.get_position(players.user()))
            all_entities[#all_entities+1] = this_ent
            if this_ent ~= nil then
                ATTACH_ENTITY_TO_ENTITY(this_ent, initial_vehicle, here['Bone'], here['X'], here['Y'], here['Z'], here['RotX'], here['RotY'], here['RotZ'], true, if here['Collision'] == 1 then true else false, true, false, 2, true)
                if here['Froozen'] == 1 then 
                    FREEZE_ENTITY_POSITION(this_ent, true)
                end

                if here['Lit'] == 1 then 
                    START_ENTITY_FIRE(this_ent)
                end
                attachment_index = attachment_index + 1
            end
        end
    elseif ini_type == 2 then
        local v_hash = data.Vehicle.model
        if v_hash == nil then 
            util.toast(fail_text)
            return
        end
        local c = players.get_position(players.user())
        request_model_load(v_hash)
        initial_vehicle = entities.create_vehicle(v_hash, c, GET_ENTITY_HEADING(players.user_ped()))
        all_entities[#all_entities+1] = initial_vehicle
        ini_preprocess_vehicle(initial_vehicle, data, ini_type)
        local attachment_index = 0
        while true do 
            if data[tostring(attachment_index)].model == nil then 
                success = true
                break
            end
            local here = data[tostring(attachment_index)]
            request_model_load(here.model)
            local this_ent = entities.create_object(here.model, players.get_position(players.user()))
            if this_ent ~= nil then
                all_entities[#all_entities+1] = this_ent
                ATTACH_ENTITY_TO_ENTITY(this_ent, initial_vehicle, 0, here['x'], here['y'], here['z'], here['RotX'], here['RotY'], here['RotZ'], true, false, true, false, 2, true)
                attachment_index = attachment_index + 1
            end
        end

    elseif ini_type == 3 then
        local v_hash = data.Vehicle.Model
        if v_hash == nil then 
            util.toast(fail_text)
            return
        end
        local c = players.get_position(players.user())
        request_model_load(v_hash)
        initial_vehicle = entities.create_vehicle(v_hash, c, GET_ENTITY_HEADING(players.user_ped()))
        all_entities[#all_entities+1] = initial_vehicle
        ini_preprocess_vehicle(initial_vehicle, data.Vehicle, ini_type)
        local attachment_index = 0
        while true do 
            if data[tostring(attachment_index)].Model == nil then 
                success = true
                break
            end
            local here = data[tostring(attachment_index)]
            request_model_load(here.Model)
            local this_ent = entities.create_object(here.Model, players.get_position(players.user()))
            if this_ent ~= nil then
                all_entities[#all_entities+1] = this_ent
                ATTACH_ENTITY_TO_ENTITY(this_ent, initial_vehicle, 0, here['X'], here['Y'], here['Z'], here['RotX'], here['RotY'], here['RotZ'], true, false, true, false, 2, true)
                attachment_index = attachment_index + 1
            end
        end
    
    elseif ini_type == 4 then 
        local numerations = {}
        local attachments_data = {}
        local veh_index = 0
        local object_index = 0 
        local ped_index = 0
        while true do
            if data['Vehicle' .. tostring(veh_index)].Hash == nil then 
                success = true
                break
            end
            local here = data['Vehicle' .. tostring(veh_index)]
            if here.Hash == nil then 
                util.toast(fail_text)
                return
            end
            request_model_load(here.Hash)
            local this_vehicle = entities.create_vehicle(here.Hash, players.get_position(players.user()), GET_ENTITY_HEADING(players.user_ped()))
            if veh_index == 0 then 
                initial_vehicle = this_vehicle
            end
            numerations[here.SelfNumeration] = this_vehicle
            if here.IsAttached then
                attachments_data[here.SelfNumeration] = {attachee = this_vehicle, attached_to = here.AttachNumeration, x = here.OffsetX, y = here.OffsetY, z = here.OffsetZ, pitch = here.Pitch, yaw = here.Yaw, roll = here.Roll, bone = here.Bone, collision = here.Collision}
            end
            all_entities[#all_entities+1] = this_vehicle
            ini_preprocess_vehicle(this_vehicle, data, ini_type, veh_index)
            veh_index = veh_index + 1
        end

        while true do
            if data['Object' .. tostring(object_index)].Hash == nil then 
                success = true
                break
            end
            local here = data['Object' .. tostring(object_index)]
            request_model_load(here.Hash)
            local this_object = entities.create_object(here.Hash, players.get_position(players.user()))
            numerations[here.SelfNumeration] = this_object
            if here.IsAttached then
                attachments_data[here.SelfNumeration] = {attachee = this_object, attached_to = here.AttachNumeration, x = here.OffsetX, y = here.OffsetY, z = here.OffsetZ, pitch = here.Pitch, yaw = here.Yaw, roll = here.Roll, bone = here.Bone, collision = here.Collision}
            end
            all_entities[#all_entities+1] = this_object
            SET_ENTITY_DYNAMIC(veh, here.Dynamic)
            SET_ENTITY_VISIBLE(veh, here.Visible) 
            SET_ENTITY_HAS_GRAVITY(veh, here.Gravity)
            FREEZE_ENTITY_POSITION(veh, here.Freeze)
            object_index = object_index + 1
        end

        for k,v in pairs(attachments_data) do
            if v.attachee ~= nil and numerations[v.attached_to] ~= nil then
                ATTACH_ENTITY_TO_ENTITY(v.attachee, numerations[v.attached_to], v.Bone, v.x, v.y, v.z, v.pitch, v.roll, v.yaw, true, false, v.collision, false, 2, true)
            end
        end

    elseif ini_type == 6 then 
        local v_hash = data.Vehicle.model
        local c = players.get_position(players.user())
        if v_hash == nil then 
            util.toast(fail_text)
            return
        end
        request_model_load(v_hash)
        initial_vehicle = entities.create_vehicle(v_hash, c, GET_ENTITY_HEADING(players.user_ped()))
        all_entities[#all_entities+1] = initial_vehicle
        ini_preprocess_vehicle(initial_vehicle, data, ini_type)
        local attachment_index = 1
        while true do 
            if data['Attached Object ' .. tostring(attachment_index)].model == nil then 
                success = true
                break
            end
            local here = data['Attached Object ' .. tostring(attachment_index)]
            request_model_load(here.model)
            local this_ent = entities.create_object(here.model, players.get_position(players.user()))
            all_entities[#all_entities+1] = this_ent
            if this_ent ~= nil then
                ATTACH_ENTITY_TO_ENTITY(this_ent, initial_vehicle, 0, here['x offset'], here['y offset'], here['z offset'], here['pitch'], here['roll'], here['yaw'], true, false, if here['collision'] == 1 then true else false, false, 2, true)
                attachment_index = attachment_index + 1
            end
        end
    end

    if success then
        SET_PED_INTO_VEHICLE(players.user_ped(), initial_vehicle, -1)
        local this_veh_root = menu.list(loaded_vehicles_root, file_name, {"lancespoonerv" .. initial_vehicle}, "")

        local this_blip = ADD_BLIP_FOR_ENTITY(initial_vehicle)
        SET_BLIP_SPRITE(this_blip, 77)
        SET_BLIP_COLOUR(this_blip, 47)

        menu.action(this_veh_root, "Delete", {"deletelancespoonerv" .. initial_vehicle}, "Delete this vehicle. Make it cease to exist.", function(on_click)
            for k,v in pairs(all_entities) do
                entities.delete_by_handle(v)
            end
            menu.delete(this_veh_root)
            util.remove_blip(this_blip)
        end)

        menu.action(this_veh_root, "Teleport inside", {"teleportemenyoov" .. initial_vehicle}, "", function(on_click)
            SET_PED_INTO_VEHICLE(PLAYER_PED_ID(), initial_vehicle, -1)
        end)

    else
        util.toast(fail_text)
    end
end

function json_preprocess_vehicle(vehicle, data, initial_vehicle)
    local sd = data.savedata
    local mods = sd.Mods
    if vehicle ~= initial_vehicle then
        if data.data ~= nil then 
            -- for the updated edition
            SET_ENTITY_VISIBLE(vehicle, data.data.visible, 0)
            SET_ENTITY_INVINCIBLE(vehicle, data.data.godmode)
        else
            if sd.godmode ~= nil then
                SET_ENTITY_INVINCIBLE(vehicle, sd.godmode)
            end
            SET_ENTITY_VISIBLE(vehicle, data.visible, 0)
        end
    else
        if data.godmode ~= nil then
            SET_ENTITY_INVINCIBLE(vehicle, data.godmode)
        end
        if data.visible ~= nil then
            SET_ENTITY_VISIBLE(vehicle, data.visible, 0)
        end
    end

    if vehicle ~= initial_vehicle then 
        ATTACH_ENTITY_TO_ENTITY(vehicle, initial_vehicle, 0, data.offset.x, data.offset.y, data.offset.z, data.rotation.x, data.rotation.y, data.rotation.z, true, false, true, false, 2, true)
    end

    -- for some reason jackz used the name of the mod instead of the mod index / mod type lol
    -- otherwise, this code couldve taken up just 3 lines
    -- not like i couldnt have used a table, but still, come on...
    SET_VEHICLE_TYRE_SMOKE_COLOR(vehicle, sd['Tire Smoke'].r, sd['Tire Smoke'].g, sd['Tire Smoke'].b)
    SET_VEHICLE_MOD(vehicle, 0, mods['Spoilers'], false)
    SET_VEHICLE_MOD(vehicle, 1, mods['Ornaments'], false)
    SET_VEHICLE_MOD(vehicle, 2, mods['Front Bumper'], false)
    SET_VEHICLE_MOD(vehicle, 3, mods['Side Skirt'], false)
    SET_VEHICLE_MOD(vehicle, 4, mods['Exhaust'], false)
    SET_VEHICLE_MOD(vehicle, 5, mods['Frame'], false)
    SET_VEHICLE_MOD(vehicle, 6, mods['Grille'], false)
    SET_VEHICLE_MOD(vehicle, 7, mods['Hood'], false)
    SET_VEHICLE_MOD(vehicle, 8, mods['Fender'], false)
    SET_VEHICLE_MOD(vehicle, 9, mods['Right Fender'], false)
    SET_VEHICLE_MOD(vehicle, 10, mods['Roof'], false)
    SET_VEHICLE_MOD(vehicle, 11, mods['Engine'], false)
    SET_VEHICLE_MOD(vehicle, 12, mods['Brakes'], false)
    SET_VEHICLE_MOD(vehicle, 13, mods['Transmission'], false)
    SET_VEHICLE_MOD(vehicle, 14, mods['Horns'], false)
    SET_VEHICLE_MOD(vehicle, 15, mods['Suspension'], false)
    SET_VEHICLE_MOD(vehicle, 16, mods['Armor'], false)
    -- no front wheels in spec? lol?
    --SET_VEHICLE_MOD(vehicle, 23, mods['Front Wheels'], false)
    SET_VEHICLE_MOD(vehicle, 24, mods["Motorcycle Back Wheel Design"], false)
    SET_VEHICLE_MOD(vehicle, 25, mods['Plate Holders'], false)
    SET_VEHICLE_MOD(vehicle, 27, mods['Trim Design'], false)
    SET_VEHICLE_MOD(vehicle, 28, mods['Ornaments'], false)
    SET_VEHICLE_MOD(vehicle, 28, mods['Ornaments'], false)
    SET_VEHICLE_MOD(vehicle, 30, mods['Dial Design'], false)
    SET_VEHICLE_MOD(vehicle, 33, mods['Steering Wheel'], false)
    SET_VEHICLE_MOD(vehicle, 34, mods['Shifter Leavers'], false)
    SET_VEHICLE_MOD(vehicle, 35, mods['Plaques'], false)
    SET_VEHICLE_MOD(vehicle, 36, mods['Hydraulics'], false)
    SET_VEHICLE_MOD(vehicle, 48, mods['Livery'], false)

    -- toggle 
    TOGGLE_VEHICLE_MOD(vehicle, 17, mods.Toggles.UNK17)
    -- typo here in the jackz json spec btw, not my fault :|
    TOGGLE_VEHICLE_MOD(vehicle, 18, mods.Toggles['Turbo Turning'])
    TOGGLE_VEHICLE_MOD(vehicle, 19, mods.Toggles['UNK19'])
    TOGGLE_VEHICLE_MOD(vehicle, 20, mods.Toggles['Tire Smoke'])
    TOGGLE_VEHICLE_MOD(vehicle, 21, mods.Toggles['UNK21'])
    TOGGLE_VEHICLE_MOD(vehicle, 22, mods.Toggles['Xenon Headlights'])
    -------
    SET_VEHICLE_TYRES_CAN_BURST(vehicle, not sd['Bulletproof Tires'])
    SET_VEHICLE_DIRT_LEVEL(vehicle, sd['Dirt Level'])
    SET_VEHICLE_WINDOW_TINT(vehicle, sd['Window Tint'])
    SET_VEHICLE_EXTRA_COLOUR_6(vehicle, sd['Dashboard Color'])
    for i=10, 11 do 
        SET_VEHICLE_EXTRA(vehicle, i, not sd.Extras[i])
    end
    -- lights
    SET_VEHICLE_EXTRA_COLOUR_5(vehicle, sd['Interior Color'])
    SET_VEHICLE_NEON_ENABLED(vehicle, 0, sd.Lights.Neon.Left)
    SET_VEHICLE_NEON_ENABLED(vehicle, 1, sd.Lights.Neon.Right)
    SET_VEHICLE_NEON_ENABLED(vehicle, 2, sd.Lights.Neon.Front)
    SET_VEHICLE_NEON_ENABLED(vehicle, 3, sd.Lights.Neon.back)
    SET_VEHICLE_NEON_COLOUR(vehicle, sd.Lights.Neon.Color.r, sd.Lights.Neon.Color.g, sd.Lights.Neon.Color.b) 
    SET_VEHICLE_XENON_LIGHT_COLOR_INDEX(vehicle, sd.Lights['Xenon Color'])
    SET_VEHICLE_ENGINE_ON(vehicle, sd['Engine Running'], true, false) 
    -- colors 
    local colors = sd.Colors
    -- why is there a custom rgb color in the "vehicle" colors but also in both primary and secondary fields? what is the point?
    SET_VEHICLE_COLOURS(vehicle, colors.Vehicle.Primary, colors.Vehicle.Secondary)
    if colors.Primary.Custom then 
        SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(vehicle, colors.Primary['Custom Color'].r, colors.Primary['Custom Color'].g, colors.Primary['Custom Color'].b)
    end
    if colors.Secondary.Custom then 
        SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(vehicle, colors.Secondary['Custom Color'].r, colors.Secondary['Custom Color'].g, colors.Secondary['Custom Color'].b)
    end
    SET_VEHICLE_EXTRA_COLOURS(vehicle, colors.Extras.pearlescent, colors.Extras.wheel)
    SET_VEHICLE_ENVEFF_SCALE(vehicle, colors['Paint Fade'])
    SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle, "LANCE")
end

function preprocess_constructor_vehicle(veh, data, is_initial) 
    if data.headlights.headlights_type then 
        TOGGLE_VEHICLE_MOD(veh, 22, true)
    end
    SET_VEHICLE_XENON_LIGHT_COLOR_INDEX(veh, data.headlights.headlights_color)
    -- headlights_type = false? what?
    SET_VEHICLE_ENVEFF_SCALE(veh, data.paint.fade or 0)
    --SET_VEHICLE_EXTRA_COLOUR_5(veh, colors['LrInterior'])
    SET_VEHICLE_EXTRA_COLOUR_6(veh, data.paint.dashboard_color)
    SET_VEHICLE_LIVERY(veh, data.paint.livery)
    SET_VEHICLE_DIRT_LEVEL(veh, data.paint.dirt_level)
    --SET_VEHICLE_EXTRA_COLOURS(veh, data.paint.extra_colors.pearlescent, data.paint.extra_colors.wheel)
    local any_custom_paint_used = false

    if data.paint.primary.is_custom then 
        local p_colors = data.paint.primary.custom_color
        SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(veh, p_colors.r, p_colors.g, p_colors.b)
        any_custom_paint_used = true
    end

    if data.paint.secondary.is_custom then 
        local s_colors = data.paint.secondary.custom_color
        SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(veh, s_colors.r, s_colors.g, s_colors.b)
        any_custom_paint_used = true
    end

    if not any_custom_paint_used then 
        SET_VEHICLE_COLOURS(veh, data.paint.primary.vehicle_standard_color, data.paint.secondary.vehicle_standard_color)
    end
    SET_VEHICLE_TYRE_SMOKE_COLOR(veh, data.wheels.tire_smoke_color.r, data.wheels.tire_smoke_color.g, data.wheels.tire_smoke_color.b)
    -- realistically, no tires will ever be set to be burst, and menus will 9/10 times auto-fix the car, so why do these vehicle formats insist on adding support for it lol
    SET_VEHICLE_WHEEL_TYPE(veh, data.wheels.wheel_type)
    for k,v in pairs(data.mods) do
        k = k:gsub('_', '')
        SET_VEHICLE_MOD(veh, tonumber(k), tonumber(v), true)
    end

    -- why just an empty list for neon colors and not default it to white or smth?

    SET_VEHICLE_NEON_COLOUR(veh, data.neon or 0, data.NeonG or 0, data.NeonB or 0)

    for i=0, 3 do 
        if data.neon.lights[i] then 
            SET_VEHICLE_NEON_ENABLED(veh, i, true)
        end
    end

    if data.options.bulletproof_tires == 1 then 
        SET_VEHICLE_TYRES_CAN_BURST(veh, false)
    end

    if not is_initial then
        SET_VEHICLE_NUMBER_PLATE_TEXT(veh, data.options.license_plate_text or "LANCE")
        SET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(veh, data.options.license_plate_type or 0)
        SET_ENTITY_PROOFS(veh, data.options.is_bullet_proof, data.options.is_fire_proof, data.options.is_explosion_proof, not data.options.has_collision, data.options.is_melee_proof, false, true, false)
        if not data.options.is_visible and data.options.is_visible ~= nil then 
            SET_ENTITY_VISIBLE(veh, false, false)
        end
    end
    SET_ENTITY_INVINCIBLE(veh, true)
end

local supported_jackz_versions = {'1.1.0', '1.3.0', '1.3.1', '1.4.0'}






menu.divider(fireworklist, "Settings")

fireworklistselect = menu.list_select(fireworklist, "effect", {}, "", tables.fireworktable, 2, function(index,value)
	ptfnamesel = value
end)
fireworkplacelistselect = menu.list_select(fireworklist, "Placed rocket", {}, "", tables.fireworkplacetable, 1, function(index,value)
	hashofobj = util.joaat(value)
	hashofobjname = value
end)
fireworkcolourlist = menu.colour(fireworklist, "Colour", {}, "", fireworkcolourselect, true, function(s)
	fireworkcolourselect = s
end)
menu.inline_rainbow(fireworkcolourlist)
for _, ref in pairs(menu.get_children(fireworkcolourlist)) do
	if _ == 1 then
		menu.set_value(ref, 5)
		break
	end
end
menu.toggle(fireworklist, "with animation", {}, "", function(on_toggle)
	if on_toggle then
		withanimationyes = true
	else
		withanimationyes = false
	end
end)
menu.toggle(fireworklist, "Draw Line", {}, "", function(on_toggle)
	if on_toggle then
		fireworkdrawline = true
	else
		fireworkdrawline = false
	end
end)
menu.toggle(fireworklist, "Set Rotation = 0", {}, "ON = beim paltzieren wird es auf Rotation auf 0 gestellt also guckt es perfekt nach oben\nOFF = wird es an den boden angepasst", function(on_toggle)
	if on_toggle then
		fireworksrot = true
	else
		fireworksrot = false
	end
end)
menu.toggle(fireworklist, "Random effect", {}, "macht ein random effect beim schießen\n benutzt nicht die letzten 3", function(on_toggle)
	if on_toggle then
		fireworksrandomeffect = true
	else
		fireworksrandomeffect = false
	end
end)
menu.toggle(fireworklist, "Delete after use", {}, "bei loop wird das nicht passieren", function(on_toggle)
	if on_toggle then
		fireworksdeleteafteruse = true
	else
		fireworksdeleteafteruse = false
	end
end)
menu.slider(fireworklist, "loop inverval", {"fireworkinterval"}, "Seconds",1, 20, 1, 1, function(s)
	timetowait = s*1000
end)
--[[menu.action(fireworklist, "animation", {}, "", function()
	request_anim_dict("anim@mp_fireworks")
	TASK_PLAY_ANIM(players.user_ped(), "anim@mp_fireworks", "place_firework_1_rocket", 8.0, 8.0, -1, 0, 0.0, false, false, false)
	util.yield(1000)
	repeat
		util.yield()
		keypress = isanykeypressed()
	until keypress
	CLEAR_PED_TASKS_IMMEDIATELY(players.user_ped())
end)]]

menu.action(misc, "Spawn object", {}, "spawned das object mit dem hash bei has number", function()
	local playeroffset = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +0.5, -1)
	local fireowrkpos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +0.5, +1)
	if hashnumber == nill or hashnumber != number then
	else
		util.toast(hashnumber)
		entities.create_object(hashnumber, playeroffset)
	end
	if nameofobject != nill then
		local hashofobj = util.joaat("ind_prop_firework_04")
		entities.create_object(hashofobj, playeroffset)
	end
end)

menu.text_input(misc, "name of obj", {"nameofobj"}, "", function(input)
	nameofobject = input
end, '')

menu.text_input(misc, "hash number", {"hashnumber"}, "", function(input)
	hashnumber = input
end, '')

-- settings

local Zeug_für_mich = menu.list(menu.my_root(), "Zeug für mich angepasst", {}, "muss dich nicht jucken macht zeug an was nicht so einfach mit nur einem hotkey gemacht werden kann \nwie es da steht zeug für mich selbst")

menu.toggle(Zeug_für_mich, "godmode zeug an", {}, "", function(on_toggle)
	if on_toggle then
		menu.trigger_command(menu.ref_by_path("Self>Immortality"), true)
		menu.trigger_command(menu.ref_by_path("Self>Auto Heal"), true)
		menu.trigger_command(menu.ref_by_path("Self>Gracefulness"), true)
		menu.trigger_command(menu.ref_by_path("Self>Glued To Seats"), true)
		menu.trigger_command(menu.ref_by_path("Self>Respawn Delay"), "0.50")
		menu.trigger_command(menu.ref_by_path("Self>Weapons>Skip Reloading"), true)
		menu.trigger_command(menu.ref_by_path("Self>Weapons>No Spread"), true)
		menu.trigger_command(menu.ref_by_path("Self>Weapons>No Recoil"), true)
		menu.trigger_command(menu.ref_by_path("Self>Weapons>No Spooling"), true)
		menu.trigger_command(menu.ref_by_path("Self>Movement>Graceful Landing"), true)
		menu.trigger_command(menu.ref_by_path("Self>Appearance>No Blood"), true)
		menu.trigger_command(menu.ref_by_path("Self>Appearance>Lock Wetness"), true)
		util.toast("Immortality = ON\nAuto Heal = ON\nGracefulness = ON\nGlued To Seats = ON\nSkip Reloading = ON\nNo Spread = ON\nNo Recoil = ON\nNo Spooling = ON\nGraceful Landing = ON\nNo Blood = ON\nLock Wetness = ON", TOAST_CONSOLE)
	else
		menu.trigger_command(menu.ref_by_path("Self>Immortality"), false)
		menu.trigger_command(menu.ref_by_path("Self>Auto Heal"), false)
		menu.trigger_command(menu.ref_by_path("Self>Gracefulness"), false)
		menu.trigger_command(menu.ref_by_path("Self>Glued To Seats"), false)
		menu.trigger_command(menu.ref_by_path("Self>Respawn Delay"), "0")
		menu.trigger_command(menu.ref_by_path("Self>Weapons>Skip Reloading"), false)
		menu.trigger_command(menu.ref_by_path("Self>Weapons>No Spread"), false)
		menu.trigger_command(menu.ref_by_path("Self>Weapons>No Recoil"), false)
		menu.trigger_command(menu.ref_by_path("Self>Weapons>No Spooling"), false)
		menu.trigger_command(menu.ref_by_path("Self>Movement>Graceful Landing"), false)
		menu.trigger_command(menu.ref_by_path("Self>Appearance>No Blood"), false)
		menu.trigger_command(menu.ref_by_path("Self>Appearance>Lock Wetness"), false)
		util.toast("Immortality = OFF\nAuto Heal = OFF\nGracefulness = OFF\nGlued To Seats = OFF\nSkip Reloading = OFF\nNo Spread = OFF\nNo Recoil = OFF\nNo Spooling = OFF\nGraceful Landing = OFF\nNo Blood = OFF\nLock Wetness = OFF", TOAST_CONSOLE)
	end
end)

menu.toggle(Zeug_für_mich, "schnell laufen", {}, "", function(on_toggle)
	if on_toggle then
		godmodean = menu.get_value(menu.ref_by_path("Self>Immortality"))
		anmutan = menu.get_value(menu.ref_by_path("Self>Gracefulness"))
		menu.trigger_command(menu.ref_by_path("Self>Immortality"), true)
		menu.trigger_command(menu.ref_by_path("Self>Gracefulness"), true)
		menu.trigger_command(menu.ref_by_path("Self>Movement>Super Run"), "2")
	else
		menu.trigger_command(menu.ref_by_path("Self>Movement>Super Run"), "0")
		menu.trigger_command(menu.ref_by_path("Self>Movement>Freeze"), true)
		menu.trigger_command(menu.ref_by_path("Self>Movement>Freeze"), false)
		menu.trigger_command(menu.ref_by_path("Self>Immortality"), godmodean)
		menu.trigger_command(menu.ref_by_path("Self>Gracefulness"), anmutan)
	end
end)

menu.toggle_loop(Zeug_für_mich, "Ist Unsichtbarkeit an", {}, "", function()
	if menu.get_value(menu.ref_by_path("Self>Appearance>Invisibility")) == 1 then
		util.draw_debug_text("Unsichtbarkeit ist an")
	end
end)

menu.toggle(Zeug_für_mich, "Unsichitbarkeit an/aus", {}, "", function(on_toggle)
	if on_toggle then
		menu.set_value(menu.ref_by_path("Self>Appearance>Invisibility"), 1)
	else
		menu.set_value(menu.ref_by_path("Self>Appearance>Invisibility"), 0)
	end
end)

menu.toggle_loop(vehicle, "Schnell fahren V2 (besser)", {}, "", function()
	keyCode = getKeyCode('VK_W')
	keyCode1 = getKeyCode('VK_S')
	vehicle = GET_VEHICLE_PED_IS_IN(players.user_ped())
	currentSpeed = GET_ENTITY_SPEED(vehicle)
	umrechnung = a / 10
	if util.is_key_down(keyCode) and IS_PED_IN_ANY_VEHICLE(players.user_ped()) then
		APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(vehicle, 1, 0.0, umrechnung, 0.0, true, true, true, true)
	elseif util.is_key_down(keyCode1) and IS_PED_IN_ANY_VEHICLE(players.user_ped()) then
		APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(vehicle, 1, 0.0, -umrechnung, 0.0, true, true, true, true)
	end
end)

menu.slider(vehicle, "Schnell fahren boost einstellen V2", {"selfspeedboost"}, "[0 - 50]\nDamit wird die stärke eingestellt wie stark es dich boosten soll", 1,50, 1, 1, function(boost)
	a = boost
end)

menu.click_slider(vehicle, "speed boost", {"selfboostsset"}, "[50 - 10000]\ngib die kmh an auf die es boosten soll", 50 ,10000, 0, 50, function(s)
	speed = s
	speedset = s / 3.6
	vehicle = GET_VEHICLE_PED_IS_IN(players.user_ped())
	if IS_PED_IN_ANY_VEHICLE(players.user_ped()) then
		SET_VEHICLE_FORWARD_SPEED(vehicle, speedset)
	end
end)

menu.action(vehicle, "sofort anhalten", {}, "", function()
	vehicle = GET_VEHICLE_PED_IS_IN(players.user_ped())
	if IS_PED_IN_ANY_VEHICLE(players.user_ped(),true) then
		FREEZE_ENTITY_POSITION(vehicle, true)
		FREEZE_ENTITY_POSITION(vehicle, false)
	else
		menu.trigger_command(menu.ref_by_path("Self>Movement>Freeze"), true)
		menu.trigger_command(menu.ref_by_path("Self>Movement>Freeze"), false)
	end
end)

menu.action(vehicle,"Auto Reparieren", {}, "", function()
	vehicle = entities.get_user_vehicle_as_handle(true)
	currentSpeed = GET_ENTITY_SPEED(vehicle)
	seatplayer = GET_PED_IN_VEHICLE_SEAT(vehicle, -1, true)
	menu.trigger_commands("fixvehicle")
	if currentSpeed >= 80 and seatplayer == players.user_ped() then
		SET_VEHICLE_FORWARD_SPEED(vehicle, currentSpeed)
	end

end)

timer2 = 0
menu.toggle_loop(vehicle, "instant veh enter/exit", {}, "halte F gedrückt dann setzt du dich in das auto was dir am nächsten ist in den settings kann man auswählen wie lange man drücken soll", function()
if not util.is_session_transition_active() then
	local keyCode = getKeyCode("VK_F")
	playernameself = players.get_name(players.user())
	myposition = players.get_position(players.user())
	mypositionvehicle = getClosestVehicle(myposition)
	if not mypositionvehicle then
		goto stop
	else
		vehhash = entities.get_model_hash(mypositionvehicle)
		vehiclename = getmodelnamebyhash(vehhash)
	end
	ped = GET_PED_IN_VEHICLE_SEAT(mypositionvehicle, -1, true)
	missionped = IS_ENTITY_A_MISSION_ENTITY(ped)
	speedofvehicle = GET_ENTITY_SPEED(mypositionvehicle)
	flyingvehicle = IS_PED_IN_FLYING_VEHICLE(players.user_ped())
	--doorindex = GET_ENTITY_BONE_INDEX_BY_NAME(mypositionvehicle, "handle_dside_f")
	--doorindex2 = GET_ENTITY_BONE_INDEX_BY_NAME(mypositionvehicle, "handle_dside_r")
	--doorindex3 = GET_ENTITY_BONE_INDEX_BY_NAME(mypositionvehicle, "handle_pside_f")
	--doorindex4 = GET_ENTITY_BONE_INDEX_BY_NAME(mypositionvehicle, "handle_pside_r")
	positionoffset = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(mypositionvehicle, -2, 0, 0)
	--doorpositionleftfront = GET_ENTITY_BONE_POSTION(mypositionvehicle, doorindex)
	--doorpositionleftback = GET_ENTITY_BONE_POSTION(mypositionvehicle, doorindex2)
	--doorpositionrightfront = GET_ENTITY_BONE_POSTION(mypositionvehicle, doorindex3)
	--doorpositionrightback = GET_ENTITY_BONE_POSTION(mypositionvehicle, doorindex4)
	local seatofplayer = getseatofplayer(mypositionvehicle)
	local personalveh = entities.get_user_personal_vehicle_as_handle(players.user())
	timer1 = 0
	if not IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then --and not (GET_IS_TASK_ACTIVE(ped, 160)) then
		if infoofveh then
			util.draw_debug_text(vehiclename)
			util.draw_debug_text(getvehtype(vehhash))
			if personalveh == mypositionvehicle then
				util.draw_debug_text("PERSONALVEHICLE")
			end
		end
	while util.is_key_down(keyCode) do
		if infoofveh then
			util.draw_debug_text(vehiclename)
			util.draw_debug_text(getvehtype(vehhash))
			if personalveh == mypositionvehicle then
				util.draw_debug_text("PERSONALVEHICLE")
			end
		end
		timer1 += 1
		if timer1 == abb and util.is_key_down(keyCode) then
			util.toast("enter vehicle")
			menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>ENTER"), true)
			menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>VEH_EXIT"), true)
			timer1 = 0
		if IS_PED_A_PLAYER(ped) and not (ped == players.user_ped()) then
			pid = GET_NEAREST_PLAYER_TO_ENTITY(ped)
			local getplayername = players.get_name(pid)
			if not ifplayerincar then
				if ARE_ANY_VEHICLE_SEATS_FREE(mypositionvehicle) then
					if IS_VEHICLE_SEAT_FREE(mypositionvehicle, 0) then
						SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, 0)
						levideaktivate()
					elseif  IS_VEHICLE_SEAT_FREE(mypositionvehicle, 1) then
						SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, 1)
						levideaktivate()
					elseif  IS_VEHICLE_SEAT_FREE(mypositionvehicle, 2) then
						SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, 2)
						levideaktivate()
					elseif  IS_VEHICLE_SEAT_FREE(mypositionvehicle, 3) then
						SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, 3)
						levideaktivate()
					elseif  IS_VEHICLE_SEAT_FREE(mypositionvehicle, 4) then
						SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, 4)
						levideaktivate()
					else
						util.toast("konnte dich in keinen sitz setzen")
						repeat
							util.yield()
						until not util.is_key_down(keyCode)
						menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>VEH_EXIT"), false)
						menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>ENTER"), false)
						break
					end
					repeat
						util.yield()
					until not util.is_key_down(keyCode)
					menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>VEH_EXIT"), false)
					menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>ENTER"), false)
					break
				else
					util.toast("es sind keine sitze frei")
					repeat
						util.yield()
					until not util.is_key_down(keyCode)
					menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>VEH_EXIT"), false)
					menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>ENTER"), false)
					break
				end
			else
				menu.trigger_commands("vehkick ".. getplayername)
					if not IS_VEHICLE_SEAT_FREE(mypositionvehicle, -1) then
						repeat
							util.yield()
							timer2 +=1
								if timer2 == 100 then
									util.toast("er konnte nicht aus dem auto gekickt werden")
									timer2 = 0
									menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>VEH_EXIT"), false)
									menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>ENTER"), false)
									break
								end
						until IS_VEHICLE_SEAT_FREE(mypositionvehicle, -1)
							SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, -1)
							levideaktivate()
							repeat
								util.yield()
							until not util.is_key_down(keyCode)
							menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>VEH_EXIT"), false)
							menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>ENTER"), false)
							break
						end
					end
		else
			if not ifnpcincar then
				if not (ped == 0) and not (players.user_ped() == ped) then
					if missionnpc then
						if missionped then
							SET_ENTITY_COORDS_NO_OFFSET(ped, doorpositionleftfront, false, false, false)
							pedpos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, -3, 0, 0)
							SET_ENTITY_COORDS_NO_OFFSET(ped, pedpos.x, pedpos.y, pedpos.z, false, false, false)
						else
		   					entities.delete_by_handle(ped)
						end
					end
					SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, -1)
					levideaktivate()
				else
					SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, -1)
					levideaktivate()
					SET_VEHICLE_ENGINE_ON(mypositionvehicle, true, true, true)
				end
				repeat
					util.yield()
				until not util.is_key_down(keyCode)
				menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>VEH_EXIT"), false)
				menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>ENTER"), false)
				break
			else
				if ARE_ANY_VEHICLE_SEATS_FREE(mypositionvehicle) then
					if IS_VEHICLE_SEAT_FREE(mypositionvehicle, -1) then
						SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, -1)
						levideaktivate()
					elseif IS_VEHICLE_SEAT_FREE(mypositionvehicle, 0) then
						SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, 0)
						levideaktivate()
					elseif  IS_VEHICLE_SEAT_FREE(mypositionvehicle, 1) then
						SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, 1)
						levideaktivate()
					elseif  IS_VEHICLE_SEAT_FREE(mypositionvehicle, 2) then
						SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, 2)
						levideaktivate()
					elseif  IS_VEHICLE_SEAT_FREE(mypositionvehicle, 3) then
						SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, 3)
						levideaktivate()
					elseif  IS_VEHICLE_SEAT_FREE(mypositionvehicle, 4) then
						SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, 4)
						levideaktivate()
					else
						util.toast("konnte dich in keinen sitz setzen")
						repeat
							util.yield()
						until not util.is_key_down(keyCode)
						menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>VEH_EXIT"), false)
						menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>ENTER"), false)
						break
					end
					repeat
						util.yield()
					until not util.is_key_down(keyCode)
					menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>VEH_EXIT"), false)
					menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>ENTER"), false)
					break
				else
					util.toast("es sind keine sitze frei")
					repeat
						util.yield()
					until not util.is_key_down(keyCode)
					menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>VEH_EXIT"), false)
					menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>ENTER"), false)
					break
				end
			end
		end
		end
		util.yield()
	end
	else
		timer1 = 0
		while util.is_key_down(keyCode) do
			timer1 += 1
			util.yield()
			if timer1 == bba and util.is_key_down(keyCode) then
				menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>ENTER"), true)
				menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>VEH_EXIT"), true)
				util.toast("exit vehicle")
				--util.toast(doorindex .."        /     "..doorindex2.. "  /   "..doorindex3.."  /   "..doorindex4.."   /  "..seatofplayer)
				if not engineoff then
					SET_VEHICLE_ENGINE_ON(mypositionvehicle, false, true, true)
				end
				if stoponexit and not flyingvehicle then
					BRING_VEHICLE_TO_HALT(mypositionvehicle, 0, 1, false)
				end
				local seatofplayers = getseatofplayer(mypositionvehicle)
				local entryposition = GET_ENTRY_POINT_POSITION(mypositionvehicle, 0)
				if seatofplayers != -2 then
					entryposition = GET_ENTRY_POINT_POSITION(mypositionvehicle, seatofplayers + 1)
				end
				--util.toast(entryposition.x.. "  "..entryposition.y.. "  "..entryposition.z.. "  ".. seatofplayers)
				if not checkexitpoint then
					if entryposition.x != 0.0 and entryposition.y != 0.0 and entryposition.z != 0.0 then
						if groundspawn then
							entryposition.z = get_ground_z(entryposition) + 1
						end
						SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), entryposition.x, entryposition.y, entryposition.z, false, false, false)
					else
						util.toast("Solltest du diese benachichtigung bekommen ist was falsch gelaufen beim suchen der sitz position bitte sag mir bescheid wenn du das hier bekommst und welches fahrzeug benutzt wurde dabei", TOAST_ALL)
					end
				else
					if IS_ENTRY_POINT_FOR_SEAT_CLEAR(players.user_ped(), mypositionvehicle, seatofplayers, false, false) or IS_ENTRY_POINT_FOR_SEAT_CLEAR(players.user_ped(), mypositionvehicle, seatofplayers, true, false) then
						if entryposition.x != 0.0 and entryposition.y != 0.0 and entryposition.z != 0.0 then
							if groundspawn then
								entryposition.z = get_ground_z(entryposition) + 1
							end
							SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), entryposition.x, entryposition.y, entryposition.z, false, false, false)
						else
							util.toast("Solltest du diese benachichtigung bekommen ist was falsch gelaufen beim suchen der sitz position bitte sag mir bescheid wenn du das hier bekommst und welches fahrzeug benutzt wurde dabei", TOAST_ALL)
						end
					else
						local maxPassengers = GET_VEHICLE_MAX_NUMBER_OF_PASSENGERS(mypositionvehicle)
						local freeseat = false
						for i=-1, maxPassengers do
							if IS_ENTRY_POINT_FOR_SEAT_CLEAR(players.user_ped(), mypositionvehicle, i, false, false) then
								freeseat = i
								break
							end
						end
							if freeseat != false then
								local entryposition = GET_ENTRY_POINT_POSITION(mypositionvehicle, freeseat + 1)
								if entryposition.x != 0.0 and entryposition.y != 0.0 and entryposition.z != 0.0 then
									if groundspawn then
										entryposition.z = get_ground_z(entryposition) + 1
									end
									SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), entryposition.x, entryposition.y, entryposition.z, false, false, false)
								else
									util.toast("Solltest du diese benachichtigung bekommen ist was falsch gelaufen beim suchen der sitz position bitte sag mir bescheid wenn du das hier bekommst und welches fahrzeug benutzt wurde dabei", TOAST_ALL)
								end
							else
								local playersposition = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, +3, 0)
								if groundspawn then
									playersposition.z = get_ground_z(playersposition) + 1
								end
								SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), playersposition.x, playersposition.y, playersposition.z, false, false, false)
							end
					end
				end
				repeat
					util.yield()
				until not util.is_key_down(keyCode)
				menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>VEH_EXIT"), false)
				menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>ENTER"), false)
				break
				--TASK_LEAVE_VEHICLE(players.user_ped(), mypositionvehicle, 16)
			end
		end
	end
	::stop::
end
end)

--[[menu.slider(Zeug_für_mich, "Schnell fahren boost einstellen", {"selfspeedboost"}, "[0 - 20]\ngib die kmh an auf die es boosten soll", 0 ,20, 0, 1, function(a)
	boost = a
end)]]

menu.toggle_loop(vehicle, "radio immer aus", {}, "", function()
	if IS_PED_IN_ANY_VEHICLE(players.user_ped(), true) then
		SET_RADIO_TO_STATION_NAME("OFF")
	end
end)

menu.toggle_loop(vehicle, "Tempo anzeige nur im auto", {}, "macht die anzeige an wenn du im auto bist", function()
	if IS_PED_IN_ANY_VEHICLE(players.user_ped(), true) then
		menu.trigger_command(menu.ref_by_path("Vehicle>AR Speedometer>AR Speedometer"), true)
	else
		menu.trigger_command(menu.ref_by_path("Vehicle>AR Speedometer>AR Speedometer"), false)
	end
	on_stop = menu.trigger_command(menu.ref_by_path("Vehicle>AR Speedometer>AR Speedometer"), false)
end)

menu.click_slider_float(vehicle, "Top speed modifyer", {"modifytopspeed"}, "", 0 ,20000, 0, 500, function(s)
	s = s / 10
	MODIFY_VEHICLE_TOP_SPEED(GET_VEHICLE_PED_IS_IN(players.user_ped(), true), s)
end)

menu.toggle_loop(Zeug_für_mich, "nach loaden auto spawnen", {}, "", function()
	if util.is_session_transition_active() then
		repeat 
			util.yield()
		until not util.is_session_transition_active()
		util.yield(3000)
		persoveh = entities.get_user_personal_vehicle_as_handle()
		if persoveh == -1 then
			menu.trigger_commands("claimallvehicles")
		end
	end
end)

menu.toggle_loop(Zeug_für_mich, "alle waffen immer", {}, "", function()
	if not util.is_session_transition_active() then
		util.yield(5000)
		if not HAS_PED_GOT_WEAPON(players.user_ped(),911657153,false) then
			util.toast("alle waffen wurden gegeben")
			menu.trigger_commands("allguns")
		end
	end
end)

timer5 = 1
menu.toggle_loop(Zeug_für_mich, "legit wanted level remove", {}, "", function()
	if IS_PLAYER_WANTED_LEVEL_GREATER(players.user(), 0) then
		repeat
			util.yield()
			if not IS_PLAYER_WANTED_LEVEL_GREATER(players.user(), 0) then
				timer5 = 1
				break
			end
			timer5 += 1
		until timer5 == 300
			timer5 = 1
			players.set_wanted_level(players.user(), 0)
			util.toast("Die Fahndungslevel wurden entfernt")
	end
end)

menu.toggle_loop(Zeug_für_mich, "Auto auflegen", {}, "", function()
	if IS_MOBILE_PHONE_CALL_ONGOING() then
		util.yield(100)
		SET_CONTROL_VALUE_NEXT_FRAME(0, 176, 1)
		util.yield(30)
		SET_CONTROL_VALUE_NEXT_FRAME(0, 177, 1)
		util.toast("es wurde aufgelegt")
	end
end)

local settings = menu.list(menu.my_root(), "Settings", {}, "", function(); end)
	
if auto_update_config and auto_updater then
	menu.action(settings, "update suchen", {}, "", function()
		auto_update_config.check_interval = 0
		if auto_updater.run_auto_update(auto_update_config) then
			util.toast("No updates found")
		end
	end)
end

local settingsversiontab = menu.list(settings, "Versions", {}, "", function(on_click)
	loadingnewversion = true
	util.create_tick_handler(function()
		if not loadingnewversion then
			return false
		end
		async_http.init("raw.githubusercontent.com", "/TheaterChaos/Mein-zeug/main/Selfmade.lua", function(output)
			output = output:match('SCRIPT_VERSION = "([^ ]+)"')
			menu.set_menu_name(newversionaction, "New Version: ".. output)
		end)
		async_http.dispatch()
		util.yield(3000)
	end)
end, function(on_back)
	loadingnewversion = false
end)
menu.readonly(settingsversiontab, "Version: "..SCRIPT_VERSION)
newversionaction = menu.readonly(settingsversiontab, "New Version: ")

local entitymanagersettings = menu.list(settings, "Entity manager settings", {}, "", function(); end)
local enterexitsettings = menu.list(settings, "Fast enter/exit settings", {}, "", function(); end)
local miscs = menu.list(settings, "Misc", {}, "", function(); end)

menu.toggle(miscs, "host kick freunde", {}, "AN = kickt auch freunde\nAUS = kickt keine freunde", function(on_toggle)
	if on_toggle then
		hostkickfriends = true
	else
		hostkickfriends = false
	end
end)

menu.action(miscs, "alle sachen bei spielern ausssachlten", {}, "wenn du bei dem org ding was angemacht hast und es bei allen spieler wieder aus machen willst drück einfach hier", function()
	for players.list(false, true, true) as pid do
		playername = players.get_name(pid)
		menu.trigger_commands("givevehgod".. playername.. " off")
		util.yield(20)
		menu.trigger_commands("ceopay".. playername.. " off")
		util.yield(20)
		menu.trigger_commands("figurines".. playername.. " off")
		util.yield(20)
		menu.trigger_commands("cards".. playername.. " off")
		util.yield(20)
		menu.trigger_commands("autoheal".. playername.. " off")
		util.yield(20)
		menu.trigger_commands("bail".. playername.. " off")
		util.yield(20)
		menu.trigger_commands("giveotr".. playername.. " off")
		util.yield(20)
		menu.trigger_commands("snack".. playername.. " off")
		util.yield(20)
		menu.trigger_commands("disarm".. playername.. " off")
		util.yield(20)
		menu.trigger_commands("freeze".. playername.. " off")
		util.yield(20)
		menu.trigger_commands("confuse".. playername.. " off")
		util.yield(20)
		menu.trigger_commands("ragdoll".. playername.. " off")
		util.yield(20)
		menu.trigger_commands("shakecam".. playername.. " off")
		util.yield(20)
		menu.trigger_commands("notifyspam".. playername.. " off")
		util.yield(20)
	end
	util.toast("es wurde alles aus gemacht")
end)

sliderforaktimer = menu.slider(miscs, "anti afk kill timer", {"enterafktimer"}, "sekunden", 10, 300, timerforafk, 10, function(value)
	timerforafk = value
end)

menu.divider(enterexitsettings, "ON Enter")
menu.toggle(enterexitsettings, "npc auto klauen oder beifahrer", {}, "AN = beifahrer\nAUS = klauen", function(on_toggle)
	if on_toggle then
		ifnpcincar = true
	else
		ifnpcincar = false
	end
end)

menu.toggle(enterexitsettings, "spieler auto klauen oder beifahrer", {}, "AUS = beifahrer\nAN = klauen", function(on_toggle)
	if on_toggle then
		ifplayerincar = true
	else
		ifplayerincar = false
	end
end)

menu.toggle(enterexitsettings, "Missions npc nicht löschen", {}, "AUS = mission npc wird gelöscht\nAN = mission npc wird nicht gelöscht", function(on_toggle)
	if on_toggle then
		missionnpc = true
	else
		missionnpc = false
	end
end)

menu.divider(enterexitsettings, "ON Exit")

menu.toggle(enterexitsettings, "Motor bei austeigen an lassen", {}, "AUS = beim austeigen geht der motor normal aus\nAN = beim verlassen bleibt der motor an", function(on_toggle)
	if on_toggle then
		engineoff = true
	else
		engineoff = false
	end
end)

menu.toggle(enterexitsettings, "Stop on exit", {}, "AUS = auto fährt weiter\nAN = auto bleibt stehen nach dem austeigen\nFliege fahrzeug sind davon ausgeschlosen weil sie dich sonst meistens killen", function(on_toggle)
	if on_toggle then
		stoponexit = true
	else
		stoponexit = false
	end
end)

menu.toggle(enterexitsettings, "immer am boden aussteigen", {}, "AUS = spawned dich neben der tür\nAN = spawned dich auf den boden", function(on_toggle)
	if on_toggle then
		groundspawn = true
	else
		groundspawn = false
	end
end)

menu.toggle(enterexitsettings, "Checke exit position", {}, "AUS = schmeißt dich einfach direkt aus dem auto raus egal ob platz ist oder nicht\nAN = checkt ob platz ist zum aussteigen wenn nicht sucht es eine besser position für dich", function(on_toggle)
	if on_toggle then
		checkexitpoint = true
	else
		checkexitpoint = false
	end
end)

menu.divider(enterexitsettings, "Misc")

menu.toggle(enterexitsettings, "Veh info as debug", {}, "AUS = keine infos\nAN = rechts oben infos über das veh", function(on_toggle)
	if on_toggle then
		infoofveh = true
	else
		infoofveh = false
	end
end)

menu.slider(enterexitsettings, "auto einsteigen settings", {"entertimer"}, "[5 - 100]\nwie lang es warten soll bis du einsteigst", 5,100, 10, 5, function(boost1)
	abb = boost1
end)

menu.slider(enterexitsettings, "auto aussteigen settings", {"exittimer"}, "[5 - 100]\nwie lang es warten soll bis du aussteigst", 5,100, 10, 5, function(boost2)
	bba = boost2
end)

menu.toggle(entitymanagersettings, "Fahrzeug mit Ped löschen", {}, "wenn es an ist wird das fahrzeug mit dem ped gelöscht\nwenn beides aus dann löscht es zu erst das ped dann muss man nochmal drücken um das auto zu löschen", function(on_toggle)
	if on_toggle then
		controlepedcar = true
	else
		controlepedcar = false
	end
end)

menu.toggle(entitymanagersettings, "nur auto löschen ped bleibt da", {}, "wenn es an ist wird das fahrzeug gelöscht aber das ped bleibt dann ohne auto da\nwenn beides aus dann löscht es zu erst das ped dann muss man nochmal drücken um das auto zu löschen", function(on_toggle)
	if on_toggle then
		deletevehicle = true
	else
		deletevehicle = false
	end
end)

menu.divider(entitymanagersettings, "------------")

menu.toggle(entitymanagersettings, "Information von PED oder VEHICLE", {}, "welche informationen sollen angezeigt werden von dem ped das im auto sitzt oder dem fahrezug\nwenn aus dann wird es vom fahrezug angezeigt", function(on_toggle)
	if on_toggle then
		informationpedveh = true
	else
		informationpedveh = false
	end
end)

menu.divider(entitymanagersettings, "------------")

menu.toggle(entitymanagersettings, "platz klauen oder dazu setzen SPIELER", {}, "wenn an klaust du dem spieler sein fahrzeug beim F = ENTER", function(on_toggle)
	if on_toggle then
		vehentersteal = true
	else
		vehentersteal = false
	end
end)

menu.toggle(entitymanagersettings, "platz klauen oder dazu setzen NPC", {}, "wenn an wirst du dich irgendwo im fahrezug hin setzen F = ENTER", function(on_toggle)
	if on_toggle then
		vehenterstealnpc = true
	else
		vehenterstealnpc = false
	end
end)
loadtoggleoptionjobs()
vehicle_spawn_list(antiactionvehicles)
