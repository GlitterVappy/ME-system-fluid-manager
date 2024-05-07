local c = require("component")
local fs = require("filesystem")
local tabl = require("table")
local mecon = c.proxy(c.me_controller.address)
local event = require("event")
local currfluid = ""
local pyro = "Blazing Pyrotheum"
local data = []
local mainTable = {}

local function LoadFluids()
  local file,err = io.open("fluids.cfg", "r")
  if err == nil then
    data = file:read("*a")
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
--Todo: save data as a table
-- example: table["fluidName"] = quantityWanted, amountToCraft

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
-- clearly nonfunctional
local function mMenu(table)
  print("lorem ipsum dolor sit amet")
  for x in #table
  do nothing
    
  end
end
local function setup()
  LoadFluids()
end

local function main(arg1,arg2)
  local index = getIndex()
  local xop = {}
  table.insert(xop[0,1],meow)
end

main()
--eof
