util.require_natives("natives-1681379138", "g-uno")
local response = false
local localVer = 0.26
local currentVer
async_http.init("raw.githubusercontent.com", "/TheaterChaos/Mein-zeug/main/Meinzeugversion", function(output)
    currentVer = tonumber(output)
    response = true
    if localVer ~= currentVer then
        util.toast("Neue version ist verfügbar lad sie dir mit Update lua runter.")
        menu.action(menu.my_root(), "Update Lua", {}, "wenn update lua immer noch angezeigt wird dann einfach 2-3 minuten warten dann noch einmal probieren", function()
            async_http.init('raw.githubusercontent.com','/TheaterChaos/Mein-zeug/main/1Meinzeug.lua',function(a)
                local err = select(2,load(a))
                if err then
                    util.toast("Script failed to download. Please try again later. If this continues to happen then manually update via github.")
                return end
                local f = io.open(filesystem.scripts_dir()..SCRIPT_RELPATH, "wb")
                f:write(a)
                f:close()
			end)
			async_http.dispatch()
			util.yield(1000)

			async_http.init('raw.githubusercontent.com','/TheaterChaos/Mein-zeug/main/Alltabels.lua',function(b)
				local err = select(2,load(b))
				if err then
					util.toast("ACJSTables.lua failed to download. Please try again later. If this continues to happen then manually update via github.")
				return end
				local f = io.open(filesystem.resources_dir() .. 'alltabels.lua', "wb")
				f:write(b)
				f:close()
				util.toast("Successfully updated Selfmade. Restarting Script... :)")
				util.restart_script()
			end)
			async_http.dispatch()  
			util.yield(1000)
        end)
    end
end, function() response = true end) 
async_http.dispatch()
repeat 
    util.yield()
until response


--require ('resources/Alltabels')

local resource_dir = filesystem.resources_dir()
if not filesystem.exists(resource_dir) then
	util.toast("resource directory not found. notification system will be less of a bruh")
else
	util.register_file(resource_dir .. "bruhzowski.ytd")
end

local a = 1
local abb = 10
local bba = 10

-- Functions and infos
local function get_transition_state(pid)
    return memory.read_int(memory.script_global(((0x2908D3 + 1) + (pid * 0x1C5)) + 230))
end

local int_min = -2147483647
local int_max = 2147483647

