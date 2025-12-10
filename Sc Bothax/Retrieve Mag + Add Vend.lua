MAGx, MAGy = 13, 53
VENDx, VENDy = 1, 52
count = 200

function mag()
    SendPacket(2, "action|dialog_return\ndialog_name|itemremovedfromsucker\ntilex|".. MAGx .."|\ntiley|".. MAGy .."|\nitemtoremove|"..count.."\n")
end

function vend()
    SendPacket(2, "action|dialog_return\ndialog_name|vending\ntilex|".. VENDx .."|\ntiley|".. VENDy .."|\nbuttonClicked|addstocks\n\nsetprice|0\nchk_peritem|1\nchk_perlock|0\n")
end

while true do
mag()
Sleep(200)
vend()
Sleep(200)
end