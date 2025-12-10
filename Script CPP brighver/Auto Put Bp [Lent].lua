itemID = 3726

function bp()
SendPacket(2,"action|dialog_return\ndialog_name|backpack_menu\nitemid|"..itemID.."")
end

AddHook("OnVariant", "block", function(var)
if var[0]:find("OnDialogRequest") then
return true
end
return false
end)

while true do
bp()
Sleep(1000)
end