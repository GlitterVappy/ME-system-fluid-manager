local c = require("component")
local fs = require("filesystem")
local tabl = require("table")
local term = require("term")
local math = require("math")
local ser = require("serialization")
local mecon = c.proxy(c.me_controller.address)
local event = require("event")
local colors = require("colors")
local pyro = "Blazing Pyrotheum"
local data = {}
local mainTable = {}
local fluidlist = {}
local gpu = c.gpu
local sw,sh = gpu.getResolution() -- 160x50
local TIMERID = 0
local FORECOLOR = 0xFFFFFF
-------

local function FUNCTIONS(name)
    --code for when a fluid is too low. example provided for retaw, because i dont think any fluids are named that

    -- name should be the "exe" value of the fluid, found in fluids.cfg or though the edit command in the program.

  if name == "retaw" then
    print("what?")
  elseif name == "example" then
    -- do something.
  




else
    print("error. make sure that you have edited fluids.lua to contain the function you need to run.")  --error.
end
 
end

-------
-- colors, if you want.
colr = {}
colr["header"] = 0xFF0000
colr["inputcolor"] = 0x8e9eef
colr["tcolor1"] = 0xBAF3AA
colr["tcolor2"] = 0xfb4ad4
colr["tcolor3"] = 0x82e5e9
colr["white"] = 0xFFFFFF


------

local function checkdata(index,check)
  local bool = false
  for value,nothing in pairs(mainTable[index]) do
        if value == check then
      bool = true
    end
  end
  if bool == false then print("data error") end
  return bool
end

local function checkfluid(check)
  local bool = false
  for against,nothing in pairs(mainTable) do
    if check == against then
      bool = true   
   end
  end
  if bool == false then print("data error") end
  return bool
end

local function fluidAdd(name, instock, tostock,exe)
  mainTable[name] = {}
  mainTable[name]["instock"] = instock
  mainTable[name]["tostock"] = tostock
  mainTable[name]["exe"] = exe
end

local function LoadFluids()
  local file,err = io.open("fluids.cfg", "r")
  local var = ""  
  
  local var = file:read()
  mainTable = ser.unserialize(var)

  file:close()
  if err then
    print("try rerunning and using initialize ")
  end
end

local function SaveFluids()
  local file,err = io.open("fluids.cfg", "w")
  local itemToSave = ""
  itemToSave = ser.serialize(mainTable)
  file:write(itemToSave)
  file:close()
end


local function editFluids()
  local indent = false

  print("what fluid do you want to edit? available tables: ")
  for fluid,_ in pairs(mainTable) do
    term.write(fluid .. "\n\n")
  end 
  local fluidname = io.read()
  
  if checkfluid(fluidname) == true then
    print("\n data of " .. fluidname .. ": \n")
  
    for label, value in pairs(mainTable[fluidname]) do
      if indent == true then
        print("\n")
      end
      print(label, value)
      indent = true
    end
  
    print("\nwhat would you like to edit? ")
    
    local input = io.read()
      if checkdata(fluidname,input) == true then
        print("old value: " .. mainTable[fluidname][input] .. "\n")
        print("new value: ")
        local newvalue = io.read()
        mainTable[fluidname][input] = newvalue
        print("\nvalue" .. input .. " changed to " .. newvalue .. ". Moving to main menu.")   
    end
  
  else 
  print("invalid input. make sure your input is exact.")
  end
end


local function InitFluidsFromNetwork()
  local tabl = mecon.getFluidsInNetwork()
  for index,table in pairs(tabl) do
    if type(index) == "number" then
    for type,data in pairs(table) do
    if type == "label" then
      labelf = tostring(data)
    elseif type == "name" then
      namef = data
    elseif type == "amount" then
      amountf = data
    end
    end
  end

    fluidAdd(labelf,amountf,0,namef)
    print("completed!" .. labelf)
  end
end

local function printTable()
  for name,data in pairs(mainTable) do
    print("\n" .. name)
    print(tostring(data["tostock"]))
  end
end