local menus = {}

    local function getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
        local playerList = players.list()
        local notWhitelisted = {}
        for i = 1, #playerList do
            if not (players.get_name(playerList[i]) == whitelistedName) then
                notWhitelisted[#notWhitelisted + 1] = playerList[i]
            end
        end
        return notWhitelisted
    end

local function get_friend_count()
    native_invoker.begin_call();native_invoker.end_call("203F1CFD823B27A4");
    return native_invoker.get_return_value_int();
end
local function get_frined_name(friendIndex)
    native_invoker.begin_call();native_invoker.push_arg_int(friendIndex);native_invoker.end_call("4164F227D052E293");return native_invoker.get_return_value_string();
end

function getTargetVehicleData(entity)
	local vehicle = GET_VEHICLE_INDEX_FROM_ENTITY_INDEX(entity)
	local driver = GET_PED_IN_VEHICLE_SEAT(vehicle, -1, true)
	local player = NETWORK_GET_PLAYER_INDEX_FROM_PED(driver)
	local result = {}
	result.vehicle = vehicle
	result.driver = driver
	result.player = player
	return result
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
    STREAMING.REQUEST_NAMED_PTFX_ASSET(lib)
    while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED(lib) do
        util.yield()
    end
    GRAPHICS.USE_PARTICLE_FX_ASSET(lib)
end

function is_user_a_stand_user(pid)
    if players.exists(pid) and pid != players.user() then
        for menu.player_root(pid):getChildren() as cmd do
            if cmd:getType() == COMMAND_LIST_CUSTOM_SPECIAL_MEANING and (cmd:refByRelPath("Stand User"):isValid() or cmd:refByRelPath("Stand User (Co-Loading)"):isValid() or cmd:refByRelPath("Stand Nutzer"):isValid() or cmd:refByRelPath("Stand Nutzer (Mit Co-Load)"):isValid()) then
                return true
            end
        end
    end
    return false
end

function PlayerisFriend(player)
	for _, pid in players.list(false, true, false) do
		if player == pid then
			return true
		end
	end
	return false
end

local function getcontrole(entity)
	local time = 0
		repeat
		time += 1
		NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
			if time > 400 then
				util.toast("konnte keine kontrolle bekommen")
				time = 0
				return false
			end
		util.yield()
		until NETWORK_HAS_CONTROL_OF_ENTITY(entity)
	return true
end


local function v3(x, y, z)
	if x == nil then x = 0 end
	if y == nil then y = 0 end
	if z == nil then z = 0 end
end

local function send_script_event(first_arg, receiver, args)
	table.insert(args, 1, first_arg)
	util.trigger_script_event(1 << receiver, args)
end

handle_ptr = memory.alloc(13*8)
local function pid_to_handle(pid)
    NETWORK_HANDLE_FROM_PLAYER(pid, handle_ptr, 13)
    return handle_ptr
end

local function roundDecimals(float, decimals)
	decimals = 10 ^ decimals
	return math.floor(float * decimals) / decimals
end

--[[local function getnumber(number)
	if number == 1 then
		speedboost = 0.1
	elseif number == 2 then
		speedboost = 0.2
	elseif number == 3 then
		speedboost = 0.3
	elseif number == 4 then
		speedboost = 0.4
	elseif number == 5 then
		speedboost = 0.5
	elseif number == 6 then
		speedboost = 0.6
	elseif number == 7 then
		speedboost = 0.7
	elseif number == 8 then
		speedboost = 0.8
	elseif number == 9 then
		speedboost = 0.9
	elseif number == 10 then
		speedboost = 1.0
	elseif number == 11 then
		speedboost = 1.1
	elseif number == 12 then
		speedboost = 1.2
	elseif number == 13 then
		speedboost = 1.3
	elseif number == 14 then
		speedboost = 1.4
	elseif number == 15 then
		speedboost = 1.5
	elseif number == 16 then
		speedboost = 1.6
	elseif number == 17 then
		speedboost = 1.7
	elseif number == 18 then
		speedboost = 1.8
	elseif number == 19 then
		speedboost = 1.9
	elseif number == 20 then
		speedboost = 2.0
	end
	return speedboost
end]]

local keyLookupTable = {
    ['VK_LBUTTON']              =  0x01,	--Left mouse button
    ['VK_RBUTTON']              =  0x02,	--Right mouse button
    ['VK_CANCEL']               =  0x03,	--Control-break processing
    ['VK_MBUTTON']              =  0x04,	--Middle mouse button (three-button mouse)
    ['VK_XBUTTON1']             =  0x05,	--X1 mouse button
    ['VK_XBUTTON2']             =  0x06,	--X2 mouse button
    -- -	0x07	Undefined
    ['VK_BACK']	                =  0x08,	--BACKSPACE key
    ['VK_TAB']                  =  0x09,	--TAB key
    -- -	0x0A-0B	Reserved
    ['VK_CLEAR']                =  0x0C,	--CLEAR key
    ['VK_RETURN']	            =  0x0D,	--ENTER key
    -- -	0x0E-0F	Undefined
    ['VK_SHIFT']                =  0x10,	--SHIFT key
    ['VK_CONTROL']	            =  0x11,	--CTRL key
    ['VK_MENU']	                =  0x12,	--ALT key
    ['VK_PAUSE']	            =  0x13, 	--PAUSE key
    ['VK_CAPITAL']	            =  0x14,	--CAPS LOCK key
    ['VK_KANA']	                =  0x15, 	--IME Kana mode
    ['VK_HANGUEL']	            =  0x15,	--IME Hanguel mode (maintained for compatibility; use VK_HANGUL)
    ['VK_HANGUL']	            =  0x15,	--IME Hangul mode
    ['VK_IME_ON']	            =  0x16,	--IME On
    ['VK_JUNJA']	            =  0x17,	--IME Junja mode
    ['VK_FINAL']	            =  0x18,	--IME final mode
    ['VK_HANJA']	            =  0x19,	--IME Hanja mode
    ['VK_KANJI']	            =  0x19,	--IME Kanji mode
    ['VK_IME_OFF']	            =  0x1A,	--IME Off
    ['VK_ESCAPE']	            =  0x1B,	--ESC key
    ['VK_CONVERT']	            =  0x1C,	--IME convert
    ['VK_NONCONVERT']           =  0x1D,	--IME nonconvert
    ['VK_ACCEPT']	            =  0x1E,	--IME accept
    ['VK_MODECHANGE']           =  0x1F,	--IME mode change request
    ['VK_SPACE']	            =  0x20,	--SPACEBAR
    ['VK_PRIOR']	            =  0x21,	--PAGE UP key
    ['VK_NEXT']	                =  0x22,	--PAGE DOWN key
    ['VK_END']	                =  0x23,	--END key
    ['VK_HOME']	                =  0x24,	--HOME key
    ['VK_LEFT']	                =  0x25,	--LEFT ARROW key
    ['VK_UP']	                =  0x26,	--UP ARROW key
    ['VK_RIGHT']	            =  0x27,	--RIGHT ARROW key
    ['VK_DOWN']	                =  0x28,	--DOWN ARROW key
    ['VK_SELECT']	            =  0x29,	--SELECT key
    ['VK_PRINT']	            =  0x2A,	--PRINT key
    ['VK_EXECUTE']	            =  0x2B,	--EXECUTE key
    ['VK_SNAPSHOT']	            =  0x2C,	--PRINT SCREEN key
    ['VK_INSERT']	            =  0x2D,	--INS key
    ['VK_DELETE']	            =  0x2E,	--DEL key
    ['VK_HELP']	                =  0x2F,	--HELP key
    ['VK_0']                    =  0x30,	--0 key
    ['VK_1']                    =  0x31,	--1 key
    ['VK_2']                    =  0x32,	--2 key
    ['VK_3']                    =  0x33,	--3 key
    ['VK_4']                    =  0x34,	--4 key
    ['VK_5']                    =  0x35,	--5 key
    ['VK_6']                    =  0x36,	--6 key
    ['VK_7']                    =  0x37,	--7 key
    ['VK_8']                    =  0x38,	--8 key
    ['VK_9']                    =  0x39,	--9 key
    -- -	0x3A-40	Undefined
    ['VK_A']                    =  0x41,	--A key
    ['VK_B']                    =  0x42,	--B key
    ['VK_C']                    =  0x43,	--C key
    ['VK_D']                    =  0x44,	--D key
    ['VK_E']                    =  0x45,	--E key
    ['VK_F']                    =  0x46,	--F key
    ['VK_G']                    =  0x47,	--G key
    ['VK_H']                    =  0x48,	--H key
    ['VK_I']                    =  0x49,	--I key
    ['VK_J']                    =  0x4A,	--J key
    ['VK_K']                    =  0x4B,	--K key
    ['VK_L']                    =  0x4C,	--L key
    ['VK_M']                    =  0x4D,	--M key
    ['VK_N']                    =  0x4E,	--N key
    ['VK_O']                    =  0x4F,	--O key
    ['VK_P']                    =  0x50,	--P key
    ['VK_Q']                    =  0x51,	--Q key
    ['VK_R']                    =  0x52,	--R key
    ['VK_S']                    =  0x53,	--S key
    ['VK_T']                    =  0x54,	--T key
    ['VK_U']                    =  0x55,	--U key
    ['VK_V']                    =  0x56,	--V key
    ['VK_W']                    =  0x57,	--W key
    ['VK_X']                    =  0x58,	--X key
    ['VK_Y']                    =  0x59,	--Y key
    ['VK_Z']                    =  0x5A,	--Z key
    ['VK_LWIN']	                =  0x5B,	--Left Windows key (Natural keyboard)
    ['VK_RWIN']	                =  0x5C,	--Right Windows key (Natural keyboard)
    ['VK_APPS']	                =  0x5D,	--Applications key (Natural keyboard)
    -- -	0x5E	Reserved
    ['VK_SLEEP']	            =  0x5F,	--Computer Sleep key
    ['VK_NUMPAD0']	            =  0x60,	--Numeric keypad 0 key
    ['VK_NUMPAD1']	            =  0x61,	--Numeric keypad 1 key
    ['VK_NUMPAD2']	            =  0x62,	--Numeric keypad 2 key
    ['VK_NUMPAD3']	            =  0x63,	--Numeric keypad 3 key
    ['VK_NUMPAD4']	            =  0x64,	--Numeric keypad 4 key
    ['VK_NUMPAD5']	            =  0x65,	--Numeric keypad 5 key
    ['VK_NUMPAD6']	            =  0x66,	--Numeric keypad 6 key
    ['VK_NUMPAD7']	            =  0x67,	--Numeric keypad 7 key
    ['VK_NUMPAD8']	            =  0x68,	--Numeric keypad 8 key
    ['VK_NUMPAD9']	            =  0x69,	--Numeric keypad 9 key
    ['VK_MULTIPLY']	            =  0x6A,	--Multiply key
    ['VK_ADD']	                =  0x6B,	--Add key
    ['VK_SEPARATOR']            =  0x6C,	--Separator key
    ['VK_SUBTRACT']	            =  0x6D,	--Subtract key
    ['VK_DECIMAL']	            =  0x6E,	--Decimal key
    ['VK_DIVIDE']	            =  0x6F,	--Divide key
    ['VK_F1']	                =  0x70,	--F1 key
    ['VK_F2']	                =  0x71,	--F2 key
    ['VK_F3']	                =  0x72,	--F3 key
    ['VK_F4']	                =  0x73,	--F4 key
    ['VK_F5']	                =  0x74,	--F5 key
    ['VK_F6']	                =  0x75,	--F6 key
    ['VK_F7']	                =  0x76,	--F7 key
    ['VK_F8']	                =  0x77,	--F8 key
    ['VK_F9']	                =  0x78,	--F9 key
    ['VK_F10']	                =  0x79,	--F10 key
    ['VK_F11']	                =  0x7A,	--F11 key
    ['VK_F12']	                =  0x7B,	--F12 key
    ['VK_F13']	                =  0x7C,	--F13 key
    ['VK_F14']	                =  0x7D,	--F14 key
    ['VK_F15']	                =  0x7E,	--F15 key
    ['VK_F16']	                =  0x7F,	--F16 key
    ['VK_F17']	                =  0x80,	--F17 key
    ['VK_F18']	                =  0x81,	--F18 key
    ['VK_F19']	                =  0x82,	--F19 key
    ['VK_F20']	                =  0x83,	--F20 key
    ['VK_F21']	                =  0x84,	--F21 key
    ['VK_F22']	                =  0x85,	--F22 key
    ['VK_F23']	                =  0x86,	--F23 key
    ['VK_F24']	                =  0x87,	--F24 key
    -- -	0x88-8F	Unassigned
    ['VK_NUMLOCK']	            =  0x90,	--NUM LOCK key
    ['VK_SCROLL']	            =  0x91,	--SCROLL LOCK key
    -- 0x92-96	OEM specific
    -- -	0x97-9F	Unassigned
    ['VK_LSHIFT']	            =  0xA0,    --Left SHIFT key
    ['VK_RSHIFT']	            =  0xA1,    --Right SHIFT key
    ['VK_LCONTROL']	            =  0xA2,    --Left CONTROL key
    ['VK_RCONTROL']	            =  0xA3,    --Right CONTROL key
    ['VK_LMENU']	            =  0xA4,    --Left MENU key
    ['VK_RMENU']	            =  0xA5,    --Right MENU key
    ['VK_BROWSER_BACK']	        =  0xA6,	--Browser Back key
    ['VK_BROWSER_FORWARD']	    =  0xA7,	--Browser Forward key
    ['VK_BROWSER_REFRESH']	    =  0xA8,	--Browser Refresh key
    ['VK_BROWSER_STOP']	        =  0xA9,	--Browser Stop key
    ['VK_BROWSER_SEARCH']	    =  0xAA,	--Browser Search key
    ['VK_BROWSER_FAVORITES']	=  0xAB,	--Browser Favorites key
    ['VK_BROWSER_HOME']	        =  0xAC,	--Browser Start and Home key
    ['VK_VOLUME_MUTE']	        =  0xAD,	--Volume Mute key
    ['VK_VOLUME_DOWN']	        =  0xAE,	--Volume Down key
    ['VK_VOLUME_UP']	        =  0xAF,	--Volume Up key
    ['VK_MEDIA_NEXT_TRACK']	    =  0xB0,	--Next Track key
    ['VK_MEDIA_PREV_TRACK']	    =  0xB1,	--Previous Track key
    ['VK_MEDIA_STOP']	        =  0xB2,	--Stop Media key
    ['VK_MEDIA_PLAY_PAUSE']	    =  0xB3,	--Play/Pause Media key
    ['VK_LAUNCH_MAIL']	        =  0xB4,	--Start Mail key
    ['VK_LAUNCH_MEDIA_SELECT']	=  0xB5,	--Select Media key
    ['VK_LAUNCH_APP1']	        =  0xB6,	--Start Application 1 key
    ['VK_LAUNCH_APP2']	        =  0xB7,	--Start Application 2 key
    -- -	0xB8-B9	Reserved
    ['VK_OEM_1']	            =  0xBA,	--Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the ';:' key
    ['VK_OEM_PLUS']	            =  0xBB,	--For any country/region, the '+' key
    ['VK_OEM_COMMA']	        =  0xBC,	--For any country/region, the ',' key
    ['VK_OEM_MINUS']	        =  0xBD,	--For any country/region, the '-' key
    ['VK_OEM_PERIOD']	        =  0xBE,	--For any country/region, the '.' key
    ['VK_OEM_2']	            =  0xBF,	--Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the '/?' key
    ['VK_OEM_3']	            =  0xC0,	--Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the '`~' key
    -- -	0xC1-D7	Reserved
    -- -	0xD8-DA	Unassigned
    ['VK_OEM_4']	            =  0xDB,	--Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the '[{' key
    ['VK_OEM_5']	            =  0xDC,	--Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the '\|' key
    ['VK_OEM_6']	            =  0xDD,	--Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the ']}' key
    ['VK_OEM_7']	            =  0xDE,	--Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the 'single-quote/double-quote' key
    ['VK_OEM_8']	            =  0xDF,	--Used for miscellaneous characters; it can vary by keyboard.
    -- -	0xE0	Reserved
    --0xE1	OEM specific
    ['VK_OEM_102']              =  0xE2,	--The <> keys on the US standard keyboard, or the \\| key on the non-US 102-key keyboard
    -- 0xE3-E4	OEM specific
    ['VK_PROCESSKEY']	        =  0xE5,	--IME PROCESS key
    -- 0xE6	OEM specific
    ['VK_PACKET']	            =  0xE7, 	--Used to pass Unicode characters as if they were keystrokes. The VK_PACKET key is the low word of a 32-bit Virtual Key value used for non-keyboard input methods. For more information, see Remark in KEYBDINPUT, SendInput, WM_KEYDOWN, and WM_KEYUP
    -- -	0xE8	Unassigned
    -- 0xE9-F5	OEM specific
    ['VK_ATTN']	                =  0xF6,	--Attn key
    ['VK_CRSEL']	            =  0xF7,	--CrSel key
    ['VK_EXSEL']	            =  0xF8,	--ExSel key
    ['VK_EREOF']	            =  0xF9,	--Erase EOF key
    ['VK_PLAY']	                =  0xFA,	--Play key
    ['VK_ZOOM']	                =  0xFB,	--Zoom key
    ['VK_NONAME']	            =  0xFC,	--Reserved
    ['VK_PA1']	                =  0xFD,	--PA1 key
    ['VK_OEM_CLEAR']	        =  0xFE,	--Clear key
}

local justPressed = {}
local lastPressMS = {}

local function getKeyCode(string_or_int)
    local lookup = keyLookupTable[string_or_int]
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

selectedplayer = {}
for b = 0, 31 do
    selectedplayer[b] = false
end
excludeselected = false

cmd_id = {}
for i = 0, 31 do
	cmd_id[i] = 0
end

listpickups = {}
for i = 20, 0 do
	listpickups[i] = 0
end

listkicken = {}
for i = 0, 31 do
	listkicken[i] = 0
end

listfriendly = {}
for i = 0, 31 do
	listfriendly[i] = 0
end

listtp = {}
for i = 0, 31 do
	listtp[i] = 0
end

listtrolling = {}
for i = 0, 31 do
	listtrolling[i] = 0
end

listgenerel = {}
for i = 0, 31 do
	listgenerel[i] = 0
end

local colors = {
green = 184,
red = 6,
yellow = 190,
black = 2,
white = 1,
gray = 3,
pink = 201,
purple = 49,
blue = 11
}

local options <const> = {"zu Meinem", "zu Seinem"}

-- player options

local function player(pid)
    menu.divider(menu.player_root(pid), "Selfmade")
	local main = menu.list(menu.player_root(pid), "Selfmade", {"PlMein"}, "")
    local bozo = menu.list(main, "Notizen", {"Notizen"}, "")
	local anderes = menu.list(main, "anderes zeug", {"anderes"}, "")
	--local spam = menu.list(main, "spam zeug", {"spamzeug"}, "")

	--[[menu.toggle(spam, "alle loops", {}, "auto spam besser selber an machen sonst kaka", function(on_toggle)
		if on_toggle then
			menu.trigger_commands("ptfxspam" .. players.get_name(pid) .. " on")
			menu.trigger_commands("explospam" .. players.get_name(pid) .. " on")
		else
			menu.trigger_commands("ptfxspam" .. players.get_name(pid) .. " off")
			menu.trigger_commands("explospam" .. players.get_name(pid) .. " off")
		end
    end)

	local ptfx = {lib = 'scr_rcbarry2', sel = 'scr_clown_appears'}
	menu.toggle_loop(spam, 'PTFX Spam', {"ptfxspam"}, 'PTFX Spam', function ()
    local targets = GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local tar1 = ENTITY.GET_ENTITY_COORDS(targets, true)
    Streamptfx(ptfx.lib)
    GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD( ptfx.sel, tar1.x, tar1.y, tar1.z + 1, 0, 0, 0, 10.0, true, true, true)
	end)

	menu.list_action(spam, 'Ptfx List', {}, 'such dir hier aus was du für ein ptfx willst', Fxcorelist, function(fxsel)
    ptfx.sel = Fxha[fxsel]
    ptfx.lib = 'core'
	end)

	menu.toggle_loop(spam, "auto spam", {"autospam"}, "auto spawn spawnt viele t20", function(on_toggle)
			menu.trigger_commands("as" .. players.get_name(pid) .. " spawn" .. " t20")
    end)
	menu.toggle_loop(spam, "explosiv spam", {"explospam"}, "lässt ihn die ganze zeit explodieren", function(on_toggle)
		menu.trigger_commands("explode" .. players.get_name(pid))
	end)]]

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
end

players.on_join(player)
players.dispatch_on_join()

--local parents
local Self = menu.list(menu.my_root(), "Self zeug", {}, "")
local Entitymanager = menu.list(menu.my_root(), "Entity Manager", {}, "")
local player_zeug = menu.list(menu.my_root(), "Player zeug", {}, "")
--local streamer = menu.list(player_zeug, "Streamer zeug", {}, "")
local Zeugforjob = menu.list(menu.my_root(), "Zeug für jobs/missions", {}, "")
local custselc = menu.list(menu.my_root(), "Custom Selection", {}, "", function(); end)
local frendlist = menu.list(menu.my_root(), "friend list", {"fl"}, "", function(); end)
local players_list = menu.list(menu.my_root(), "Players", {}, "")

local function gen_fren_funcs(name)
	local balls = menu.list(frendlist, name, {"friend "..name}, "", function(); end)
	menu.divider(balls, name)
	menu.action(balls,"join", {"jf "..name}, "",function()
		menu.trigger_commands("join "..name)
	end)
	menu.action(balls,"add to history", {}, "",function()
		menu.trigger_commands("historyadd " .. name)
	end)
	menu.action(balls,"open in history", {}, "",function()
		menu.trigger_commands("findplayer " .. name)
	end)
	menu.action(balls,"open profile", {"pf "..name}, "",function()
		menu.trigger_commands("nameprofile "..name)
	end)
end

menu.divider(frendlist, "frens:)")
for i = 0 , get_friend_count() do
	local name = get_frined_name(i)
	if name == "*****" then goto yes end
	gen_fren_funcs(name)
	::yes::
end

local function handle_player_list(pid)
    local ref = menus[pid]
    if not players.exists(pid) then
        if ref then
            menu.delete(ref)
            menus[pid] = nil
        end
    end
end

local function player_list(pid)
	menus[pid] = menu.action(players_list, players.get_name(pid), {}, "", function() -- thanks to dangerman and aaron for showing me how to delete players properly
		menu.trigger_commands("Plmein " .. players.get_name(pid))
	end)
end

players.on_join(player_list)
players.on_leave(handle_player_list)

for pids = 0, 31 do
	if players.exists(pids) then
		menus[pids] = menu.action(players_list, players.get_name(pids), {}, "", function() -- thanks to dangerman and aaron for showing me how to delete players properly
			menu.trigger_commands("Plmein " .. players.get_name(pids))
		end)
	end
end

menu.action(Self, "Tp waypoint or mission point", {"tpwpob"}, "wenn ein waypoint gesetzt ist geht er da hin wenn keiner da ist geht er zu missions punkt", function()
	if IS_WAYPOINT_ACTIVE() then
		menu.trigger_commands("tpwp")
	else
		menu.trigger_commands("tpobjective")
	end
end)

--shoot gods
menu.toggle_loop(Self, 'Shoot gods', {}, 'Disables godmode for other players when aiming at them. Mostly works on trash menus.', function()
	for players.list_except(true) as pid do
		local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
 if IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), ped) or IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), ped) and not players.is_in_interior(ped) then
	if players.is_godmode(pid) then
	 util.trigger_script_event(1 << pid, {800157557, pid, 225624744, math.random(0, 9999)})
		end
	end
end
end)

