local csgo_weapons = require('gamesense/csgo_weapons')
local anti_aim = require('gamesense/antiaim_funcs')

local minimum_damage = ui.reference('RAGE', 'Aimbot', 'Minimum damage')
local non_minimum_damage = ui.new_slider('RAGE', 'Aimbot', 'Minimum damage fallback', 0, 126, 1, true, nil, 1, true)

local function vec2_distance(x1, y1, z1, x2, y2, z2)
	return math.sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2)
end

local function get_closest_entity()
	local me = entity.get_local_player()
	local entities = entity.get_players(true)
	
	local lx, ly, lz = entity.get_prop(me, "m_vecOrigin")
	local closest_ent, closest_distance = nil, math.huge

	local distance
	for i=1, #entities do
		local ex, ey, ez = entity.get_prop(entities[i], "m_vecOrigin")
		distance = vec2_distance(lx, ly, lz, ex, ey, ez)
	  
		if distance <= closest_distance then
			closest_ent = entities[i]
			closest_distance = distance
		end
	end

	return { closest_ent, distance }
end

local function on_run_command()
	local closest_entity = get_closest_entity()
	local closest_entity_health = entity.get_prop(closest_entity[1], "m_iHealth")

	local local_player = entity.get_local_player()
	local weapon_ent = entity.get_player_weapon(local_player)
	local weapon_idx = entity.get_prop(weapon_ent, "m_iItemDefinitionIndex")
	local weapon = csgo_weapons[weapon_idx]

	if closest_entity == nil or closest_entity_health == nil then return end
	if local_player == nil or not entity.is_alive(local_player) then return end
	if weapon == nil then return end

	if weapon.name == 'SCAR-20' or weapon.name == 'G3SG1' then
		if anti_aim.get_double_tap() then
			ui.set(minimum_damage, closest_entity_health/2)
		else
			ui.set(minimum_damage, ui.get(non_minimum_damage))
		end
	end
end

client.set_event_callback('run_command', on_run_command)
