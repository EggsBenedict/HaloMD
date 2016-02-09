api_version = "1.8.0.0"


function OnScriptUnload() end

function OnScriptLoad()
  register_callback(cb['EVENT_CHAT'], "OnChat")
  register_callback(cb['EVENT_VEHICLE_ENTER'], "OnEnterVehicle")
  register_callback(cb['EVENT_WEAPON_PICKUP'], "OnWeaponPickup")
  register_callback(cb['EVENT_GAME_START'], "OnGameStart")
  register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
end


--Goofing around with more censorship: Player Names
function OnPlayerJoin(PlayerIndex)
	
	local nameOriginal = get_var(PlayerIndex,"$name") 
	local name = get_var(PlayerIndex,"$name")
	name = string.lower(name)
    name = string.gsub(name, "%s+", "")
	
-- Ban people with bad names - change 'filter' and 'list' as appropriate
	if string.find(name, "filter")
       or string.find(name, "list")
      then
      say(PlayerIndex, "You are being banned for 30 minutes.")
      say(PlayerIndex, "Remove bigoted words like 'filter' and 'list'")
      say(PlayerIndex, " -- CHANGE YOUR NAME: ".. nameOriginal .. " -- ")
      timer(5000, "BadName", nameOriginal)
    end    
end

function BadName(nameOriginal)
 execute_command("b " .. nameOriginal .. " 30 Name")
 return false
end


--Spawn some fun new vehicles at gamestart
function OnGameStart(PlayerIndex, Message)

  spawn_object("vehi","altis\\vehicles\\grackle\\grackle",143.0112,38.48454,0.4766581,3.127) --Blue Base Front
  spawn_object("vehi","altis\\vehicles\\grackle\\grackle",-122.9902,-66.43935,1.040748,5.997) --Red Base Front (not rotated well ... close enough)
  spawn_object("vehi","vehicles\\newhog\\newhog mp_warthog",-138.23,-69.32,1.31) --Red Base Platform
  spawn_object("vehi","vehicles\\newhog\\newhog mp_warthog",159.08,34.14,0.63) --Blue Base Roof
  spawn_object("vehi","altis\\vehicles\\truck_katyusha\\truck_katyusha",-12.98,82.89,13.16) -- Cliffs near rocket hog
  spawn_object("vehi","altis\\vehicles\\mortargoose\\mortargoose",143.095,34.41719,0.3329391,3.12) -- Blue Base Front
  spawn_object("vehi","altis\\vehicles\\mortargoose\\mortargoose",-124.2996,-62.03518,1.026704,5.917) -- Red Base Front (not rotated well ... close enough)
  --TURRETS: Not sure what the invisible things do ... but they're present in Archon so they've been added.
  spawn_object("vehi", "halo 4\\objects\\vehicles\\human\\turrets\\storm_unsc_artillery\\unsc_artillery_mp", 146.78,40.14,3.91485,2.3562) -- Turret Blue
  spawn_object("vehi", "halo 4\\objects\\vehicles\\human\\turrets\\storm_unsc_artillery\\invisible\\invisible", 146.7906,40.13233,3.853506,2.3562) -- AI Marker? Blue
  spawn_object("vehi", "halo 4\\objects\\vehicles\\human\\turrets\\storm_unsc_artillery\\unsc_artillery_mp", -126.018,-68.8483,4.55,5.8469) --Turret Red
  spawn_object("vehi", "halo 4\\objects\\vehicles\\human\\turrets\\storm_unsc_artillery\\invisible\\invisible", -126.0285,-68.8475,4.458775,5.8469) -- AI Marker? Red

end

--Function evaluates players vehilce and allows for specific actions to take place for specific vehilces
function OnEnterVehicle(PlayerIndex)
	local player_dyn = get_dynamic_player(PlayerIndex)
	if(player_dyn ~= 0) then
		local vehicle = read_dword(player_dyn + 0x11C)
		if (vehicle ~= -1) then 
			local mem = get_object_memory(vehicle)
			local tagid = read_dword(mem)
			--say(PlayerIndex, "VEHI TAG: "..tagid.." END")
			if(mem ~= 0) then
				-- Check if it's a tank. Standard strength of tank is 675pts
				if (tagid == 3881108961) then
	        		local tankS = 400
	        		write_float(mem+0xDC, tankS)
	        		say(PlayerIndex, "WARNING: WEAK TANK! Strength: "..tankS.. "pt(s)")
				end
			end
		end
	end
end

--These are some checks for bigoted language. Just for fun :)
function OnChat(PlayerIndex, Message)

    Message = string.lower(Message)
    --Message = string.gsub(Message, "%s+", "")
    
 	if string.find(name, "filter")
       or string.find(name, "list")
      then
      say(PlayerIndex, "This includes words like 'filter' and 'list'")
      say(PlayerIndex, " -- PLEASE DON'T USE BIGOTED LANGUAGE -- ")
      return false
    end    
end

--[[
--Shows TagID for weapon on pickup
function OnWeaponPickup(PlayerIndex, index)

  local name = get_var(PlayerIndex,"$name")

  if(name == "love") then
    local player_dyn = get_dynamic_player(PlayerIndex)
        local wep = read_dword(player_dyn + 0x2F8 + 4 * (index-1))
      local mem = get_object_memory(wep)
      if(mem ~= 0) then
        local tagid = read_dword(mem)
                say(PlayerIndex, "TAG: "..tagid.." END")
            end
    end
end
--]]