menu.toggle_loop(Self, "Ghost Armed Players", {}, "macht godmode spieler zum geist für dich wenn sie auf dich ziehlen. \nwird nicht gehen wenn du godmode an hast weil du da ja eh unsterblich bist", function()
for players.list_except(true) as pid do
	local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
	local pedplayer = GET_PLAYER_PED_SCRIPT_INDEX(players.user())
	godmodeon = menu.get_value(menu.ref_by_path("Self>Immortality"))
	vehiclegodmode = menu.get_value(menu.ref_by_path("Vehicle>Indestructible"))
	local vehicleped = GET_VEHICLE_PED_IS_IN(players.user_ped())
		if IS_PED_ARMED(ped, 7) and IS_PLAYER_FREE_AIMING(pid) and IS_PLAYER_FREE_AIMING_AT_ENTITY(pid, players.user_ped()) or IS_PLAYER_FREE_AIMING_AT_ENTITY(pid, vehicleped) and not players.is_in_interior(pid) then
			if players.is_godmode(pid) and not godmodeon then
				SET_REMOTE_PLAYER_AS_GHOST(pid, true)
			end
		else
			SET_REMOTE_PLAYER_AS_GHOST(pid, false)
		end
end
end, function()
for players.list_except(true) as pid do
	SET_REMOTE_PLAYER_AS_GHOST(pid, false)
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

menu.toggle_loop(Self, "Script Host Addict", {}, "A faster version of script host kleptomaniac", function()
    if players.get_script_host() ~= players.user() and not util.is_session_transition_active(players.user) then
        menu.trigger_commands("scripthost")
    end
end)

menu.toggle_loop(Self, "Anti modder scripthost", {}, "gibt dir script host wenn ein spieler der modder ist script host ist/wird\nHat kein effekt auf freunde", function()
	local pid = players.get_script_host()
	local hdl = pid_to_handle(pid)
    if players.get_script_host() ~= players.user() and not util.is_session_transition_active(players.user) and not NETWORK_IS_FRIEND(hdl) then
		if players.is_marked_as_modder(pid) then
			util.toast("Script host wurde dir gegeben")
        	menu.trigger_commands("scripthost")
		end
    end
end)

menu.toggle_loop(Self, "Tempo anzeige nur im auto", {}, "macht die anzeige an wenn du im auto bist", function()
	if IS_PED_IN_ANY_VEHICLE(players.user_ped(), true) then
		menu.trigger_command(menu.ref_by_path("Vehicle>AR Speedometer>AR Speedometer"), true)
	else
		menu.trigger_command(menu.ref_by_path("Vehicle>AR Speedometer>AR Speedometer"), false)
	end
	on_stop = menu.trigger_command(menu.ref_by_path("Vehicle>AR Speedometer>AR Speedometer"), false)
end)

local auswahlauusmachen = menu.list(Zeugforjob, "selbst auswahl für aus machen", {}, "du kannst sagen was nicht aus gemacht werden soll weil das nicht gemacht werden muss. Ist aber würde ich sagen trz bei manchen missionen zu empfehlen")

menu.toggle(auswahlauusmachen, "lockweapons", {}, "achte darauf das man es nicht an aus macht während man :zeug für job aus machen: an hat / wenn es an ist dann wird es nicht aus gemacht", function(on_toggle)
	if on_toggle then
		lockweapons1 = true
	else
		lockweapons1 = false
	end
end)

menu.toggle(auswahlauusmachen, "Wantedlevel fixieren", {}, "achte darauf das man es nicht an aus macht während man :zeug für job aus machen: an hat / wenn es an ist dann wird es nicht aus gemacht", function(on_toggle)
	if on_toggle then
		wantedlevel1 = true
	else
		wantedlevel1 = false
	end
end)

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
		groopoverrite = menu.get_value(menu.ref_by_path("Online>Transitions>Join Group Override"))
		restrictedareas = menu.get_value(menu.ref_by_path("Game>Disables>Disable Restricted Areas"))
		wantedlevel = menu.get_value(menu.ref_by_path("Self>Lock Wanted Level"))
		disynckarma = menu.get_value(menu.ref_by_path("Online>Protections>Love Letter & Desync Kicks>Desync Kick Karma"))
		hosttokenspoof = menu.get_value(menu.ref_by_path("Online>Spoofing>Host Token Spoofing>Host Token Spoofing"))
		
		zeugforthejob = true
		if lockweapons1 then
		else
			menu.trigger_command(menu.ref_by_path("Self>Weapons>Lock Weapons>Lock Weapons"), false)
		end
		if wantedlevel1 then
		else
			menu.trigger_command(menu.ref_by_path("Self>Lock Wanted Level"), false)
		end
		menu.trigger_command(menu.ref_by_path("Online>Transitions>Matchmaking>Region Override>Region Override"), false)
		menu.trigger_command(menu.ref_by_path("Online>Transitions>Matchmaking>Pool Override>Pool Override"), false)
		menu.trigger_command(menu.ref_by_path("Online>Transitions>Seamless Session Switching>Seamless Session Switching"), false)
		menu.trigger_command(menu.ref_by_path("Online>Transitions>Speed Up>Don't Wait For Data Broadcast"), false)
		menu.trigger_command(menu.ref_by_path("Online>Transitions>Speed Up>Don't Wait For Mission Launcher"), false)
		menu.trigger_command(menu.ref_by_path("Online>Transitions>Speed Up>Don't Ask For Permission To Spawn"), false)
		menu.trigger_command(menu.ref_by_path("Online>Transitions>Skip Swoop Down"), false)
		menu.trigger_command(menu.ref_by_path("Online>Protections>Delete Modded Pop Multiplier Areas"), false)
		menu.trigger_command(menu.ref_by_path("Online>Protections>Block Entity Spam>Block Entity Spam"), false)
		menu.trigger_command(menu.ref_by_path("Online>Transitions>Join Group Override>Don't Override"), "Don't Override")
		menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Restricted Areas"), false)
		menu.trigger_command(menu.ref_by_path("Online>Protections>Love Letter & Desync Kicks>Desync Kick Karma"), false)
		menu.trigger_command(menu.ref_by_path("Online>Spoofing>Host Token Spoofing>Host Token Spoofing"), false)
	else
		zeugforthejob = false
		if lockweapons1 then
		else
			menu.set_value(menu.ref_by_path("Self>Weapons>Lock Weapons>Lock Weapons"), Lockweapons)
		end
		if wantedlevel1 then
		else
			menu.trigger_command(menu.ref_by_path("Self>Lock Wanted Level"), wantedlevel)
		end
		menu.set_value(menu.ref_by_path("Online>Transitions>Matchmaking>Region Override>Region Override"), Regionsmatch)
		menu.set_value(menu.ref_by_path("Online>Transitions>Matchmaking>Pool Override>Pool Override"), poolOver)
		menu.set_value(menu.ref_by_path("Online>Transitions>Seamless Session Switching>Seamless Session Switching"), seamlessswitch)
		menu.set_value(menu.ref_by_path("Online>Transitions>Speed Up>Don't Wait For Data Broadcast"), Broadcastdata)
		menu.set_value(menu.ref_by_path("Online>Transitions>Speed Up>Don't Wait For Mission Launcher"), Lauchnermission)
		menu.set_value(menu.ref_by_path("Online>Transitions>Speed Up>Don't Ask For Permission To Spawn"), permissionspawn)
		menu.set_value(menu.ref_by_path("Online>Transitions>Skip Swoop Down"), swoopdown)
		menu.set_value(menu.ref_by_path("Online>Protections>Delete Modded Pop Multiplier Areas"), multiplierareas)
		menu.set_value(menu.ref_by_path("Online>Protections>Block Entity Spam>Block Entity Spam"), Entityspamzeug)
		menu.set_value(menu.ref_by_path("Online>Transitions>Join Group Override"), groopoverrite)
		menu.set_value(menu.ref_by_path("Game>Disables>Disable Restricted Areas"), restrictedareas)
		menu.set_value(menu.ref_by_path("Online>Protections>Love Letter & Desync Kicks>Desync Kick Karma"), disynckarma)
		menu.set_value(menu.ref_by_path("Online>Spoofing>Host Token Spoofing>Host Token Spoofing"), hosttokenspoof)
	end
end)

menu.action(Zeugforjob, "was deaktiviert wurde drück hier", {}, "zeigt was alles bei zeug für job aus machen aus gemacht wird", function()
	util.toast("Lock Weapons = false", TOAST_CONSOLE)
	util.toast("Region Override = false", TOAST_CONSOLE)
	util.toast("Pool Override = false", TOAST_CONSOLE)
	util.toast("Seamless Session Switching = false", TOAST_CONSOLE)
	util.toast("Don't Wait For Data Broadcast = false", TOAST_CONSOLE)
	util.toast("Don't Wait For Mission Launcher = false", TOAST_CONSOLE)
	util.toast("Don't Ask For Permission To Spawn = false", TOAST_CONSOLE)
	util.toast("Skip Swoop Down = false", TOAST_CONSOLE)
	util.toast("Delete Modded Pop Multiplier Areas = false", TOAST_CONSOLE)
	util.toast("Block Entity Spam>Block Entity Spam = false", TOAST_CONSOLE)
	util.toast("Join Group Override = Don't Override", TOAST_CONSOLE)
	util.toast("Disable Restricted Areas 0 false", TOAST_CONSOLE)
	util.toast("Lock Wanted Level = false", TOAST_CONSOLE)
	util.toast("Desync Kick Karma = false", TOAST_CONSOLE)
	util.toast("Host Token Spoofing = false", TOAST_CONSOLE)
	util.toast("Guck in deine console da steht alles. wenn du keine hast fick dich")
end)

local function zeugwiederan()
	if zeugforthejob then
		menu.set_value(menu.ref_by_path("Self>Weapons>Lock Weapons>Lock Weapons"), Lockweapons)
		menu.set_value(menu.ref_by_path("Online>Transitions>Matchmaking>Region Override>Region Override"), Regionsmatch)
		menu.set_value(menu.ref_by_path("Online>Transitions>Matchmaking>Pool Override>Pool Override"), poolOver)
		menu.set_value(menu.ref_by_path("Online>Transitions>Seamless Session Switching>Seamless Session Switching"), seamlessswitch)
		menu.set_value(menu.ref_by_path("Online>Transitions>Speed Up>Don't Wait For Data Broadcast"), Broadcastdata)
		menu.set_value(menu.ref_by_path("Online>Transitions>Speed Up>Don't Wait For Mission Launcher"), Lauchnermission)
		menu.set_value(menu.ref_by_path("Online>Transitions>Speed Up>Don't Ask For Permission To Spawn"), permissionspawn)
		menu.set_value(menu.ref_by_path("Online>Transitions>Skip Swoop Down"), swoopdown)
		menu.set_value(menu.ref_by_path("Online>Protections>Delete Modded Pop Multiplier Areas"), multiplierareas)
		menu.set_value(menu.ref_by_path("Online>Protections>Block Entity Spam>Block Entity Spam"), Entityspamzeug)
		menu.set_value(menu.ref_by_path("Online>Transitions>Join Group Override"), groopoverrite)
		menu.set_value(menu.ref_by_path("Game>Disables>Disable Restricted Areas"), restrictedareas)
		menu.set_value(menu.ref_by_path("Self>Lock Wanted Level"), wantedlevel1)
		menu.set_value(menu.ref_by_path("Online>Protections>Love Letter & Desync Kicks>Desync Kick Karma"), disynckarma)
		menu.set_value(menu.ref_by_path("Online>Spoofing>Host Token Spoofing>Host Token Spoofing"), hosttokenspoof)
	end
end

util.on_stop(zeugwiederan)

