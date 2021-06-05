--[[
    HP Based Freestanding
    - This allows you to disable freestanding if your health is below the number on the slider.
    - I created this before my conditions lua so that is why it is a thread.
]]

local tab, container = 'AA', 'Anti-aimbot angles'

local hpbase_button = ui.new_checkbox(tab, container, 'HP Based Freestanding')
local hpbase_slider = ui.new_slider(tab, container, 'Disabler HP', 1, 100, 1, true, 'hp')

local freestanding = ui.reference(tab, container, 'Freestanding')

client.set_event_callback('paint_ui', function()
    local local_hp = entity.get_prop(entity.get_local_player(), 'm_iHealth')

    if ui.get(hpbase_button) then
        ui.set(freestanding, 'Default')

        if ui.get(hpbase_slider) > local_hp then
            ui.set(freestanding, '-')
        end
    end
end)
