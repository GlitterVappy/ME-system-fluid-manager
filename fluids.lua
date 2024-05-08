local c = require("component")
local fs = require("filesystem")
local tabl = require("table")
local mecon = c.proxy(c.me_controller.address)
local event = require("event")
local currfluid = {}
local pyro = "Blazing Pyrotheum"
local data = []
local mainTable = {}

local function fluidAdd(name, quantityWanted, amountToCraft)
  tabl.insert(mainTable, {name, quantityWanted, amountToCraft})
end

local function LoadFluids()
  local file,err = io.open("fluids.cfg", "r")
  if err == nil then
    data = file:read("*a")
    file:close()
  end
end

local function SaveFluids()
  local file,err = io.open("fluids.cfg", "w")
  local itemToSave = ""
  for k,v in mainTable do
    for x,y in v do
      if x == 0 then
        itemToSave = "{" .. y .. ","
      elseif x == 2 then
        itemToSave = itemToSave .. y .. "}"
      else 
        itemToSave = itemToSave .. y .. ","
      end
    end
    file:write(itemToSave)
      
  file:close()
  LoadFluids()
end
--Todo: save data as a table
-- example: table[index] = {fluidName, quantityWanted, amountToCraft} 

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

local function setFluid(num)
  currfluid = mainTable[0]
end

local function printTable()
  for k,v in pairs(mainTable) do
    for x,y in pairs(v) do
      print(y)
    end
  end
end
local function setup()
  local var = {}
  LoadFluids()
  for k,v in data do
    
  
end

local function main(arg1,arg2)
  fluidAdd("Liquid Pyrotheum", 1000, 100)
  fluidAdd("Cum",9999,20)
  printTable()
  SaveFluids()
  print("saved fluids!")
end

main()
--eof