menu.action(Zeugforjob, "Teleport Pickups To Me", {}, "teleportiert sachen zum aufheben zu dir", function()
    local counter = 0
    local pos = players.get_position(players.user())
    for entities.get_all_pickups_as_handles() as pickup do
        SET_ENTITY_COORDS(pickup, pos, false, false, false, false)
        counter += 1
        util.yield()
    end
    if counter == 0 then
        util.toast("No Pickups Found. :/")
    else
        util.toast("Teleported ".. tostring(counter) .." Pickups.")
    end
end)

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
	if schwerkraftan then
		if is_key_just_down('VK_E') and IS_PLAYER_FREE_AIMING(players.user()) then
			menu.trigger_command(menu.ref_by_path("Self>Weapons>Gravity Gun>Gravity Gun"), false)
		end
	end
	menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>MELEE_ATTACK_LIGHT"), true)
	menu.trigger_command(menu.ref_by_path("Game>Disables>Disable Game Inputs>THROW_GRENADE"), true)
	if GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(players.user(), entpointer) then
	local godmodeentity = GET_ENTITY_CAN_BE_DAMAGED(handle) if godmodeentity then godmodeentity1 = false else godmodeentity1 = true end
	local visibleentitiy = IS_ENTITY_VISIBLE(handle)
	local deadentity = IS_ENTITY_DEAD(handle)
	local missionentity = IS_ENTITY_A_MISSION_ENTITY(handle)
	local speedentity = GET_ENTITY_SPEED(handle) * 3.6
	speedentity1 = roundDecimals(speedentity, 1)
	local modelhashentity = GET_ENTITY_MODEL(handle)
	local healthentity = GET_ENTITY_HEALTH(handle)
	local ownerentity = entities.get_owner(handle)
	local namefromplayer = players.get_name(ownerentity)
	x = 0.55
	y = 0.5
	y1 = 0.52
	y2 = 0.54
	y3 = 0.56
	y4 = 0.58
	y5 = 0.6
	y6 = 0.62
	y7 = 0.64
	y8 = 0.66
	y9 = 0.68
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
				local vehiclemodelentity1 = GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(modelhashentity1)
				local ownerentity1 = entities.get_owner(vehicleding)
				local namefromplayer1 = players.get_name(ownerentity1)
				if not informationpedveh then
					directx.draw_text(x, y, "VEHICLE: ".. vehiclemodelentity1, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					directx.draw_text(x, y1, "GOD: ".. godmodeentity3, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					--directx.draw_text(x, y2, "VISIBLE: ".. visibleentitiy1, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					directx.draw_text(x, y2, "FOR MISSION: ".. missionentity1, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					directx.draw_text(x, y3, "SPEED: ".. speedentity3, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					directx.draw_text(x, y4, "HEALTH: ".. healthentity1, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					directx.draw_text(x, y5, "OWNERVEH: ".. namefromplayer1, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
				else
					directx.draw_text(x, y, "PED", 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					directx.draw_text(x, y1, "VEHICLE: ".. vehiclemodelentity1, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					directx.draw_text(x, y2, "GOD: ".. godmodeentity1, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					--directx.draw_text(x, y3, "VISIBLE: ".. visibleentitiy, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					directx.draw_text(x, y3, "DEAD: ".. deadentity, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					directx.draw_text(x, y4, "FOR MISSION: ".. missionentity, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					directx.draw_text(x, y5, "SPEED: ".. speedentity1, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					directx.draw_text(x, y6, "HEALTH: ".. healthentity, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					directx.draw_text(x, y7, "OWNERPED: ".. namefromplayer, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
				end
				--directx.draw_text(x, y6, "MODEL HASH: ".. modelhashentity1, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
				directx.draw_text(0.5, y10, "R = Delete  /  E = GRAVITY GUN  /  F = ENTER VEH  /  G = EXPLODE", 5, 0.8, {r=1,g=1,b=1,a=10}, true)
				if is_key_just_down("VK_F") and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
					if not vehenterstealnpc then
						if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
							menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
							entities.delete(handle)
							TASK_ENTER_VEHICLE(players.user_ped(), vehicleding, -1, -1, 16, 24)
						else
							entities.delete(handle)
							TASK_ENTER_VEHICLE(players.user_ped(), vehicleding, -1, -1, 16, 24)
						end
					else
						if ARE_ANY_VEHICLE_SEATS_FREE(vehicleding) then
							if IS_VEHICLE_SEAT_FREE(vehicleding, 0) then
								if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
									menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
									TASK_ENTER_VEHICLE(players.user_ped(), vehicleding, -1, 0, 16, 24)
								else
									TASK_ENTER_VEHICLE(players.user_ped(), vehicleding, -1, 0, 16, 24)
								end
							elseif  IS_VEHICLE_SEAT_FREE(vehicleding, 1) then
								if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
									menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
									TASK_ENTER_VEHICLE(players.user_ped(), vehicleding, -1, 1, 16, 24)
								else
									TASK_ENTER_VEHICLE(players.user_ped(), vehicleding, -1, 1, 16, 24)
								end
							elseif  IS_VEHICLE_SEAT_FREE(vehicleding, 2) then
								if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
									menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
									TASK_ENTER_VEHICLE(players.user_ped(), vehicleding, -1, 2, 16, 24)
								else
									TASK_ENTER_VEHICLE(players.user_ped(), vehicleding, -1, 2, 16, 24)
								end
							elseif  IS_VEHICLE_SEAT_FREE(vehicleding, 3) then
								if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
									menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
									TASK_ENTER_VEHICLE(players.user_ped(), vehicleding, -1, 3, 16, 24)
								else
									TASK_ENTER_VEHICLE(players.user_ped(), vehicleding, -1, 3, 16, 24)
								end
							elseif  IS_VEHICLE_SEAT_FREE(vehicleding, 4) then
								if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
									menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
									TASK_ENTER_VEHICLE(players.user_ped(), vehicleding, -1, 4, 16, 24)
								else
									TASK_ENTER_VEHICLE(players.user_ped(), vehicleding, -1, 4, 16, 24)
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
				if IS_PED_IN_ANY_VEHICLE(handle,true) then
					directx.draw_text(0.5, y10, "R = Delete  /  E = GRAVITY GUN  /  F = ENTER VEH  /  C = KICKEN  /  B = PLAYER WINDOW  /  G = EXPLODE", 5, 0.8, {r=1,g=1,b=1,a=10}, true)
					local vehicleplayer1 = GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(handle)
					local vehicleplayer = GET_VEHICLE_PED_IS_IN(handle)
					local ownerentity2 = entities.get_owner(vehicleplayer)
					local namefromplayer2 = players.get_name(ownerentity2)
					directx.draw_text(x, y, "PLAYER: ".. nameplayer, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					directx.draw_text(x, y1, "VEHICLE: ".. vehicleplayer1, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					directx.draw_text(x, y2, "GOD: ".. godmodeentity1, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					directx.draw_text(x, y3, "VISIBLE: ".. visibleentitiy, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					directx.draw_text(x, y4, "SPEED: ".. speedentity1, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					directx.draw_text(x, y5, "HEALTH: ".. healthentity, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					directx.draw_text(x, y6, "OWNERVEH: ".. namefromplayer2, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					directx.draw_text(x, y7, "TAGS: ".. tagsofplayer, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
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
								TASK_ENTER_VEHICLE(players.user_ped(), vehicleplayer, -1, -1, 16, 24)
							else
								TASK_ENTER_VEHICLE(players.user_ped(), vehicleplayer, -1, -1, 16, 24)
							end
						else
							if ARE_ANY_VEHICLE_SEATS_FREE(vehicleplayer) then
								if IS_VEHICLE_SEAT_FREE(vehicleplayer, 0) then
									if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
										menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
										TASK_ENTER_VEHICLE(players.user_ped(), vehicleplayer, -1, 0, 16, 24)
									else
										TASK_ENTER_VEHICLE(players.user_ped(), vehicleplayer, -1, 0, 16, 24)
									end
								elseif  IS_VEHICLE_SEAT_FREE(vehicleplayer, 1) then
									if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
										menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
										TASK_ENTER_VEHICLE(players.user_ped(), vehicleplayer, -1, 1, 16, 24)
									else
										TASK_ENTER_VEHICLE(players.user_ped(), vehicleplayer, -1, 1, 16, 24)
									end
								elseif  IS_VEHICLE_SEAT_FREE(vehicleplayer, 2) then
									if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
										menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
										TASK_ENTER_VEHICLE(players.user_ped(), vehicleplayer, -1, 2, 16, 24)
									else
										TASK_ENTER_VEHICLE(players.user_ped(), vehicleplayer, -1, 2, 16, 24)
									end
								elseif  IS_VEHICLE_SEAT_FREE(vehicleplayer, 3) then
									if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
										menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
										TASK_ENTER_VEHICLE(players.user_ped(), vehicleplayer, -1, 3, 16, 24)
									else
										TASK_ENTER_VEHICLE(players.user_ped(), vehicleplayer, -1, 3, 16, 24)
									end
								elseif  IS_VEHICLE_SEAT_FREE(vehicleplayer, 4) then
									if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
										menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
										TASK_ENTER_VEHICLE(players.user_ped(), vehicleplayer, -1, 4, 16, 24)
									else
										TASK_ENTER_VEHICLE(players.user_ped(), vehicleplayer, -1, 4, 16, 24)
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
						end
					end
				else
					directx.draw_text(0.5, y10, "C = KICKEN  /  B = PLAYER WINDOW", 5, 0.8, {r=1,g=1,b=1,a=10}, true)
					directx.draw_text(x, y, "PLAYER: ".. nameplayer, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					directx.draw_text(x, y1, "GOD: ".. godmodeentity1, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					--directx.draw_text(x, y2, "VISIBLE: ".. visibleentitiy, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					directx.draw_text(x, y2, "SPEED: ".. speedentity1, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					directx.draw_text(x, y3, "HEALTH: ".. healthentity, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					directx.draw_text(x, y4, "TAGS: ".. tagsofplayer, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
					if is_key_just_down('VK_C') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
						menu.trigger_commands("kick ".. nameplayer)
					end
					if is_key_just_down('VK_B') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
						menu.trigger_commands("p ".. nameplayer)
					end
				end
			else
				directx.draw_text(0.5, y10, "R = Delete  /  C = CLEAR TASKS ", 5, 0.8, {r=1,g=1,b=1,a=10}, true)
				directx.draw_text(x, y, "PED", 5, 0.5, {r=1,g=1,b=1,a=1}, true)
				directx.draw_text(x, y1, "GOD: ".. godmodeentity1, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
				--directx.draw_text(x, y2, "VISIBLE: ".. visibleentitiy, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
				directx.draw_text(x, y2, "DEAD: ".. deadentity, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
				directx.draw_text(x, y3, "FOR MISSION: ".. missionentity, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
				directx.draw_text(x, y4, "SPEED: ".. speedentity1, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
				directx.draw_text(x, y5, "HEALTH: ".. healthentity, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
				directx.draw_text(x, y6, "OWNERPED: ".. namefromplayer, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
				--directx.draw_text(x, y7, "MODEL HASH: ".. modelhashentity, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
				if is_key_just_down('VK_R') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
					entities.delete(handle)
				end
				if is_key_just_down('VK_C') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
					if getcontrole(handle) then
						CLEAR_PED_TASKS(handle)
					end
				end
			end
		elseif IS_ENTITY_A_VEHICLE(handle) then
			directx.draw_text(0.5, y10, "R = Delete  /  E = GRAVITY GUN  /  F = ENTER VEH  /  G = EXPLODE", 5, 0.8, {r=1,g=1,b=1,a=10}, true)
			local vehiclemodelentity3 = GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(modelhashentity)
			directx.draw_text(x, y, "VEHICLE: ".. vehiclemodelentity3, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
			directx.draw_text(x, y1, "GOD: ".. godmodeentity1, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
			--directx.draw_text(x, y2, "VISIBLE: ".. visibleentitiy, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
			directx.draw_text(x, y2, "FOR MISSION: ".. missionentity, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
			directx.draw_text(x, y3, "SPEED: ".. speedentity1, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
			directx.draw_text(x, y4, "HEALTH: ".. healthentity, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
			directx.draw_text(x, y5, "OWNERVEH: ".. namefromplayer, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
			--directx.draw_text(x, y6, "MODEL HASH: ".. modelhashentity, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
			if is_key_just_down('VK_R') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
				entities.delete(handle)
			end
			if is_key_just_down("VK_F") and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
				if menu.get_value(menu.ref_by_path("Self>Movement>Levitation>Levitation")) then
					menu.trigger_command(menu.ref_by_path("Self>Movement>Levitation>Levitation"), false)
					TASK_ENTER_VEHICLE(players.user_ped(), handle, -1, -1, 16, 24)
				else
					TASK_ENTER_VEHICLE(players.user_ped(), handle, -1, -1, 16, 24)
				end
			end
			if is_key_just_down('VK_G') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
				if getcontrole(handle) then
					NETWORK_EXPLODE_VEHICLE(handle, 1, 0, 0)
				end
			end
			if not schwerkraftan then
				if is_key_just_down('VK_E') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
					menu.trigger_command(menu.ref_by_path("Self>Weapons>Gravity Gun>Gravity Gun"), true)
				end
			end
		elseif IS_ENTITY_AN_OBJECT(handle) then
			directx.draw_text(0.5, y10, "R = Delete  /  E = GRAVITY GUN", 5, 0.8, {r=1,g=1,b=1,a=10}, true)
			directx.draw_text(x, y, "OBJECT", 5, 0.5, {r=1,g=1,b=1,a=1}, true)
			directx.draw_text(x, y1, "VISIBLE: ".. visibleentitiy, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
			directx.draw_text(x, y2, "FOR MISSION: ".. missionentity, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
			directx.draw_text(x, y3, "MODEL HASH: ".. modelhashentity, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
			directx.draw_text(x, y4, "OWNEROBJECT: ".. namefromplayer, 5, 0.5, {r=1,g=1,b=1,a=1}, true)
			if is_key_just_down('VK_R') and IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), handle) then
				entities.delete(handle)
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
	if menu.get_value(menu.ref_by_path("Self>Weapons>Gravity Gun>Gravity Gun")) then
		util.draw_debug_text("Gravity Gun ist AN")
	end
end)

CLEAR_AREA_RANGE = 100
local function clearAreaOfEntities(entitie, range)
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

--[[local function clearAreaOfEntities(tbl, range)
    local rangesq = range*range
    local pc = GET_ENTITY_COORDS(players.user_ped())
    for _, v in pairs(tbl) do
        local cc = entities.get_position(v)
        if (VDIST2(pc.x, pc.y, pc.z, cc.x, cc.y, cc.z) <= rangesq) then
            local h = entities.pointer_to_handle(v)
			local x = entities.get_model_hash(h)
			local playervehicle = entities.get_user_vehicle_as_handle(true)
            if IS_ENTITY_AN_OBJECT(h) then
               	for i = 0, 20 do NETWORK_REQUEST_CONTROL_OF_ENTITY(h) end
                entities.delete_by_handle(h)
			elseif (IS_ENTITY_A_PED(h) and not IS_PED_A_PLAYER(h)) or (not IS_ENTITY_A_PED(h)) and not (playervehicle == h) then
				for i = 0, 20 do NETWORK_REQUEST_CONTROL_OF_ENTITY(h) end
                entities.delete_by_handle(h)
            end
        end
    end
end]]
local function getAreaOfEntities(tbl, range)
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
menu.toggle_loop(Entitymanager, "Clear Area of Peds", {"clearpeds"}, "", function ()
	clearAreaOfEntities("ped", CLEAR_AREA_RANGE)
end)
menu.toggle_loop(Entitymanager, "Clear Area of Vehicles", {"clearvehs"}, "", function ()
    clearAreaOfEntities("veh", CLEAR_AREA_RANGE)
end)
menu.toggle_loop(Entitymanager, "Clear Area of Objects", {"clearobjs"}, "", function ()
    clearAreaOfEntities("obj", CLEAR_AREA_RANGE)
end)
menu.action(Entitymanager, "Clear Area of Pickups", {"clearpickups"}, "", function ()
    clearAreaOfEntities("pickup", CLEAR_AREA_RANGE)
end)
menu.toggle_loop(Entitymanager, "Delete all", {"deleteall"}, "", function ()
    clearAreaOfEntities("ped",CLEAR_AREA_RANGE)
	clearAreaOfEntities("veh", CLEAR_AREA_RANGE)
	clearAreaOfEntities("obj", CLEAR_AREA_RANGE)
	clearAreaOfEntities("pickup", CLEAR_AREA_RANGE)
end)
menu.action(Entitymanager, "Clear ALL Ropes", {"clearropes"}, "", function() 
    for i = 0, 100 do
        DELETE_CHILD_ROPE(i)
    end
end)
menu.slider(Entitymanager, "Clear Area Range", {"cleararearange"}, "", 0, 10000, 100, 50, function (value)
    CLEAR_AREA_RANGE = value
end)

--[[local entitymanagerlist = menu.list(Entitymanager, "list", {}, "")

menu.action(Entitymanager, "list of pickups", {}, "", function()
    local counter = 0
    local pos = players.get_position(players.user())
    for entities.get_all_pickups_as_handles() as pickup do
        --SET_ENTITY_COORDS(pickup, pos, false, false, false, false)
		local coords = GET_ENTITY_COORDS(pickup)
		local info = util.get_model_info(pickup)
		util.toast(info)
        counter += 1
		listpickups[a] = menu.action(entitymanagerlist, "pickup "..counter, {}, "", function()
			util.toast("test")
			START_PLAYER_TELEPORT(players.user(), coords,false,true,false)
			menu.delete(listpickups[a])
		end)
        util.yield()
    end
    if counter == 0 then
        util.toast("No Pickups Found. :/")
    else
        util.toast("Teleported ".. tostring(counter) .." Pickups.")
    end
end)]]

--[[menu.toggle_loop(Entitymanager, "toggle für auto anzeige", {}, "", function()
	local tbl = entities.get_all_vehicles_as_pointers()
	local range = CLEAR_AREA_RANGE
	local rangesq = range*range
    local pc = GET_ENTITY_COORDS(players.user_ped())
	for a = 0, 200 do
    for _, v in pairs(tbl) do
        local cc = entities.get_position(v)
        if (VDIST2(pc.x, pc.y, pc.z, cc.x, cc.y, cc.z) <= rangesq) then
            local h = entities.pointer_to_handle(v)
			local x = entities.get_model_hash(h)
			local playervehicle = entities.get_user_vehicle_as_handle(true)
			--util.toast(v.."  //  "..h.."  //  "..x.."   //   "..playervehicle)
            if (IS_ENTITY_A_PED(h) and not IS_PED_A_PLAYER(h)) or (not IS_ENTITY_A_PED(h)) and not (playervehicle == h) then
					local vehiclemodelname = GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(x)
					local isvehiclethere = menu.is_ref_valid(menu.ref_by_path("Stand>Lua Scripts>".. SCRIPT_NAME ..">Entity Manager>list vehicles>".. vehiclemodelname))
					if not isvehiclethere then
						allvehicles[a] = menu.list(entitymanagerlist, vehiclemodelname, {}, "", function(on_click)
								
						end)
					else
						break
					end
				
			end
		end
	end
	end
end)

menu.toggle_loop(Entitymanager, "veh testen ding selber", {}, "", function()
	local tbl = entities.get_all_vehicles_as_pointers()
	local range = CLEAR_AREA_RANGE
	local rangesq = range*range
    local pc = GET_ENTITY_COORDS(players.user_ped())
	for _, v in pairs(tbl) do
		local cc = entities.get_position(v)
		local h = entities.pointer_to_handle(v)
		local x = entities.get_model_hash(h)
		local distance = (VDIST2(pc.x, pc.y, pc.z, cc.x, cc.y, cc.z))
		local playervehicle = entities.get_user_vehicle_as_handle(true)
		local vehiclemodelname = GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(x)
		local isvehiclethere = menu.is_ref_valid(menu.ref_by_path("Stand>Lua Scripts>".. SCRIPT_NAME ..">Entity Manager>list vehicles>".. vehiclemodelname))
			if not isvehiclethere then
				if not isvehiclethere and (VDIST2(pc.x, pc.y, pc.z, cc.x, cc.y, cc.z) <= rangesq) then
						allvehicles[a] = menu.list(entitymanagerlist, vehiclemodelname, {}, "", function()
								action1 = menu.action(allvehicles[a], "get distance", {}, "", function()
									util.toast(distance)
								end)
						end)
				--else
					--if menu.is_ref_valid(allvehicles[a]) and isvehiclethere then
					--	menu.delete(allvehicles[a])
					--end
				end
			end
	end	
end)]]

--auto stand user marker
menu.action(player_zeug, "Mark Stand user self", {}, "Nicht möglich bei leuten die du schonmal anders gesehen hast", function()
	for _, pid in players.list(false, true, true) do
		if is_user_a_stand_user(pid) or pid == players.user() and not util.is_session_transition_active(players.user) then
			if menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. ">Note")) then
				if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. ">Note")) == "" then
					menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. ">Note"), "Stand user")
					util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
				end
			elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Solo]>Note")) then
				if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Solo]>Note")) == "" then
					menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Solo]>Note"), "Stand user")
					util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
				end
			elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Invite]>Note")) then
				if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Invite]>Note")) == "" then
					menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Invite]>Note"), "Stand user")
					util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
				end
			elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Closed Friend]>Note")) then
				if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Closed Friend]>Note")) == "" then
					menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Closed Friend]>Note"), "Stand user")
					util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
				end
			elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Closed Crew]>Note")) then
				if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Closed Crew]>Note")) == "" then
					menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Closed Crew]>Note"), "Stand user")
					util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
				end
			elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Crew]>Note")) then
				if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Crew]>Note")) == "" then
					menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Crew]>Note"), "Stand user")
					util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
				end
			elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Public]>Note")) then
				if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Public]>Note")) == "" then
					menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Public]>Note"), "Stand user")
					util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
				end
			elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Invalid]>Note")) then
				if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Invalid]>Note")) == "" then
					menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Invalid]>Note"), "Stand user")
					util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
				end
			elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Story Mode]>Note")) then
				if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Story Mode]>Note")) == "" then
					menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Story Mode]>Note"), "Stand user")
					util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
				end
			elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Offline]>Note")) then
				if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Offline]>Note")) == "" then
					menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Offline]>Note"), "Stand user")
					util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
				end
			end
		end
	end
end)


menu.toggle(player_zeug, "Mark Stand user auto", {}, "Nicht möglich bei leuten die du schonmal anders gesehen hast", function()
	for _, pid in players.list(false, true, true) do
		if is_user_a_stand_user(pid) or pid == players.user() and not util.is_session_transition_active(players.user) then
			if menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. ">Note")) then
				if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. ">Note")) == "" then
					menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. ">Note"), "Stand user")
					util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
			end
			elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Solo]>Note")) then
				if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Solo]>Note")) == "" then
					menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Solo]>Note"), "Stand user")
					util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
				end
			elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Invite]>Note")) then
				if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Invite]>Note")) == "" then
					menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Invite]>Note"), "Stand user")
					util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
				end
			elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Closed Friend]>Note")) then
				if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Closed Friend]>Note")) == "" then
					menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Closed Friend]>Note"), "Stand user")
					util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
				end
			elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Closed Crew]>Note")) then
				if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Closed Crew]>Note")) == "" then
					menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Closed Crew]>Note"), "Stand user")
					util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
				end
			elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Crew]>Note")) then
				if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Crew]>Note")) == "" then
					menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Crew]>Note"), "Stand user")
					util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
				end
			elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Public]>Note")) then
				if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Public]>Note")) == "" then
					menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Public]>Note"), "Stand user")
					util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
				end
			elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Invalid]>Note")) then
				if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Invalid]>Note")) == "" then
					menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Invalid]>Note"), "Stand user")
					util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
				end
			elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Story Mode]>Note")) then
				if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Story Mode]>Note")) == "" then
					menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Story Mode]>Note"), "Stand user")
					util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
				end
			elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Offline]>Note")) then
				if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Offline]>Note")) == "" then
					menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Offline]>Note"), "Stand user")
					util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
				end
			end
		end
	end
