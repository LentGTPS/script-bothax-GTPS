itemID = 10536
slot = 0

function bp()
    SendPacket(2, "action|dialog_return\ndialog_name|backpack_menu\nbuttonClicked|".. slot .."\n")
end

function drop()
    SendPacket(2, "action|drop\n|itemID|".. itemID .."\n")
end

while true do
bp()
Sleep(200)
drop()
Sleep(3600)
end