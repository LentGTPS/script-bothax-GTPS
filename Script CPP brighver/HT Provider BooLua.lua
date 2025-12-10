--[Harvest provider]
--[Turn on /ghost]
providerID = 1008
delayHarvest = 300
worldType = "island" --[normal/nether/island]

--[Main Script]
SendVariantList({[0] = "OnDialogRequest", [1] = [[
set_default_color|`w
add_label_with_icon|small|`8BooLua Community|left|2918|
add_spacer|small|
add_label_with_icon|small|`5VIP `b- `5Free Scripts CPS|left|1368|
add_label_with_icon|small|`eGL `b- `2BotHax `b- `8GPai|left|1368|
add_label_with_icon|small|`6Report Bug Script|left|1368|
add_label_with_icon|small|`3Request Script|left|1368|
add_label_with_icon|small|`8Learn Script|left|1368|
add_spacer|small|
add_url_button||`qDiscord``|NOFLAGS|https://discord.gg/Any9dcWNwE|`$BooLua Community.|0|0|
add_smalltext|`9Need more scripts?!Join now!|
add_quick_exit|]]})

-- Tentukan ukuran world
if string.lower(worldType) == "normal" then
    sizeX, sizeY = 100, 60
elseif string.lower(worldType) == "nether" then
    sizeX, sizeY = 150, 150
elseif string.lower(worldType) == "island" then
    sizeX, sizeY = 200, 200
else
    sizeX, sizeY = 100, 60
end

-- Cari tile provider
harvestTiles = {}
for x = 0, sizeX - 1 do
    for y = sizeY - 2, 0, -1 do
        local tileData = GetTile(x, y)
        if tileData and tileData.fg == providerID then
            table.insert(harvestTiles, {x = x, y = y})
        end
    end
end

-- Mulai panen
for i = 1, 3 do
    for _, tile in pairs(harvestTiles) do
        local tileData = GetTile(tile.x, tile.y)
        if tileData and tileData.fg == providerID and tileData.extra and tileData.extra.progress == 1 then
            SendPacketRaw(false, {state = 32, x = tile.x * 32, y = tile.y * 32})
            SendPacketRaw(false, {type = 3, value = 18, px = tile.x, py = tile.y, x = tile.x * 32, y = tile.y * 32})
            SendPacketRaw(false, {state = 4196896, px = tile.x, py = tile.y, x = tile.x * 32, y = tile.y * 32})
            SendPacketRaw(false, {state = 16779296, px = tile.x, py = tile.y, x = tile.x * 32, y = tile.y * 32})
            Sleep(delayHarvest)
        end
    end
end

LogToConsole("DONE")
