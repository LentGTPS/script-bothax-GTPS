ID = 10536  -- SWW
Delay = 200

trashList = {5404, 5422, 5424, 5474, 5426, 7398, 7406, 7414, 9194, 10404, 10538, 11454, 11480}  -- Misalnya, ID-item yang akan dibuang

function kupon()
    pkt = {}
    pkt.type = 3
    pkt.value = ID
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y
    pkt.px = GetLocal().pos.x // 32
    pkt.py = GetLocal().pos.y // 32
    SendPacketRaw(false, pkt)
    Sleep(Delay)
end

function trash(itemID, count)
    SendPacket(2, "action|dialog_return\ndialog_name|trash_item\nitemID|".. itemID .."|\ncount|".. count .."\n")
end

function autoTrash()
    for _, trashID in ipairs(trashList) do
        local count = GetItemCount(trashID)
        if count > 190 then
            trash(trashID, count)
            Sleep(Delay)
        end
    end
end

while true do
kupon()
Sleep(Delay)
autoTrash()
end
