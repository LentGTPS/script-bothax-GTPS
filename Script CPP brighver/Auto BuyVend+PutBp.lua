count = 200
itemID = 2914
price = -1

x = GetLocal ().pos.x//32
y = GetLocal ().pos.y//32

function vend()
SendPacket(2,"action|dialog_return\ndialog_name|vending\ntilex|"..x.."|\ntiley|"..y.."|\nverify|1|\nbuycount|"..count.."|\nexpectprice|"..price.."|\nexpectitem|"..itemID.."|\n")
end

function bp()
SendPacket(2,"action|dialog_return\ndialog_name|backpack_menu\nitemid|"..itemID.."")
end

while true do
vend()
Sleep(200)
bp()
Sleep(200)
end