end)

local function standuser()
	util.yield(10000)
	if menu.get_value(menu.ref_by_path("Stand>Lua Scripts>" ..SCRIPT_NAME.. ">Player zeug>Mark Stand user auto")) == true then
		for _, pid in players.list(false, true, true) do
			if is_user_a_stand_user(pid) or pid == players.user() and not util.is_session_transition_active(players.user) then
				if menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. ">Note")) then
					if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. ">Note")) == "" then
						menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. ">Note"), "Stand user")
						util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
				end
				elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Solo]>Note")) then
					if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Solo]>Note")) == "" then
						menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Solo]>Note"), "Stand user")
						util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
					end
				elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Invite]>Note")) then
					if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Invite]>Note")) == "" then
						menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Invite]>Note"), "Stand user")
						util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
					end
				elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Closed Friend]>Note")) then
					if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Closed Friend]>Note")) == "" then
						menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Closed Friend]>Note"), "Stand user")
						util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
					end
				elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Closed Crew]>Note")) then
					if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Closed Crew]>Note")) == "" then
						menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Closed Crew]>Note"), "Stand user")
						util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
					end
				elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Crew]>Note")) then
					if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Crew]>Note")) == "" then
						menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Crew]>Note"), "Stand user")
						util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
					end
				elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Public]>Note")) then
					if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Public]>Note")) == "" then
						menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Public]>Note"), "Stand user")
						util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
					end
				elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Invalid]>Note")) then
					if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Invalid]>Note")) == "" then
						menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Invalid]>Note"), "Stand user")
						util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
					end
				elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Story Mode]>Note")) then
					if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Story Mode]>Note")) == "" then
						menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Story Mode]>Note"), "Stand user")
						util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
					end
				elseif menu.is_ref_valid(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Offline]>Note")) then
					if menu.get_value(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Offline]>Note")) == "" then
						menu.trigger_command(menu.ref_by_path("Online>Player History>" ..players.get_name(pid).. " [Offline]>Note"), "Stand user")
						util.toast(players.get_name(pid).. " Wurde als Stand user Makiert", TOAST_ALL)
					end
				end
			end
		end
	end
end

players.on_join(standuser)

--[[menu.text_input(streamer, "streamer", {"plstream"}, "streamer eingeben", function(input)
	streamer = input
end, '')

menu.action(streamer, "add streamer (join)", {}, "streamer adden mit direkt join", function()
		menu.trigger_commands("historyadd " .. tostring(streamer))
		util.yield(800)
		menu.trigger_commands("historynote " .. tostring(streamer) .. " Streamer")
		util.yield(500)
		menu.trigger_commands("join " .. tostring(streamer))
end)

menu.action(streamer, "add streamer", {}, "streamer adden und öffnen in liste", function()
		menu.trigger_commands("historyadd " .. tostring(streamer))
		util.yield(800)
		menu.trigger_commands("historynote " .. tostring(streamer) .. " Streamer")
		util.yield(500)
		menu.trigger_commands("findplayer " .. tostring(streamer))
end)]]

menu.toggle(player_zeug, "player join nachricht", {}, "", function(on_toggle)
	if on_toggle then
		player_join = true
	else 
		player_join = false
	end
end)

