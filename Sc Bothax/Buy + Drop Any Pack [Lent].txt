-- [[ AUTO BUY & DROP Any Pack ]]

local packName = "door_pack" -- Nama Farmable Pack di shop
local dropIDs = {3838, 340, 4584, 3004, 5666} -- Item ID hasil pack
local delayBuy = 200 -- jeda beli (ms)
local delayDrop = 300 -- jeda drop per item (ms)

function dropItem(id, amount)
    print("[DEBUG] Drop item ID: "..id.." Jumlah: "..amount)
    SendPacket(2, "action|drop\n|itemID|"..id)
    Sleep(100)
    SendPacket(2, "action|dialog_return\ndialog_name|drop_item\nitemID|"..id.."|\ncount|"..amount)
    Sleep(delayDrop)
end

while true do
    print("[DEBUG] Membeli Farmable Pack...")
    SendPacket(2, "action|buy\nitem|"..packName)
    Sleep(delayBuy)

    for _, itm in pairs(GetInventory()) do
        for _, id in ipairs(dropIDs) do
            if itm.id == id and itm.amount > 0 then
                dropItem(id, itm.amount)
            end
        end
    end
end
