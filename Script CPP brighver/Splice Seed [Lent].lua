-- [SETTINGS]
delaypt   = 10      -- delay plant (ms)
delayht   = 150     -- delay harvest (ms)
yTop      = 0       -- lantai paling atas
yBottom   = 113     -- lantai paling bawah
seedID    = 1778    -- ID seed yang ditanam

----------------------------------------------------------
-- CEK TILE READY UNTUK DIHARVEST
----------------------------------------------------------
function IsReady(tile)
    return tile and tile.extra and tile.extra.progress == 1.0
end

----------------------------------------------------------
-- PUNCH TILE
----------------------------------------------------------
function punch(x, y)
    local pkt = {type = 3, value = 18}
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y 
    pkt.px = math.floor(GetLocal().pos.x / 32 + x)
    pkt.py = math.floor(GetLocal().pos.y / 32 + y)
    SendPacketRaw(false, pkt)
end

----------------------------------------------------------
-- TANAM SEED
----------------------------------------------------------
function place(id, x, y)
    local pkt = {type = 3, value = id}
    pkt.px = math.floor(GetLocal().pos.x / 32 + x)
    pkt.py = math.floor(GetLocal().pos.y / 32 + y)
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y
    SendPacketRaw(false, pkt)
end

----------------------------------------------------------
-- HARVEST TANAMAN (ATAS → BAWAH)
----------------------------------------------------------
function harvest()
    for y = yTop, yBottom do   -- dari ATAS ke BAWAH
        for x = 0, 199 do
            local t = GetTile(x, y)
            if IsReady(t) then
                FindPath(x, y, 50)
                Sleep(delayht)
                punch(0, 0)
                Sleep(delayht)
            end
        end
    end
end

----------------------------------------------------------
-- TANAM 3 BLOK SEKALIGUS (ZIGZAG ATAS → BAWAH)
----------------------------------------------------------
function plant()
    for y = yTop, yBottom do
        if y % 2 == 0 then
            -- GENAP: tanam dari kiri ke kanan
            for x = 0, 199 do
                local tile = GetTile(x, y)
                if tile then
                    FindPath(x, y, 50)
                    Sleep(delaypt)
                    place(seedID, 0, 0) -- paksa tanam (walau sudah ada seed/plant)
                    Sleep(delaypt)
                end
            end
        else
            -- GANJIL: tanam dari kanan ke kiri
            for x = 199, 0, -1 do
                local tile = GetTile(x, y)
                if tile then
                    FindPath(x, y, 50)
                    Sleep(delaypt)
                    place(seedID, 0, 0)
                    Sleep(delaypt)
                end
            end
        end
    end
end

----------------------------------------------------------
-- LOOP UTAMA
----------------------------------------------------------
while true do
    harvest()
    Sleep(1000)
    plant()
    Sleep(2000)
end
