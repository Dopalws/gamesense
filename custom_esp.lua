local csgo_weapons = require('gamesense/csgo_weapons')

local tab, container = 'LUA', 'A'
local label = ui.new_label(tab, container, 'Player ESP in lua')
local name = ui.new_checkbox(tab, container, 'Name')
local name_color = ui.new_color_picker(tab, container, 'Name color', 255, 255, 255, 255)
local box = ui.new_checkbox(tab, container, 'Bounding box')
local box_color = ui.new_color_picker(tab, container, 'Box color', 255, 255, 255, 255)
local skeleton = ui.new_checkbox(tab, container, 'Skeleton')
local skeleton_color = ui.new_color_picker(tab, container, 'Skeleton color', 255, 255, 255, 255)
local health = ui.new_checkbox(tab, container, 'Health')
local health_color = ui.new_color_picker(tab, container, 'Health color', 255, 255, 255, 255)
local distance = ui.new_checkbox(tab, container, 'Distance')
local distance_color = ui.new_color_picker(tab, container, 'Distance color', 255, 255, 255, 255)
local weapon = ui.new_checkbox(tab, container, 'Weapon text')
local weapon_color = ui.new_color_picker(tab, container, 'Weapon color', 255, 255, 255, 255)

local function round(value)
    return math.floor(value + 0.5)
end

local units_to_feet = function(units)
    local units_to_meters = units * 0.0254

    return units_to_meters * 3.281
end

local vec2_distance = function(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2)
end

