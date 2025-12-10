platID = 5640
delay = 80
worldType = "island"
mray = false

if string.lower(worldType) == "normal" then
	sizeX, sizeY = 100, 60
elseif string.lower(worldType) == "nether" then
	sizeX, sizeY = 150, 150
elseif string.lower(worldType) == "island" then
	sizeX, sizeY = 200, 200
else
	sizeX, sizeY = 100, 60
end

if mray then put = 10 else put = 1 end

function inv(id)
	for _, item in pairs(GetInventory()) do
		if item.id == id then
			return item.amount
		end
	end
	return 0
end

for y = sizeY - 2, 0, -1 do
	for x1 = 0, put - 1 do
		for x2 = 0, sizeX / put - 1 do
			local x = x2 * put + x1
			local tile = GetTile(x, y)

			-- Skip kalau tile kosong / world belum siap
			if tile and tile.fg == 0 and y % 2 == 1 then
				-- Cek apakah masih punya block
				if inv(platID) == 0 then
					LogToConsole("Mencari platID lagi...")
					SendPacket(2, "action|dialog_return\ndialog_name|item_search\n" .. platID .. "|1")
					Sleep(1000)
				end

				-- Aksi klik dan pasang block
				SendPacketRaw(false, {type = 3, value = platID, x = x * 32, y = y * 32, px = x, py = y})
				LogToConsole("Pasang plat di x=" .. x .. " y=" .. y)
				Sleep(delay)
			end
		end
	end
end

LogToConsole("✅ Selesai! Semua plat dipasang.")
