-- Free Script from #@rasyx
local IS_NEW_VERSION_BOTHAX = true
local Range = 12
local Range_Delay = 100

local Break = {2, 14, 16, 190, 728, 1004, 1104, 1102, 3564, 10378}
local Dont = {242, 6, 8, 5638, 6946, 4992}

local RecycleList = {
    [14] = true, [15] = true, [1102] = true, [1103] = true,
    [1104] = true, [1105] = true, [1898] = true, [5028] = true, [5038] = true,
    [15636] = -154, [15637] = -153, [15638] = -156,
    [15639] = -155,
    [15654] = true, [15656] = true, [15658] = true, [16102] = true
}

local breakSet, dontSet = {}, {}
for _, id in ipairs(Break) do breakSet[id] = true end
for _, id in ipairs(Dont) do dontSet[id] = true end

local TakenItemList = {}

local systemNAme = "`c[ `#rasyx - KNOW `c]"

-- safe send variant (menerima baik SendVariantList atau SendVariant)
local function safeSendVariant(data)
    if IS_NEW_VERSION_BOTHAX and type(SendVariantList) == "function" then
        pcall(SendVariantList, data)
    elseif type(SendVariant) == "function" then
        pcall(SendVariant, data)
    else
        -- fallback: nothing
    end
end

function log(txt)
    local data = {
        [0] = "OnConsoleMessage",
        [1] = txt
    }
    safeSendVariant(data)
end

function overlay(txt)
    local data = {
        [0] = "OnTextOverlay",
        [1] = txt
    }
    safeSendVariant(data)
end

function warn(txt)
    local data = {
        [0] = "OnAddNotification",
        [1] = "interface/atomic_button.rttex",
        [2] = systemNAme .. " `9" .. txt,
        [3] = "audio/hub_open.wav"
    }
    safeSendVariant(data)
end

function sleepRandom(min, max)
    Sleep(math.random(min, max))
end

if type(ChangeValue) == "function" then
    pcall(ChangeValue, "[C] Modfly", true)
end

function place(id,x,y)
    local pkt = {}
    pkt.type = 3
    pkt.value = id
    pkt.px = math.floor(GetLocal().pos.x / 32 + x)
    pkt.py = math.floor(GetLocal().pos.y / 32 + y)
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y
    pcall(SendPacketRaw, false, pkt)
end

function p(x, y)
    local pkt = {
        type = 3,
        value = 18,
        px = x,
        py = y,
        x = GetLocal().pos.x,
        y = GetLocal().pos.y
    }
    pcall(SendPacketRaw, false, pkt)
end

function FP(x, y)
    local px = math.floor(GetLocal().pos.x / 32)
    local py = math.floor(GetLocal().pos.y / 32)
    while math.abs(y - py) > 6 do
        py = py + (y - py > 0 and 6 or -6)
        FindPath(px, py)
        Sleep(80)
    end
    while math.abs(x - px) > 6 do
        px = px + (x - px > 0 and 6 or -6)
        FindPath(px, py)
        Sleep(80)
    end
    Sleep(50)
    FindPath(x, y)
end

function FPC(x, y)
    local px = math.floor(GetLocal().pos.x / 32)
    local py = math.floor(GetLocal().pos.y / 32)
    while math.abs(y - py) > 6 do
        py = py + (y - py > 0 and 6 or -6)
        FindPath(px, py)
        Sleep(10)
    end
    while math.abs(x - px) > 6 do
        px = px + (x - px > 0 and 6 or -6)
        FindPath(px, py)
        Sleep(10)
    end
    Sleep(30)
    FindPath(x, y)
end

function TakeItem(obj)
    if obj and obj.oid and obj.pos then
        local pkt = {
            type = 11,
            value = obj.oid,
            x = obj.pos.x,
            y = obj.pos.y
        }
        pcall(SendPacketRaw, false, pkt)
    end
end

function shouldBreak(id)
    return id and id ~= 0 and breakSet[id] and not dontSet[id]
end

function getItemAmount(id)
    local inventory = GetInventory() or {}
    for _, item in pairs(inventory) do
        if item.id == id then
            return item.amount or 0
        end
    end
    return 0
end

function TrashItem(id, count)
    sleepRandom(100, 150)
    local trashID = RecycleList[id] == true and id or RecycleList[id]
    if not trashID then return end
    SendPacket(2, "action|trash\n|itemID|"..id)
    log("`9Recycled: `bID `5" .. tostring(id) .. " `9- `^x" .. tostring(count))
