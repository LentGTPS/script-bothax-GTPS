ID = 0000 -- ID 
Delay = 180


function kupon()
   pkt = {}
       pkt.type = 3
       pkt.value = ID
       pkt.x = GetLocal().pos.x
       pkt.y = GetLocal().pos.y
       pkt.px = GetLocal().pos.x//32
       pkt.py = GetLocal().pos.y//32
       SendPacketRaw(false , pkt)
   Sleep(Delay)
end

while true do
kupon()
end