function place(id,x,y)
    pkt = {}
    pkt.type = 3
    pkt.value = id
    pkt.px = math.floor(GetLocal().pos.x / 32 +x)
    pkt.py = math.floor(GetLocal().pos.y / 32 +y)
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y
    SendPacketRaw(false, pkt)
end

function ClearWater()
    for x = 0, 199 do
        for y = 193, 0, -1 do
            local t = GetTile(x, y)
            if t and t.flags and t.flags.water then
                FindPath(x, y, 100)
                Sleep(10)
                -- cek ulang
                local t2 = GetTile(x, y)
                if t2 and t2.flags and t2.flags.water then
                    place(822, 0, 0)
                    Sleep(100)
                end
            end
        end
    end
end

while true do
    ClearWater()
end