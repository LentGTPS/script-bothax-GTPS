-- [[ AUTO BUY & DROP FARMABLE PACK ]]
-- Buat Bothax PC - Grow A Village
-- Pastikan API "packet", "inventory", "console", dan "sleep" aktif

local packName = "city_pack" -- Nama Farmable Pack di shop
local dropIDs = {994, 986, 992, 990, 996, 998, 1006, 988, 1002, 1004} -- Item ID hasil pack
local delayBuy = 200 -- jeda beli (ms)
local delayTrash = 100-- jeda drop per item (ms)

function dropItem(id, amount)
    print("[DEBUG] Drop item ID: "..id.." Jumlah: "..amount)
    SendPacket(2, "action|trash\n|itemID|"..id)
    Sleep(100)
    SendPacket(2, "action|dialog_return\ndialog_name|trash_item\nitemID|"..id.."|\ncount|"..amount)
    Sleep(delayTrash)
end

while true do
    print("[DEBUG] Membeli Atm Pack...")
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