local function on_paint()
    local players = entity.get_players(not enemies_only)

    for i=1,#players do
        enemy_players = players[i]
        local x1, y1, x2, y2, a = entity.get_bounding_box(enemy_players)

        if x1 ~= nil and y1 ~= nil and not entity.is_dormant(enemy_players) then
            -- Name
            if ui.get(name) then
                local enemy_name = entity.get_player_name(enemy_players)
                local r, g, b, a = ui.get(name_color)
                renderer.text(x1/2 + x2/2, y1 - 7, r, g, b, a, 'c', nil, enemy_name)
            end

            -- Bounding box
            if ui.get(box) then
                local r, g, b, a = ui.get(box_color)
                renderer.rectangle(x2 + 1, y1, 1, y2 - y1, r, g, b, a)
                renderer.rectangle(x2, y1, 1, y2 - y1, 0, 0, 0, a)
                renderer.rectangle(x2 + 2, y1, 1, y2 - y1, 0, 0, 0, a)

                renderer.rectangle(x1 + 1, y2, y2/2 - y1/2, 1, r, g, b, a)
                renderer.rectangle(x1 + 1, y2 - 1, y2/2 - y1/2, 1, 0, 0, 0, a)
                renderer.rectangle(x1 + 1, y2 + 1, y2/2 - y1/2, 1, 0, 0, 0, a)

                renderer.rectangle(x1 + 1, y1, 1, y2 - y1, r, g, b, a)
                renderer.rectangle(x1, y1, 1, y2 - y1, 0, 0, 0, a)
                renderer.rectangle(x1 + 2, y1, 1, y2 - y1, 0, 0, 0, a)

                renderer.rectangle(x1 + 1, y1, y2/2 - y1/2, 1, r, g, b, a)
                renderer.rectangle(x1 + 1, y1 - 1, y2/2 - y1/2, 1, 0, 0, 0, a)
                renderer.rectangle(x1 + 1, y1 + 1, y2/2 - y1/2, 1, 0, 0, 0, a)
            end

            -- Distance
            if ui.get(skeleton) then
                local r, g, b, a = ui.get(skeleton_color)

                local enemy_hitbox_head_x, enemy_hitbox_head_y, enemy_hitbox_head_z = entity.hitbox_position(enemy_players, 0)
                local head_x, head_y = renderer.world_to_screen(enemy_hitbox_head_x, enemy_hitbox_head_y, enemy_hitbox_head_z)

                local enemy_hitbox_neck_x, enemy_hitbox_neck_y, enemy_hitbox_neck_z = entity.hitbox_position(enemy_players, 1)
                local neck_x, neck_y = renderer.world_to_screen(enemy_hitbox_neck_x, enemy_hitbox_neck_y, enemy_hitbox_neck_z)

                local enemy_hitbox_body_x, enemy_hitbox_body_y, enemy_hitbox_body_z = entity.hitbox_position(enemy_players, 2)
                local body_x, body_y = renderer.world_to_screen(enemy_hitbox_body_x, enemy_hitbox_body_y, enemy_hitbox_body_z)

                local enemy_hitbox_right_leg_x, enemy_hitbox_right_leg_y, enemy_hitbox_right_leg_z = entity.hitbox_position(enemy_players, 7)
                local leg_r_x, leg_r_y = renderer.world_to_screen(enemy_hitbox_right_leg_x, enemy_hitbox_right_leg_y, enemy_hitbox_right_leg_z)

                local enemy_hitbox_left_leg_x, enemy_hitbox_left_leg_y, enemy_hitbox_left_leg_z = entity.hitbox_position(enemy_players, 8)
                local leg_l_x, leg_l_y = renderer.world_to_screen(enemy_hitbox_left_leg_x, enemy_hitbox_left_leg_y, enemy_hitbox_left_leg_z)

                local enemy_hitbox_right_leg_x1, enemy_hitbox_right_leg_y1, enemy_hitbox_right_leg_z1 = entity.hitbox_position(enemy_players, 9)
                local leg_r_x1, leg_r_y1 = renderer.world_to_screen(enemy_hitbox_right_leg_x1, enemy_hitbox_right_leg_y1, enemy_hitbox_right_leg_z1)

                local enemy_hitbox_left_leg_x1, enemy_hitbox_left_leg_y1, enemy_hitbox_left_leg_z1 = entity.hitbox_position(enemy_players, 10)
                local leg_l_x1, leg_l_y1 = renderer.world_to_screen(enemy_hitbox_left_leg_x1, enemy_hitbox_left_leg_y1, enemy_hitbox_left_leg_z1)

                local enemy_hitbox_left_arm_x, enemy_hitbox_left_arm_y, enemy_hitbox_left_arm_z = entity.hitbox_position(enemy_players, 17)
                local arm_l_x, arm_l_y = renderer.world_to_screen(enemy_hitbox_left_arm_x, enemy_hitbox_left_arm_y, enemy_hitbox_left_arm_z)

                local enemy_hitbox_left_arm_x1, enemy_hitbox_left_arm_y1, enemy_hitbox_left_arm_z1 = entity.hitbox_position(enemy_players, 14)
                local arm_l_x1, arm_l_y1 = renderer.world_to_screen(enemy_hitbox_left_arm_x1, enemy_hitbox_left_arm_y1, enemy_hitbox_left_arm_z1)

                local enemy_hitbox_right_arm_x, enemy_hitbox_right_arm_y, enemy_hitbox_right_arm_z = entity.hitbox_position(enemy_players, 15)
                local arm_r_x, arm_r_y = renderer.world_to_screen(enemy_hitbox_right_arm_x, enemy_hitbox_right_arm_y, enemy_hitbox_right_arm_z)

                local enemy_hitbox_right_arm_x1, enemy_hitbox_right_arm_y1, enemy_hitbox_right_arm_z1 = entity.hitbox_position(enemy_players, 16)
                local arm_r_x1, arm_r_y1 = renderer.world_to_screen(enemy_hitbox_right_arm_x1, enemy_hitbox_right_arm_y1, enemy_hitbox_right_arm_z1)

                renderer.line(head_x, head_y, neck_x, neck_y, r, g, b, a)
                renderer.line(neck_x, neck_y, body_x, body_y, r, g, b, a)
                renderer.line(body_x, body_y, leg_r_x, leg_r_y, r, g, b, a)
                renderer.line(body_x, body_y, leg_l_x, leg_l_y, r, g, b, a)
                renderer.line(neck_x, neck_y, arm_r_x, arm_r_y, r, g, b, a)
                renderer.line(neck_x, neck_y, arm_l_x, arm_l_y, r, g, b, a)
                renderer.line(arm_l_x, arm_l_y, arm_l_x1, arm_l_y1, r, g, b, a)
                renderer.line(arm_r_x, arm_r_y, arm_r_x1, arm_r_y1, r, g, b, a)
                renderer.line(leg_l_x, leg_l_y, leg_l_x1, leg_l_y1, r, g, b, a)
                renderer.line(leg_r_x, leg_r_y, leg_r_x1, leg_r_y1, r, g, b, a)
            end
            
            -- Health
            if ui.get(health) then
                local enemy_health = entity.get_prop(enemy_players, "m_iHealth")
                local height = y2 - y1 + 2
                local y1 = y1 - 1
                local r, g, b, a = ui.get(health_color)

                renderer.rectangle(x1 - 6, y1, 4, y2 - y1, 0, 0, 0, a/2)
                renderer.rectangle(x1 - 5, math.ceil(y2-(height*enemy_health/100))+2, 2, math.floor(height*enemy_health/100) - 2, r, g, b, a)

                if enemy_health < 100 then
                    renderer.text(x1- 5 - 2, y2-(height*enemy_health/100)+2, 255, 255, 255, 255, "-c", 0, enemy_health)
                end
            end

            -- Distance
            if ui.get(distance) then
                local weapon_ent = entity.get_player_weapon(enemy_players)
                if weapon_ent == nil then return end
                local weapon = csgo_weapons(weapon_ent)
                local r, g, b, a = ui.get(distance_color)

                local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
                local ex, ey, ez = entity.get_prop(players[i], "m_vecOrigin")
                local unit_distance = vec2_distance(lx, ly, lz, ex, ey, ez)
                local converted_units = round(units_to_feet(unit_distance))

                renderer.text(x1/2 + x2/2, y2 + 10, r, g, b, a, 'c-', nil, converted_units, 'FT')
            end

            -- Weapon
            if ui.get(weapon) then
                local weapon_ent = entity.get_player_weapon(enemy_players)
                if weapon_ent == nil then return end
                local weapon = csgo_weapons(weapon_ent)
                local r, g, b, a = ui.get(weapon_color)

                if ui.get(distance) then
                    y2 = y2 + 10
                end

                renderer.text(x1/2 + x2/2, y2 + 10, r, g, b, a, 'c-', nil, weapon.name)
            end

        end
    end
end

client.set_event_callback('paint', on_paint)