local function playerjoinmassge(pid)
	if player_join then
		playername = players.get_name(pid)
		languages = players.get_language(pid)
		rockstarid = players.get_rockstar_id(pid)
		connectetip = players.get_connect_port(pid)
		ranklevel = players.get_rank(pid)
		money = players.get_money(pid)
		if languages == 0 then
			languagesname = "Englisch"
		elseif languages == 1 then
			languagesname = "Französisch"
		elseif languages == 2 then
			languagesname = "Deutsch"
		elseif languages == 3 then
			languagesname = "Italienisch"
		elseif languages == 4 then
			languagesname = "Spanisch"
		elseif languages == 5 then
			languagesname = "Brasilien"
		elseif languages == 6 then
			languagesname = "Polnisch"
		elseif languages == 7 then
			languagesname = "Russisch"
		elseif languages == 8 then
			languagesname = "Koreanisch"
		elseif languages == 9 then
			languagesname = "Chinesisch"
		elseif languages == 10 then
			languagesname = "Japanisch"
		elseif languages == 11 then
			languagesname = "Mexikanisch"
		elseif languages == 12 then
			languagesname = "Chinesisch"
		else 
			languagesname = "Keine Sprache dazu gefunden"
		end
		if util.is_session_transition_active() then
			if ranklevel == 0 or money == 0 then
				util.toast("Spieler Gejoint\n"..playername.."   ("..rockstarid..") / Sprache: "..languagesname, TOAST_CONSOLE)
			elseif PlayerisFriend(pid) then
				util.toast("Spieler Gejoint\n"..playername.."   ("..rockstarid..") / Sprache: "..languagesname.."\nLevel: "..ranklevel.."\nGeld: "..money, TOAST_CONSOLE)
			elseif PlayerisFriend(pid) and ranklevel == 0 or money == 0 then
				util.toast("Spieler Gejoint\n"..playername.."   ("..rockstarid..") / Sprache: "..languagesname, TOAST_CONSOLE)
			else
				util.toast("Spieler Gejoint\n"..playername.."   ("..rockstarid..") / Sprache: "..languagesname.."\nLevel: "..ranklevel.." / Geld: "..money, TOAST_CONSOLE)
			end
		else
			if ranklevel == 0 or money == 0 then
				util.toast("Spieler Gejoint\n"..playername.."   ("..rockstarid..") / Sprache: "..languagesname, TOAST_ALL)
			elseif PlayerisFriend(pid) then
				util.toast("Spieler Gejoint\n"..playername.."   ("..rockstarid..") / Sprache: "..languagesname.."\nLevel: "..ranklevel.." / Geld: "..money, TOAST_ALL)
			elseif PlayerisFriend(pid) and ranklevel == 0 or money == 0 then
				util.toast("Spieler Gejoint\n"..playername.."   ("..rockstarid..") / Sprache: "..languagesname, TOAST_ALL)
			else
				util.toast("Spieler Gejoint\n"..playername.."   ("..rockstarid..") / Sprache: "..languagesname.."\nLevel: "..ranklevel.." / Geld: "..money, TOAST_ALL)
			end
		end
	end
end

players.on_join(playerjoinmassge)

local actionen = menu.list(custselc, "actionen", {}, "")
local friendly = menu.list(actionen, "Friendly stuff", {}, "")
local kicken = menu.list(actionen, "Kick/crash stuff", {}, "")
local tp = menu.list(actionen, "TP", {}, "")
local trolling = menu.list(actionen, "Trolling", {}, "")
removeexclude = menu.divider(actionen, "Remove player from list")
-- custon selection begin
menu.toggle(custselc, "Exclude Selected", {"Excludeselected"}, "", function(on_toggle)
	if on_toggle then
		excludeselected = true
		excludeselected1 = menu.action(friendly, "!!!Exclude Selected ist AN!!!", {}, "drück drauf um nicht mehr Exclude selected an zu haben", function()
			menu.trigger_commands("excludeselected off")
		end)
		excludeselected2 = menu.action(kicken, "!!!Exclude Selected ist AN!!!", {}, "drück drauf um nicht mehr Exclude selected an zu haben", function()
			menu.trigger_commands("excludeselected off")
		end)
		excludeselected3 = menu.action(tp, "!!!Exclude Selected ist AN!!!", {}, "drück drauf um nicht mehr Exclude selected an zu haben", function()
			menu.trigger_commands("excludeselected off")
		end)
		excludeselected4 = menu.action(trolling, "!!!Exclude Selected ist AN!!!", {}, "drück drauf um nicht mehr Exclude selected an zu haben", function()
			menu.trigger_commands("excludeselected off")
		end)
		excludeselected5 = menu.action(actionen, "!!!Exclude Selected ist AN!!!", {}, "drück drauf um nicht mehr Exclude selected an zu haben", function()
			menu.trigger_commands("excludeselected off")
		end)
	else
		excludeselected = false
		menu.delete(excludeselected1)
		menu.delete(excludeselected2)
		menu.delete(excludeselected3)
		menu.delete(excludeselected4)
		menu.delete(excludeselected5)
	end
end)

menu.action(custselc, "seite reseten", {}, "passiert das bei mission ein fehler kommt einfach die seite hier mit reseten dann easy", function(pids)
	for pids = 0, 31 do
		if players.exists(pids) then
		if menu.is_ref_valid(menu.ref_by_command_name("selected" ..pids)) then
			menu.delete(cmd_id[pids])
			util.yield(10)
			if players.exists(pids) then
				cmd_id[pids] = menu.toggle(custselc, tostring(players.get_name(pids)), {"selected" .. pids}, "PID - ".. pids, function(on_toggle)
					if on_toggle then
						selectedplayer[pids] = true
						listfriendly[pids] = menu.action(friendly, tostring(players.get_name(pids)), {}, "PID - ".. pids, function()
							if players.user() and players.exists(pids) then
								menu.trigger_commands("selected" .. pids .. " " .. "off")
							else
								menu.delete(listfriendly[pids])
								menu.delete(listkicken[pids])
								menu.delete(listtp[pids])
								menu.delete(listtrolling[pids])
								menu.delete(listgenerel[pids])
							end
						end)
						listkicken[pids] = menu.action(kicken, tostring(players.get_name(pids)), {}, "PID - ".. pids, function()
							if players.user() and players.exists(pids) then
								menu.trigger_commands("selected" .. pids .. " " .. "off")
							else
								menu.delete(listfriendly[pids])
								menu.delete(listkicken[pids])
								menu.delete(listtp[pids])
								menu.delete(listtrolling[pids])
								menu.delete(listgenerel[pids])
							end
						end)
						listtp[pids] = menu.action(tp, tostring(players.get_name(pids)), {}, "PID - ".. pids, function()
							if players.user() and players.exists(pids) then
								menu.trigger_commands("selected" .. pids .. " " .. "off")
							else
								menu.delete(listfriendly[pids])
								menu.delete(listkicken[pids])
								menu.delete(listtp[pids])
								menu.delete(listtrolling[pids])
								menu.delete(listgenerel[pids])
							end
						end)
						listtrolling[pids] = menu.action(trolling, tostring(players.get_name(pids)), {}, "PID - ".. pids, function()
							if players.user() and players.exists(pids) then
								menu.trigger_commands("selected" .. pids .. " " .. "off")
							else
								menu.delete(listfriendly[pids])
								menu.delete(listkicken[pids])
								menu.delete(listtp[pids])
								menu.delete(listtrolling[pids])
								menu.delete(listgenerel[pids])
							end
						end)
						listgenerel[pids] = menu.action(actionen, tostring(players.get_name(pids)), {}, "PID - ".. pids, function()
							if players.user() and players.exists(pids) then
								menu.trigger_commands("selected" .. pids .. " " .. "off")
							else
								menu.delete(listfriendly[pids])
								menu.delete(listkicken[pids])
								menu.delete(listtp[pids])
								menu.delete(listtrolling[pids])
								menu.delete(listgenerel[pids])
							end
						end)
					else
						selectedplayer[pids] = false
						menu.delete(listfriendly[pids])	
						menu.delete(listkicken[pids])
						menu.delete(listtp[pids])
						menu.delete(listtrolling[pids])
						menu.delete(listgenerel[pids])
					end
				end)
			end
		end
		end
	end
end)
menu.divider(custselc, "Players")

menu.action(friendly, "automatisches healen ON", {}, "", function()
	for pids = 0, 31 do
		if excludeselected then
			if pids ~= players.user() and not selectedplayer[pids] and players.exists(pids) then
						  menu.trigger_commands("autoheal " .. GET_PLAYER_NAME(pids) .. " on")
				util.yield()
			end
		else
			if pids ~= players.user() and selectedplayer[pids] and players.exists(pids) then
						   menu.trigger_commands("autoheal " .. GET_PLAYER_NAME(pids) .. " on")
				util.yield()
			end
		end
	end
end)

menu.action(friendly, "automatisches healen OFF", {}, "", function()
	for pids = 0, 31 do
		if excludeselected then
			if pids ~= players.user() and not selectedplayer[pids] and players.exists(pids) then
						  menu.trigger_commands("autoheal " .. GET_PLAYER_NAME(pids) .. " off")
				util.yield()
			end
		else
			if pids ~= players.user() and selectedplayer[pids] and players.exists(pids) then
						   menu.trigger_commands("autoheal " .. GET_PLAYER_NAME(pids) .. " off")
				util.yield()
			end
		end
	end
end)

menu.action(friendly, "Nie Gefahndet ON", {}, "", function()
	for pids = 0, 31 do
		if excludeselected then
			if pids ~= players.user() and not selectedplayer[pids] and players.exists(pids) then
						  menu.trigger_commands("bail " .. GET_PLAYER_NAME(pids) .. " on")
				util.yield()
			end
		else
			if pids ~= players.user() and selectedplayer[pids] and players.exists(pids) then
						   menu.trigger_commands("bail " .. GET_PLAYER_NAME(pids) .. " on")
				util.yield()
			end
		end
	end
end)

menu.action(friendly, "Nie Gefahndet OFF", {}, "", function()
	for pids = 0, 31 do
		if excludeselected then
			if pids ~= players.user() and not selectedplayer[pids] and players.exists(pids) then
						  menu.trigger_commands("bail " .. GET_PLAYER_NAME(pids) .. " off")
				util.yield()
			end
		else
			if pids ~= players.user() and selectedplayer[pids] and players.exists(pids) then
						   menu.trigger_commands("bail " .. GET_PLAYER_NAME(pids) .. " off")
				util.yield()
			end
		end
	end
end)

menu.action(friendly, "Vom Rader Verschwinde ON", {}, "", function()
	for pids = 0, 31 do
		if excludeselected then
			if pids ~= players.user() and not selectedplayer[pids] and players.exists(pids) then
						  menu.trigger_commands("giveotr " .. GET_PLAYER_NAME(pids) .. " on")
				util.yield()
			end
		else
			if pids ~= players.user() and selectedplayer[pids] and players.exists(pids) then
						   menu.trigger_commands("giveotr " .. GET_PLAYER_NAME(pids) .. " on")
				util.yield()
			end
		end
	end
end)

menu.action(friendly, "Vom Rader Verschwinde OFF", {}, "", function()
	for pids = 0, 31 do
		if excludeselected then
			if pids ~= players.user() and not selectedplayer[pids] and players.exists(pids) then
						  menu.trigger_commands("giveotr " .. GET_PLAYER_NAME(pids) .. " off")
				util.yield()
			end
		else
			if pids ~= players.user() and selectedplayer[pids] and players.exists(pids) then
						   menu.trigger_commands("giveotr " .. GET_PLAYER_NAME(pids) .. " off")
				util.yield()
			end
		end
	end
end)


menu.action(kicken, "modder kicken", {}, "kicked alle die eine modder flag haben", function()
	for pids = 0, 31 do
		if excludeselected then
			if pids ~= players.user() and not selectedplayer[pids] and players.exists(pids) and players.is_marked_as_modder(pids) then
						  menu.trigger_commands("kick " .. GET_PLAYER_NAME(pids))
				util.yield()
			end
		else
			if pids ~= players.user() and selectedplayer[pids] and players.exists(pids) and players.is_marked_as_modder(pids) then
						   menu.trigger_commands("kick " .. GET_PLAYER_NAME(pids))
				util.yield()
			end
		end
	end
end)


menu.action(kicken, "Kick", {}, "", function()
	for pids = 0, 31 do
		if excludeselected then
			if pids ~= players.user() and not selectedplayer[pids] and players.exists(pids) then
							menu.trigger_commands("kick " .. GET_PLAYER_NAME(pids))
				util.yield()
			end
		else
			if pids ~= players.user() and selectedplayer[pids] and players.exists(pids) then
						   menu.trigger_commands("kick " .. GET_PLAYER_NAME(pids))
				util.yield()
			end
		end
	end
end)


