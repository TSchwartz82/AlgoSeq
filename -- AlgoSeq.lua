-- AlgoSeq
-- Generative Algorithmic 
--      Sequencer


--E1 bpm
--E2 mode select
--E3 algorithm select
--K2
--K3



engine.name="PolyPerc"

music = require 'musicutil'

beatclock = require 'beatclock'

note = 40

steps = {}

position = 0

range = 30

number = 1

transpose = 0

mode = #music.SCALES

scale = music.generate_scale_of_length(60,music.SCALES[mode].name,32)

clk = beatclock.new()
clk_midi = midi.connect()
clk_midi.event = clk.process_midi

algo = {}

step1 = {}

step2 = {2,2,2,2,2}

step3 = {4,1,0}

STEPS = 32

function rand() note = math.random(90) + range / 12 end

act = rand

function init()
  
  for i=1,32 do
    
    table.insert(steps,math.random(8))
    
  end
  
  clk.on_step = count
  clk.on_select_internal = function() clk:start() end
  clk.on_select_external = function() print("external") end
  clk:add_clock_params()

  params:add_separator()

  clk:start()
  

end

function count()
  
  position = (position % STEPS) + 1
  
  engine.hz(midi_to_hz(scale[steps[position]] + transpose))

  randomize_steps()

end

function key(n,z)
  
  if n==2 and z==1 then 
    
    clk:start()
    
    elseif n==3 and z==1 then
      
      clk:stop()

    end
    
end

function enc(n,d)
  
  if n==1 then 
    
    params:delta("bpm",d)
    
    elseif n==2 then
      
      mode = util.clamp(mode + d, 1, #music.SCALES)

      scale = music.generate_scale_of_length(60,music.SCALES[mode].name,16)

      elseif n==3 then
        
        number = math.min(3,(math.max(number + d,1)))

    end
    
  redraw()
  
end

function redraw()
  screen.clear()
  screen.level(15)
  screen.move(5,20)
  screen.text("bpm: "..params:get("bpm"))
  screen.move(5,35)
  screen.text(music.SCALES[mode].name)
  screen.move(5,50)
  screen.text("Algorithm: ")
  screen.text(number)
  screen.update()
end

function midi_to_hz(note)
  
  return (440/32)*(2^((note-9)/12))
  
end

function randomize_steps()
  
  for i=1,8 do
    
    algo[i] = math.randomseed(8,24)
    
  end

end

m = midi.connect()
m.event = function(data)
  local d = midi.to_msg(data)
  if d.type == "note_on" then
    transpose = d.note - 60
  end
end

-- function crow()

--   end


-- scaleNotes = {  
--   {0,2,4,5,7,9,11,12,14,16,17,19,21,23,24,26,28,29,31,33,35,36,38,40,41,43,45,47,48},
--   {0,2,3,5,7,8,10,12,14,15,17,19,20,22,24,26,27,29,31,32,34,36,38,39,41,43,44,46,48},
--   {0,2,3,5,7,9,10,12,14,15,17,19,21,22,24,26,27,29,31,33,34,36,38,39,41,43,45,46,48},
--   {0,1,3,5,7,8,10,12,13,15,17,19,20,22,24,25,27,29,31,32,34,36,37,39,41,43,44,46,48},
--   {0,2,4,6,7,9,11,12,14,16,18,19,21,23,24,26,28,30,31,33,35,36,38,40,42,43,45,47,48},
--   {0,2,4,5,7,9,10,12,14,16,17,19,21,22,24,26,28,29,31,33,34,36,38,40,41,43,45,46,48},
--   {0,3,5,7,10,12,15,17,19,22,24,27,29,31,34,36,39,41,43,46,48,51,53,55,58,60,63,65,67},
--   {0,2,4,7,9,12,14,16,19,21,24,26,28,31,33,36,38,40,43,45,48,50,52,55,57,60,62,64,67}
-- }


-- scaleNames = {
--   "ionian",
--   "aeolian",
--   "dorian",
--   "phrygian",
--   "lydian",
--   "mixolydian",
--   "major_pent",
--   "minor_pent"
-- }