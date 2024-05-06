local c = require("component")
local fs = require("filesystem")
local mecon = c.proxy(c.me_controller.address)
local event = require("event")
local tabs = [[]]
local currfluid = ""
local pyro = "Blazing Pyrotheum"

local function LoadFluids()
  local file,err = io.open("fluids.cfg", "r")
  if err == nil then
    local data = file:read("*a")
    file:close()
  end
end
local function SaveFluids(list)
  local file,err = io.open("fluids.cfg", "w")
  local itemsToSave = {"Blazing Pyrotheum", "Aerotheum ig"}
  file:write(itemsToSave[1])
  file:close()
  LoadFluids()
end

local function getIndex(string)
  local table = mecon.getFluidsInNetwork()
  local length = #table
  for index = 1,length do
    for type,value in pairs(table[index]) do
      if type == "label" and value == string then
        return(index)        
      end
    end
  end
end

local function setFluid(str)
  currfluid = str
end


local function main(arg1,arg2)
  local index = getIndex()
  SaveFluids()
end

main()
--eof