menu.action(kicken, "Crash", {}, "", function()
	for pids = 0, 31 do
		if excludeselected then
			if pids ~= players.user() and not selectedplayer[pids] and players.exists(pids) then
				menu.trigger_commands("ngcrash" .. GET_PLAYER_NAME(pids))
				menu.trigger_commands("ngcrash" .. GET_PLAYER_NAME(pids))
				menu.trigger_commands("ngcrash" .. GET_PLAYER_NAME(pids))
				menu.trigger_commands("ngcrash" .. GET_PLAYER_NAME(pids))
				menu.trigger_commands("ngcrash" .. GET_PLAYER_NAME(pids))
				menu.trigger_commands("ngcrash" .. GET_PLAYER_NAME(pids))
				menu.trigger_commands("ngcrash" .. GET_PLAYER_NAME(pids))
				menu.trigger_commands("ngcrash" .. GET_PLAYER_NAME(pids))
				menu.trigger_commands("ngcrash" .. GET_PLAYER_NAME(pids))
				util.toast("SE Crash has been sent to " .. GET_PLAYER_NAME(pids), TOAST_ALL)
			end
		else
			if pids ~= players.user() and selectedplayer[pids] and players.exists(pids) then
				menu.trigger_commands("ngcrash" .. GET_PLAYER_NAME(pids))
				menu.trigger_commands("ngcrash" .. GET_PLAYER_NAME(pids))
				menu.trigger_commands("ngcrash" .. GET_PLAYER_NAME(pids))
				menu.trigger_commands("ngcrash" .. GET_PLAYER_NAME(pids))
				menu.trigger_commands("ngcrash" .. GET_PLAYER_NAME(pids))
				menu.trigger_commands("ngcrash" .. GET_PLAYER_NAME(pids))
				menu.trigger_commands("ngcrash" .. GET_PLAYER_NAME(pids))
				menu.trigger_commands("ngcrash" .. GET_PLAYER_NAME(pids))
				menu.trigger_commands("ngcrash" .. GET_PLAYER_NAME(pids))
				util.toast("SE Crash has been sent to " .. GET_PLAYER_NAME(pids), TOAST_ALL)
			end
		end
	end
end)

menu.action(tp, "Richtiges Teleportiren", {}, "Teleportiert die zu dir", function()
	for pids = 0, 31 do
		if excludeselected then
			if pids ~= players.user() and not selectedplayer[pids] and players.exists(pids) then
				local ped = GET_PLAYER_PED_SCRIPT_INDEX(pids)
				local pos = players.get_position(players.user())
				local ppos = players.get_position(pids)
				local vehin = IS_PED_IN_ANY_VEHICLE(ped, true)
				menu.trigger_commands("summon"..GET_PLAYER_NAME(pids))
				if (VDIST2(pos.x,pos.y,pos.z,ppos.x,ppos.y,ppos.z) >= 1000000) then
					util.yield(3500)
					util.toast("TP " .. GET_PLAYER_NAME(pids))
				else
					util.toast("TP " .. GET_PLAYER_NAME(pids))
					util.yield(2000)
				end
			end
		else
			if pids ~= players.user() and selectedplayer[pids] and players.exists(pids) then
				local ped = GET_PLAYER_PED_SCRIPT_INDEX(pids)
				local pos = players.get_position(players.user())
				local ppos = players.get_position(pids)
				local vehin = IS_PED_IN_ANY_VEHICLE(ped, true)
				menu.trigger_commands("summon"..GET_PLAYER_NAME(pids))
				if (VDIST2(pos.x,pos.y,pos.z,ppos.x,ppos.y,ppos.z) >= 1000000) then
					util.yield(3500)
					util.toast("TP " .. GET_PLAYER_NAME(pids))
				else
					util.toast("TP " .. GET_PLAYER_NAME(pids))
					util.yield(2000)
				end
			end
		end
	end
end)

menu.action(tp, "apr Teleportiren", {}, "Teleportiert die in die nähe von dir in ein apartment", function()
	for pids = 0, 31 do
		if excludeselected then
			if pids ~= players.user() and not selectedplayer[pids] and players.exists(pids) then
				local ped = GET_PLAYER_PED_SCRIPT_INDEX(pids)
				menu.trigger_commands("aptme" .. GET_PLAYER_NAME(pids))
				util.toast("TP " .. GET_PLAYER_NAME(pids))
				util.yield(2000)
			end
		else
			if pids ~= players.user() and selectedplayer[pids] and players.exists(pids) then
				local ped = GET_PLAYER_PED_SCRIPT_INDEX(pids)
				menu.trigger_commands("aptme" .. GET_PLAYER_NAME(pids))
				util.toast("TP " .. GET_PLAYER_NAME(pids))
				util.yield(2000)
			end
		end
	end
end)

menu.toggle(tp, "Apartments anzeigen", {}, "Die werden mit Zahlen angezeigt", function(on_toggle)
	if on_toggle then
		menu.trigger_commands("showapartments " .. "on")
	else
		menu.trigger_commands("showapartments " .. "off")
	end
end)


menu.action(tp, "auto Teleportiren", {}, "TP nur leute die in einem auto sitzen sonst nicht", function()
	for pids = 0, 31 do
		local ped = GET_PLAYER_PED_SCRIPT_INDEX(pids)
		if excludeselected then
			if pids ~= players.user() and not selectedplayer[pids] and players.exists(pids) then
					if IS_PED_IN_ANY_VEHICLE(ped,true) then
						menu.trigger_commands("demigodmode " .. "on")
						menu.trigger_commands("summon " .. GET_PLAYER_NAME(pids))
						util.toast("auto TP " .. GET_PLAYER_NAME(pids))
						util.yield(2000)
						menu.trigger_commands("demigodmode " .. "off")
					else
						menu.trigger_commands("spectate" .. GET_PLAYER_NAME(pids) .. " on")
						util.yield(3000)
						if IS_PED_IN_ANY_VEHICLE(ped,true) then
							menu.trigger_commands("demigodmode " .. "on")
							menu.trigger_commands("summon " .. GET_PLAYER_NAME(pids))
							menu.trigger_commands("spectate" .. GET_PLAYER_NAME(pids) .. " off")
							util.toast("auto TP " .. GET_PLAYER_NAME(pids))
							util.yield(2000)
							menu.trigger_commands("demigodmode " .. "off")
						else
							menu.trigger_commands("spectate" .. GET_PLAYER_NAME(pids) .. " off")
							util.toast("ist nicht im auto " .. GET_PLAYER_NAME(pids))
							util.yield(2000)
						end
					end
			end
		else
			if pids ~= players.user() and selectedplayer[pids] and players.exists(pids) then
					if IS_PED_IN_ANY_VEHICLE(ped,true) then
						menu.trigger_commands("demigodmode " .. "on")
						menu.trigger_commands("summon " .. GET_PLAYER_NAME(pids))
						util.toast("auto TP " .. GET_PLAYER_NAME(pids))
						util.yield(2000)
						menu.trigger_commands("demigodmode " .. "off")
					else
						menu.trigger_commands("spectate" .. GET_PLAYER_NAME(pids) .. " on")
						util.yield(3000)
						if IS_PED_IN_ANY_VEHICLE(ped,true) then
							menu.trigger_commands("demigodmode " .. "on")
							menu.trigger_commands("summon " .. GET_PLAYER_NAME(pids))
							menu.trigger_commands("spectate" .. GET_PLAYER_NAME(pids) .. " off")
							util.toast("auto TP " .. GET_PLAYER_NAME(pids))
							util.yield(2000)
							menu.trigger_commands("demigodmode " .. "off")
						else
							menu.trigger_commands("spectate" .. GET_PLAYER_NAME(pids) .. " off")
							util.toast("ist nicht im auto " .. GET_PLAYER_NAME(pids))
							util.yield(2000)
						end
					end
			end
		end
	end
end)


menu.action(trolling, "Vehicle Kick", {}, "", function()
	for pids = 0, 31 do
		if excludeselected then
			if pids ~= players.user() and not selectedplayer[pids] and players.exists(pids) then
				local ped = GET_PLAYER_PED_SCRIPT_INDEX(pids)
				menu.trigger_commands("vehkick" .. GET_PLAYER_NAME(pids))
				util.toast("Vehicle Kick has been sent to " .. GET_PLAYER_NAME(pids))
			end
		else
			if pids ~= players.user() and selectedplayer[pids] and players.exists(pids) then
				local ped = GET_PLAYER_PED_SCRIPT_INDEX(pids)
				menu.trigger_commands("vehkick" .. GET_PLAYER_NAME(pids))
				util.toast("Vehicle Kick has been sent to " .. GET_PLAYER_NAME(pids))
			end
		end
	end
end)


menu.action(trolling, "Freeze on", {}, "", function()
	for pids = 0, 31 do
		if excludeselected then
			if pids ~= players.user() and not selectedplayer[pids] and players.exists(pids) then
				menu.trigger_commands("freeze" .. GET_PLAYER_NAME(pids) .. " " .. "on")
				util.toast("Freeze ist jetzt an " .. GET_PLAYER_NAME(pids))
			end
		else
			if pids ~= players.user() and selectedplayer[pids] and players.exists(pids) then
				menu.trigger_commands("freeze" .. GET_PLAYER_NAME(pids) .. " " .. "on")
				util.toast("Freeze ist jetzt an " .. GET_PLAYER_NAME(pids))
			end
		end
	end
end)


menu.action(trolling, "Freeze off", {}, "", function()
	for pids = 0, 31 do
		if excludeselected then
			if pids ~= players.user() and not selectedplayer[pids] and players.exists(pids) then
				menu.trigger_commands("freeze" .. GET_PLAYER_NAME(pids) .. " " .. "off")
				util.toast("Freeze ist jetzt aus für " .. GET_PLAYER_NAME(pids))
			end
		else
			if pids ~= players.user() and selectedplayer[pids] and players.exists(pids) then
				menu.trigger_commands("freeze" .. GET_PLAYER_NAME(pids) .. " " .. "off")
				util.toast("Freeze ist jetzt aus für " .. GET_PLAYER_NAME(pids))
			end
		end
	end
end)

menu.divider(friendly, "Selected Players")
menu.divider(kicken, "Selected Players")
menu.divider(tp, "Selected Players")
menu.divider(trolling, "Selected Players")

for pids = 0, 31 do
	if players.exists(pids) then
		cmd_id[pids] = menu.toggle(custselc, tostring(players.get_name(pids)), {"selected" .. pids}, "PID - ".. pids, function(on_toggle)
			if on_toggle then
				selectedplayer[pids] = true
				listfriendly[pids] = menu.action(friendly, tostring(players.get_name(pids)), {}, "PID - ".. pids, function()
					if players.user() and players.exists(pids) then
						menu.trigger_commands("selected" .. pids .. " " .. "off")
					else
						menu.delete(listfriendly[pids])
						menu.delete(listkicken[pids])
						menu.delete(listtp[pids])
						menu.delete(listtrolling[pids])
						menu.delete(listgenerel[pids])
					end
				end)
				listkicken[pids] = menu.action(kicken, tostring(players.get_name(pids)), {}, "PID - ".. pids, function()
					if players.user() and players.exists(pids) then
						menu.trigger_commands("selected" .. pids .. " " .. "off")
					else
						menu.delete(listfriendly[pids])
						menu.delete(listkicken[pids])
						menu.delete(listtp[pids])
						menu.delete(listtrolling[pids])
						menu.delete(listgenerel[pids])
					end
				end)
				listtp[pids] = menu.action(tp, tostring(players.get_name(pids)), {}, "PID - ".. pids, function()
					if players.user() and players.exists(pids) then
						menu.trigger_commands("selected" .. pids .. " " .. "off")
					else
						menu.delete(listfriendly[pids])
						menu.delete(listkicken[pids])
						menu.delete(listtp[pids])
						menu.delete(listtrolling[pids])
						menu.delete(listgenerel[pids])
					end
				end)
				listtrolling[pids] = menu.action(trolling, tostring(players.get_name(pids)), {}, "PID - ".. pids, function()
					if players.user() and players.exists(pids) then
						menu.trigger_commands("selected" .. pids .. " " .. "off")
					else
						menu.delete(listfriendly[pids])
						menu.delete(listkicken[pids])
						menu.delete(listtp[pids])
						menu.delete(listtrolling[pids])
						menu.delete(listgenerel[pids])
					end
				end)
				listgenerel[pids] = menu.action(actionen, tostring(players.get_name(pids)), {}, "PID - ".. pids, function()
					if players.user() and players.exists(pids) then
						menu.trigger_commands("selected" .. pids .. " " .. "off")
					else
						menu.delete(listfriendly[pids])
						menu.delete(listkicken[pids])
						menu.delete(listtp[pids])
						menu.delete(listtrolling[pids])
						menu.delete(listgenerel[pids])
					end
				end)
			else
				selectedplayer[pids] = false
				menu.delete(listfriendly[pids])	
				menu.delete(listkicken[pids])
				menu.delete(listtp[pids])
				menu.delete(listtrolling[pids])
				menu.delete(listgenerel[pids])
			end
		end)
	end
end

local function update_join(pid)
	util.yield(300)
