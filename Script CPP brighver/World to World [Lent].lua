local Delay_Enter = 2500
local Delay_Exit = 2500
local IDs = 185 -- ID item yang mau diambil & di-drop
local Drop_Amount = 200 -- Jumlah item yang di-drop
------------------------------------------------------
local World_Take = "LENT"
local dropt_coord = {13, 113} -- Koordinat magplant
------------------------------------------------------
local World_Drop = "LENTSSS"
local drop_coord = {79, 24} -- Koordinat drop item
------------------------------------------------------

local function dropTake(x, y)
    FindPath(x, y)
    Sleep(300)
end

local function dropItem(x, y, id, amount)
    FindPath(x, y)
    Sleep(300)
    SendPacket(2, "action|drop\n|itemID|"..id)
    Sleep(100)
end

while true do
    SendPacket(3, "action|quit_to_exit")
    Sleep(Delay_Exit)
    SendPacket(3, "action|join_request\nname|"..World_Take.."\ninvitedWorld|0")
    Sleep(Delay_Enter)
    dropTake(dropt_coord[1], dropt_coord[2])
    Sleep(200)
    SendPacket(3, "action|quit_to_exit")
    Sleep(Delay_Exit)
    SendPacket(3, "action|join_request\nname|"..World_Drop.."\ninvitedWorld|0")
    Sleep(Delay_Enter)
    dropItem(drop_coord[1], drop_coord[2], IDs, Drop_Amount)
    Sleep(200)
end