end

function InventoryTrash()
    for id, _ in pairs(RecycleList) do
        local amt = getItemAmount(id)
        while amt >= 50 do
            TrashItem(id, 50)
            sleepRandom(150, 250)
            amt = getItemAmount(id)
        end
    end
end

function TakeDroppedTrash()
    local player = GetLocal()
    if not player then return end

    while true do
        local foundItem = false
        local closestObj = nil
        local closestDist = math.huge

        player = GetLocal()
        if not player then break end

        local px = math.floor(player.pos.x / 32)
        local py = math.floor(player.pos.y / 32)

        for _, obj in pairs(GetObjectList() or {}) do
            if obj.pos and obj.id then
                local ox = math.floor(obj.pos.x / 32)
                local oy = math.floor(obj.pos.y / 32)
                if RecycleList[obj.id] then
                    local dist = math.abs(ox - px) + math.abs(oy - py)
                    if dist < closestDist then
                        closestDist = dist
                        closestObj = obj
                        foundItem = true
                    end
                end
            end
        end

        if not foundItem or not closestObj then
            break
        end

        local tx = math.floor(closestObj.pos.x / 32)
        local ty = math.floor(closestObj.pos.y / 32)
        FPC(tx, ty)
        Sleep(30)

        px = tx
        py = ty
        for _, obj in pairs(GetObjectList() or {}) do
            if obj.pos and obj.id and RecycleList[obj.id] and math.abs(math.floor(obj.pos.x/32) - px) <= 1 and math.abs(math.floor(obj.pos.y/32) - py) <= 1 then
                TakeItem(obj)
                TakenItemList[obj.id] = (TakenItemList[obj.id] or 0) + (obj.amount or 1)
                Sleep(40)
            end
        end

        InventoryTrash()
        Sleep(100)
    end
end

function Clear_World()
    local world = GetWorld()
    if not world then return end

    for x = 0, 192 do
        InventoryTrash()
        for y = 0, 198 do
            local tile = GetTile(x, y)
            if tile then
                local fg, bg = tile.fg, tile.bg
                if not dontSet[fg] and not dontSet[bg] then
                    if shouldBreak(fg) or shouldBreak(bg) then
                        FP(x, y - 1)
                        Sleep(10)

                        local tries = 0
                        while tries < 15 do
                            local current = GetTile(x, y)
                            if current and current.fg == 0 and current.bg == 0 then
                                break
                            end
                            p(x, y)
                            Sleep(30)
                            tries = tries + 1
                        end
                    end
                end
            end
        end
    end
end

function Clear_Water()
    local w = GetWorld()
    if not w then return false end
    local missed = {}
    local hasWater = false

    for x = 192, 0, -1 do
        for y = 199, 0, -1 do
            local t = GetTile(x, y)
            if t and t.flags and t.flags.water then
                hasWater = true
                FP(x, y)
                Sleep(10)
                if GetTile(x, y).flags and GetTile(x, y).flags.water then
                    place(822, 0, 0)
                    Sleep(10)
                    if GetTile(x, y).flags and GetTile(x, y).flags.water then
                        table.insert(missed, {x = x, y = y})
                    end
                end
            end
        end
    end

    for _, pos in ipairs(missed) do
        if GetTile(pos.x, pos.y).flags and GetTile(pos.x, pos.y).flags.water then
            FP(pos.x, pos.y)
            Sleep(10)
            place(822, 0, 0)
            Sleep(10)
        end
    end

    return hasWater
end

-- wait world & local
local waitCount = 0
while not GetLocal() or not GetWorld() do
    waitCount = waitCount + 1
    if waitCount % 10 == 0 then
        log("Waiting for world/local to load...")
    end
    Sleep(200)
end

-- main execution wrapped pcall for safety
local ok, err = pcall(function()
    warn("Made By `#@rasyx")
    Sleep(3500)

    overlay("`9Clear Island `8Started")
    Clear_World()
    overlay("`9Clear Island `2Finished")

    Sleep(1500)

    overlay("`9Collecting Drops `8Started")
    TakeDroppedTrash()
    overlay("`9Collecting Drops `2Finished")

    Sleep(1500)

    overlay("`9Clearing Water `8Started")
    Clear_Water()
    overlay("`9Clearing Water `2Finished")
end)

if not ok then
    log("Script error: " .. tostring(err))
    warn("Script menemukan error, cek console.")
end
