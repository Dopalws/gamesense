local csgo_weapons = require('gamesense/csgo_weapons')

local tab, container = 'LUA', 'A'
local label = ui.new_label(tab, container, 'Custom ESP in lua')
local name = ui.new_checkbox(tab, container, 'Name')
local name_color = ui.new_color_picker(tab, container, 'Name color', 255, 255, 255, 255)
local box = ui.new_checkbox(tab, container, 'Bounding box')
local box_color = ui.new_color_picker(tab, container, 'Box color', 255, 255, 255, 255)
local health = ui.new_checkbox(tab, container, 'Health')
local health_color = ui.new_color_picker(tab, container, 'Health color', 255, 255, 255, 255)
local weapon = ui.new_checkbox(tab, container, 'Weapon text')
local weapon_color = ui.new_color_picker(tab, container, 'Weapon color', 255, 255, 255, 255)

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
                renderer.text(x1/2 + x2/2, y1 - 8, r, g, b, a, 'c', nil, enemy_name)
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

            -- Weapon
            if ui.get(weapon) then
                local weapon_ent = entity.get_player_weapon(enemy_players)
                if weapon_ent == nil then return end
                local weapon = csgo_weapons(weapon_ent)
                local r, g, b, a = ui.get(weapon_color)

                renderer.text(x1/2 + x2/2, y2 + 8, r, g, b, a, 'c-', nil, weapon.name)
            end
        end
    end
end

client.set_event_callback('paint', on_paint)
