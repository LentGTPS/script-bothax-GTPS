local kode = "53785"        -- kode telephone
local delayPerStep = 500    -- jeda antar step (ms)
local delayLoop = 600000    -- 5 menit (ms)

function sendDialog(dialog_name, buttonClicked)
    SendPacket(2, "action|dialog_return\n" ..
        "dialog_name|".. dialog_name .."\n" ..
        "buttonClicked|".. buttonClicked)
end

function convertDLtoBGL()
    while true do
        -- STEP 1: Masukkan kode ke telephone + dial
        sendDialog("3898", kode)
        Sleep(delayPerStep)

        -- STEP 2: Klik Blue Gem Lock di Sales-Man
        sendDialog("3898", "chc2_1")
        Sleep(delayPerStep)

        -- STEP 3: Klik Thank You! untuk beli BGL
        sendDialog("3898", "chc2_2_1")
        Sleep(delayPerStep)

        -- STEP 4: ESC / Hang Up
        sendDialog("3898", "cancel")
        Sleep(delayPerStep)

        -- Debug info
        LogToConsole("✅ Convert DL -> BGL selesai, tunggu 5 menit...\n")

        -- Tunggu 5 menit sebelum ulang lagi
        Sleep(delayLoop)
    end
end

-- Jalankan
convertDLtoBGL()
