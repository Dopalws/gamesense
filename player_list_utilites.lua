--[[
    Player list utilites
    - Steal players name
    - Steal players name and use it as a clan tag
]]

local gs_steal_name = ui.reference("MISC", 'Miscellaneous', 'Steal player name')
local player_select = ui.reference("PLAYERS", "Players", "Player list")

local steal_name_button = ui.new_button("PLAYERS", "Adjustments", "Steal name", function()
    local selected_name = entity.get_player_name(ui.get(player_select))

    ui.set(gs_steal_name, true)
    client.set_cvar("name", selected_name.." ");
end)

local steal_name_clan_tag_button = ui.new_button("PLAYERS", "Adjustments", "Steal name clan tag", function()
    local selected_name = entity.get_player_name(ui.get(player_select))

    client.set_clan_tag(selected_name)
end)