local name = players.get_name(pid)
cmd_id[pid] = menu.toggle(custselc, name, {"selected" .. pid}, "PID - ".. pid, function(on_toggle)
	if on_toggle then
		selectedplayer[pid] = true
		listfriendly[pid] = menu.action(friendly, tostring(players.get_name(pid)), {}, "PID - ".. pid, function()
			if players.user() and players.exists(pid) then
				menu.trigger_commands("selected" .. pid .. " " .. "off")
			else
				menu.delete(listfriendly[pid])
				menu.delete(listkicken[pid])
				menu.delete(listtp[pid])
				menu.delete(listtrolling[pid])
				menu.delete(listgenerel[pid])
			end
		end)
		listkicken[pid] = menu.action(kicken, tostring(players.get_name(pid)), {}, "PID - ".. pid, function()
			if players.user() and players.exists(pid) then
				menu.trigger_commands("selected" .. pid .. " " .. "off")
			else
				menu.delete(listfriendly[pid])
				menu.delete(listkicken[pid])
				menu.delete(listtp[pid])
				menu.delete(listtrolling[pid])
				menu.delete(listgenerel[pid])
			end
		end)
		listtp[pid] = menu.action(tp, tostring(players.get_name(pid)), {}, "PID - ".. pid, function()
			if players.user() and players.exists(pid) then
				menu.trigger_commands("selected" .. pid .. " " .. "off")
			else
				menu.delete(listfriendly[pid])
				menu.delete(listkicken[pid])
				menu.delete(listtp[pid])
				menu.delete(listtrolling[pid])
				menu.delete(listgenerel[pid])
			end
		end)
		listtrolling[pid] = menu.action(trolling, tostring(players.get_name(pid)), {}, "PID - ".. pid, function()
			if players.user() and players.exists(pid) then
				menu.trigger_commands("selected" .. pid .. " " .. "off")
			else
				menu.delete(listfriendly[pid])
				menu.delete(listkicken[pid])
				menu.delete(listtp[pid])
				menu.delete(listtrolling[pid])
				menu.delete(listgenerel[pid])
			end
		end)
		listgenerel[pid] = menu.action(actionen, tostring(players.get_name(pid)), {}, "PID - ".. pid, function()
			if players.user() and players.exists(pid) then
				menu.trigger_commands("selected" .. pid .. " " .. "off")
			else
				menu.delete(listfriendly[pid])
				menu.delete(listkicken[pid])
				menu.delete(listtp[pid])
				menu.delete(listtrolling[pid])
				menu.delete(listgenerel[pid])
			end
		end)
	else
				selectedplayer[pid] = false
				menu.delete(listfriendly[pid])	
				menu.delete(listkicken[pid])
				menu.delete(listtp[pid])
				menu.delete(listtrolling[pid])
				menu.delete(listgenerel[pid])
	end
end)
end

local function update_leave(pid)
	if menu.get_value(menu.ref_by_command_name("selected" ..pid)) == true then
		menu.trigger_commands("selected" .. pid .. " " .. "off")
		util.yield(200)
		menu.delete(cmd_id[pid])
	else
		menu.delete(cmd_id[pid])
	end
end

GenerateFeatures = function(pid)
cage = util.joaat("prop_gascage01")
ladder = 1888301071
ground = -1951226014
attach = 1
veh_to_attach = 1

function v3_2(x, y, z)
	if x == nil then
		x = 0
	end
	if y == nil then
		y = 0
	end
	if z == nil then
		z = 0
	end
end
end

local InitialPlayersList = players.list(true, true, true)
for i = 1, #InitialPlayersList do
GenerateFeatures(InitialPlayersList[i])
end

players.on_join(GenerateFeatures)
players.on_leave(update_leave)
players.on_join(update_join)

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

menu.toggle(Zeug_für_mich, "schnell Fahren Mit Stand", {}, "", function(on_toggle)
	if on_toggle then
		menu.trigger_command(menu.ref_by_path("Vehicle>Movement>Engine Power Multiplier"), "20")
		repeat
			util.yield()
		until GET_IS_TASK_ACTIVE(players.user_ped(),2) or not IS_PED_IN_ANY_VEHICLE(players.user_ped(),true)
		menu.trigger_command(menu.ref_by_path("Stand>Lua Scripts>".. SCRIPT_NAME ..">Zeug für mich angepasst>schnell Fahren"), false)
		util.toast("schnell fahren wurde ausgeschaltet")
	else
		menu.trigger_command(menu.ref_by_path("Vehicle>Movement>Engine Power Multiplier"), "0")
	end
end)

menu.toggle_loop(Zeug_für_mich, "Schnell fahren V2 (besser)", {}, "", function()
	local keyCode = getKeyCode('VK_W')
	local keyCode1 = getKeyCode('VK_S')
	local vehicle = GET_VEHICLE_PED_IS_IN(players.user_ped())
	local currentSpeed = GET_ENTITY_SPEED(vehicle)
	umrechnung = a / 10
	if util.is_key_down(keyCode) and IS_PED_IN_ANY_VEHICLE(players.user_ped()) then
		APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(vehicle, 1, 0.0, umrechnung, 0.0, true, true, true, true)
	elseif util.is_key_down(keyCode1) and IS_PED_IN_ANY_VEHICLE(players.user_ped()) then
		APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(vehicle, 1, 0.0, -umrechnung, 0.0, true, true, true, true)
	end
end)

menu.slider(Zeug_für_mich, "Schnell fahren boost einstellen V2", {"selfspeedboost"}, "[0 - 50]\ngib die kmh an auf die es boosten soll", 1,50, 1, 1, function(boost)
	a = boost
end)

menu.click_slider(Zeug_für_mich, "speed boost", {"selfboostsset"}, "[50 - 10000]\ngib die kmh an auf die es boosten soll", 50 ,10000, 0, 50, function(s)
	speed = s
	speedset = s / 3.6
	local vehicle = GET_VEHICLE_PED_IS_IN(players.user_ped())
	if IS_PED_IN_ANY_VEHICLE(players.user_ped()) then
		SET_VEHICLE_FORWARD_SPEED(vehicle, speedset)
	end
end)

menu.action(Zeug_für_mich, "sofort anhalten", {}, "", function()
	local vehicle = GET_VEHICLE_PED_IS_IN(players.user_ped())
	if IS_PED_IN_ANY_VEHICLE(players.user_ped(),true) then
		FREEZE_ENTITY_POSITION(vehicle, true)
		FREEZE_ENTITY_POSITION(vehicle, false)
	else
		menu.trigger_command(menu.ref_by_path("Self>Movement>Freeze"), true)
		menu.trigger_command(menu.ref_by_path("Self>Movement>Freeze"), false)
	end
end)

menu.action(Zeug_für_mich,"Auto Reparieren", {}, "", function()
	if IS_PED_IN_ANY_VEHICLE(players.user_ped(),true) then
		local vehicle = GET_VEHICLE_PED_IS_IN(players.user_ped())
		local currentSpeed = GET_ENTITY_SPEED(vehicle)
		local seatplayer = GET_PED_IN_VEHICLE_SEAT(vehicle, -1, true)
		if seatplayer == players.user_ped() then
			SET_VEHICLE_FIXED(vehicle)
			if currentSpeed > 80 then
				SET_VEHICLE_FORWARD_SPEED(vehicle, currentSpeed)
			end
		else
			SET_VEHICLE_FIXED(vehicle)
		end
	end
end)

menu.action(Zeug_für_mich,"test ding", {}, "", function()
	local myposition = players.get_position(players.user())
	local playerveh = GET_VEHICLE_PED_IS_IN(players.user_ped())
	local positionveh = GET_WORLD_POSITION_OF_ENTITY_BONE(playerveh)
	TASK_LEAVE_VEHICLE(players.user_ped(), playerveh, 16)
	START_PLAYER_TELEPORT(players.user(),positionveh,false,true,false)
	util.toast(positionveh)
end)

timer2 = 0
menu.toggle_loop(Zeug_für_mich, "instant veh enter/exit", {}, "halte F gedrückt dann setzt du dich in das auto was dir am nächsten ist in den settings kann man auswählen wie lange man drücken soll", function()
	local keyCode = getKeyCode("VK_F")
	timer1 = 0
	if not IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
	while util.is_key_down(keyCode) do
		timer1 += 1
		if timer1 == abb and util.is_key_down(keyCode) then
			util.toast("enter vehicle")
			timer1 = 0
			local myposition = players.get_position(players.user())
			local mypositionvehicle = getClosestVehicle(myposition)
			local ped = GET_PED_IN_VEHICLE_SEAT(mypositionvehicle, -1, true)
		if IS_PED_A_PLAYER(ped) and not (ped == players.user_ped()) then
			local pid = GET_NEAREST_PLAYER_TO_ENTITY(ped)
			local getplayername = players.get_name(pid)
			if not ifplayerincar then
				if ARE_ANY_VEHICLE_SEATS_FREE(mypositionvehicle) then
					if IS_VEHICLE_SEAT_FREE(mypositionvehicle, 0) then
						SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, 0)
					elseif  IS_VEHICLE_SEAT_FREE(mypositionvehicle, 1) then
						SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, 1)
					elseif  IS_VEHICLE_SEAT_FREE(mypositionvehicle, 2) then
						SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, 2)
					elseif  IS_VEHICLE_SEAT_FREE(mypositionvehicle, 3) then
						SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, 3)
					elseif  IS_VEHICLE_SEAT_FREE(mypositionvehicle, 4) then
						SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, 4)
					else
						util.toast("konnte dich in keinen sitz setzen")
						repeat
							util.yield()
						until not util.is_key_down(keyCode)
						break
					end
					repeat
						util.yield()
					until not util.is_key_down(keyCode)
					break
				else
					util.toast("es sind keine sitze frei")
					repeat
						util.yield()
					until not util.is_key_down(keyCode)
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
									break
								end
						until IS_VEHICLE_SEAT_FREE(mypositionvehicle, -1)
							SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, -1)
							repeat
								util.yield()
							until not util.is_key_down(keyCode)
							break
						end
					end
		else
			if not ifnpcincar then
				if not (ped == 0) and not (players.user_ped() == ped) then
		   			entities.delete_by_handle(ped)
					SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, -1)
				else
					SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, -1)
					SET_VEHICLE_ENGINE_ON(mypositionvehicle, true, true, true)
				end
				repeat
					util.yield()
				until not util.is_key_down(keyCode)
				break
			else
				if ARE_ANY_VEHICLE_SEATS_FREE(mypositionvehicle) then
					if IS_VEHICLE_SEAT_FREE(mypositionvehicle, 0) then
							SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, 0)
					elseif  IS_VEHICLE_SEAT_FREE(mypositionvehicle, 1) then
						SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, 1)
					elseif  IS_VEHICLE_SEAT_FREE(mypositionvehicle, 2) then
						SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, 2)
					elseif  IS_VEHICLE_SEAT_FREE(mypositionvehicle, 3) then
						SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, 3)
					elseif  IS_VEHICLE_SEAT_FREE(mypositionvehicle, 4) then
						SET_PED_INTO_VEHICLE(players.user_ped(), mypositionvehicle, 4)
					else
						util.toast("konnte dich in keinen sitz setzen")
						repeat
							util.yield()
						until not util.is_key_down(keyCode)
						break
					end
					repeat
						util.yield()
					until not util.is_key_down(keyCode)
					break
				else
					util.toast("es sind keine sitze frei")
					repeat
						util.yield()
					until not util.is_key_down(keyCode)
					break
				end
			end
		end
		end
		util.yield()
	end
	else
		local playernameself = players.get_name(players.user())
		local myposition = players.get_position(players.user())
		local mypositionvehicle = getClosestVehicle(myposition)
		local positionvehicleding = GET_WORLD_POSITION_OF_ENTITY_BONE(mypositionvehicle)
		timer1 = 0
		while util.is_key_down(keyCode) do
			timer1 += 1
			util.yield()
			if timer1 == bba and util.is_key_down(keyCode) then
				util.toast("exit vehicle")
				menu.trigger_commands("freeze"..playernameself.." on")
				util.yield(20)
				menu.trigger_commands("freeze"..playernameself.." off")
				repeat
					util.yield()
				until not util.is_key_down(keyCode)
				break
				--TASK_LEAVE_VEHICLE(players.user_ped(), mypositionvehicle, 16)
			end
		end
	end
end)

--[[menu.slider(Zeug_für_mich, "Schnell fahren boost einstellen", {"selfspeedboost"}, "[0 - 20]\ngib die kmh an auf die es boosten soll", 0 ,20, 0, 1, function(a)
	boost = a
end)]]

menu.toggle_loop(Zeug_für_mich, "radio immer aus", {}, "", function()
	if IS_PED_IN_ANY_VEHICLE(players.user_ped(), true) then
		SET_RADIO_TO_STATION_NAME("OFF")
	end
end)

--[[(JSkey.is_key_just_down('VK_R') or JSkey.is_control_just_pressed(0, 'INPUT_COVER'))

]]
local settings = menu.list(menu.my_root(), "Settings", {}, "", function(); end)
	
menu.action(settings, "update suchen", {}, "", function()
	util.restart_script()
end)

local entitymanagersettings = menu.list(settings, "Entity manager settings", {}, "", function(); end)
local anderesettings = menu.list(settings, "Fast enter/exit settings", {}, "", function(); end)

menu.toggle(anderesettings, "npc auto klauen oder beifahrer", {}, "AN = beifahrer\nAUS = klauen", function(on_toggle)
	if on_toggle then
		ifnpcincar = true
	else
		ifnpcincar = false
	end
end)

menu.toggle(anderesettings, "spieler auto klauen oder beifahrer", {}, "AUS = beifahrer\nAN = klauen", function(on_toggle)
	if on_toggle then
		ifplayerincar = true
	else
		ifplayerincar = false
	end
end)

menu.slider(anderesettings, "auto einsteigen settings", {"entertimer"}, "[5 - 100]\nwie lang es warten soll bis du einsteigst", 5,100, 10, 5, function(boost1)
	abb = boost1
end)

menu.slider(anderesettings, "auto aussteigen settings", {"exittimer"}, "[5 - 100]\nwie lang es warten soll bis du aussteigst", 5,100, 10, 5, function(boost2)
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

util.keep_running()
