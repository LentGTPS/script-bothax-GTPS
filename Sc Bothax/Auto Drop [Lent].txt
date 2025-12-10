local delayDrop = 300 -- jeda antar drop (ms)

function dropItem(id, amount)
    print("[DEBUG] Drop item ID: "..id.." Jumlah: "..amount)
    SendPacket(2, "action|drop\n|itemID|"..id)
    Sleep(100)
    SendPacket(2, "action|dialog_return\ndialog_name|drop_item\nitemID|"..id.."|\ncount|"..amount)
    Sleep(delayDrop)
end

function getItemCount(id)
    local inv = GetInventory()
    for _, item in pairs(inv) do
        if item.id == id then
            return item.amount
        end
    end
    return 0
end

-- CONFIG
local itemID = 2914     -- ganti ke ID item
local chunk = 100      -- jumlah maksimal per drop (beberapa server batasi)
local delayLoop = 500  -- delay sebelum cek inventory lagi (ms)

-- MAIN LOOP
while true do
    local total = getItemCount(itemID)
    if total > 0 then
        local toDrop = math.min(total, chunk)
        dropItem(itemID, toDrop)
        print(">> Drop "..toDrop.." item ID "..itemID..", sisa "..(total-toDrop))
    else
        print(">> Item ID "..itemID.." habis, menunggu...")
    end
    Sleep(delayLoop)
end
