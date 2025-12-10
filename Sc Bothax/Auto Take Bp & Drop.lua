count = 200
slot = 0
itemID = 7346

function takeBP()
    SendPacket(2, "action|dialog_return\ndialog_name|backpack_menu\nbuttonClicked|"..slot.."")
end

function drop()
    SendPacket(2, "action|dialog_return\ndialog_name|drop_item\nitemID|"..itemID.."|\ncount|"..count.."\n")
end

while true do
takeBP()
Sleep(200)
drop()
Sleep(3600)
end