local function guiInit()
  -- screen is 160x50
  local x,y = 1,0
  term.clear()
end

local function init() -- clear screen, load values. next step: output informion, and setup adding, removing, and finding a fluid recipe.
  term.clear()
  local increment = 1
  local check = pcall(LoadFluids)
  for fluid,none in pairs(mainTable) do
    fluidlist[increment] = tostring(fluid)
    increment= increment+1
  end
  if check == "false" then print("Config file created") end
    print("fluids loaded from fluids.cfg")

  guiInit()
  
end

local function checkFluidLevels()
  local name = ""
  local amount = 0
  local table = mecon.getFluidsInNetwork()
  --init variables and assign table to the network's

  for k,v in pairs(table) do
    if type(v) == "table" then
  -- open up the table and check if v is a table (because the last is a number). discard index.

    for type,value in pairs(table[k]) do
      if type == "label" then
        name = tostring(value)
      elseif type == "amount" then
        amount = value
  --open up each table and assign "label" to name and assign amount.

    for fluidname,tablf in pairs(mainTable) do -- i love checking everything because nil index!!!
      if name == fluidname then
        local tostock = tonumber(tablf["tostock"])
              if (tonumber(amount) <= tonumber(tostock)) then
          FUNCTIONS(tablf["exe"]) -- run functions with the name. i cant serialize functions (without load() fuckery) so im just going to do this.
         end
      end
      end
    end      
    end
    end
  end
end

local function checkMain()
  --checkFluidLevels()
  TIMERID = event.timer(3,checkFluidLevels,math.huge)  
end
local function infoMain() --nothing
  for ind in 1 do
    print("m")
  end
end

local function close(ask)
  term.clear()
  print("closing...")
  if ask == "y" then
  if TIMERID ~= 0 then
    event.cancel(TIMERID)
  end
  end
  SaveFluids()
  os.sleep(0.2)
  os.exit()
  
end

local function HEADER(text,color)
  gpu.setForeground(color)
  gpu.set(sw/2, 1,text)
end

local function ADDHISTORY(text)
  gpu.set(sw-sw/6,sh-sh/6,text)
end

local track = 0

local function INPUT(color)
  color = color or FORECOLOR
  gpu.setForeground(color)
  local input = io.read()
  gpu.setForeground(FORECOLOR)
  return input
end

local function PRINT(text,color)
  color = color or colr["tcolor1"]
  gpu.setForeground(color)
  print(text)
  gpu.setForeground(FORECOLOR)
end

local function mainMenu() 
  HEADER("Main Menu",colr["header"])
  PRINT("input your command! ",colr[terminalcolor1])
  local input = INPUT(colr["inputcolor"])
  input = input:lower()
  track = track+1
  ADDHISTORY(input)

--idk how to make this work. resets screen basically. but it doesnt.
  if track == 5 then
    os.sleep(0.5)
    term.clear()
  end
-----------

    local options = "available commands: exit, hi, initialize, edit, start, help, "

    options = options .. "print table"-- with new args, edit this



--main menu options.
  if input == "exit" then
    local inp = "y"
    term.clear()
    if TIMERID ~= 0 then
      PRINT("close daemon? Y/n (if you dont close it, it wont stop running!)",0xFF0000)
      inp = INPUT(0xFFFFFF) --white
    end
    
    inp = inp:lower()
    close(inp)
  elseif input == "help" then
    print(options)
  elseif input == "hi" then
    print("hello!")
  elseif input == "print table" then
    printTable()
  elseif input == "initialize" then
    InitFluidsFromNetwork()
  elseif input == "edit" then
    editFluids()
  elseif input == "start" then
    print("starting fluid check daemon...")
    checkMain()
  elseif input == "test" then
    for index,value in pairs(mecon.getFluidsFromNetwork()) do
      print(index)
      for type,data in pairs(value) do
        print(type,data)
      end
    end
-----------

  else
    print("invalid input. " .. options)
  end

end

local function main()

  init()
  while true do
  mainMenu()  
  end
  close()
end

main()
--eof
