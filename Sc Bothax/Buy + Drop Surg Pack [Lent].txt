local packName = "surg" -- Nama Farmable Pack di shop
local dropIDs = {1258, 1260, 1262, 1264, 1266, 1268, 1270, 4308, 4310, 4312, 4314, 4316, 4318, 4296, 8500} -- Item ID hasil pack
local delayBuy = 200 -- jeda beli (ms)
local delayDrop = 100 -- jeda drop per item (ms)

function dropItem(id, amount)
    SendPacket(2, "action|drop\n|itemID|"..id)
    Sleep(100)
    SendPacket(2, "action|dialog_return\ndialog_name|drop_item\nitemID|"..id.."|\ncount|"..amount)
    Sleep(delayDrop)
end

while true do
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
