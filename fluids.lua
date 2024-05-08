local c = require("component")
local fs = require("filesystem")
local tabl = require("table")
local mecon = c.proxy(c.me_controller.address)
local event = require("event")
local currfluid = {}
local pyro = "Blazing Pyrotheum"
local data = {}
local mainTable = {}



function split( inSplitPattern )
    local outResults = {}
    local theStart = 1
    local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
 
    while theSplitStart do
        table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
        theStart = theSplitEnd + 1
        theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
    end
 
    table.insert( outResults, string.sub( self, theStart ) )
    return outResults
end -- credit to solar2d string magic



local function fluidAdd(name, quantityWanted, amountToCraft)
  tabl.insert(mainTable, {name, quantityWanted, amountToCraft})
end

local function LoadFluids()
  local file,err = io.open("fluids.cfg", "r")
  local fluidToLoad = {}
    for x in file do
      fluidToLoad = split(x, ", ")
      tabl.insert(mainTable, fluidToLoad)
  end
end

local function SaveFluids()
  local file,err = io.open("fluids.cfg", "w")
  local itemToSave = ""
  for k,v in pairs(mainTable) do
    for x,y in pairs(v) do
      if x == 1 then
        itemToSave = "{" .. y .. ","
      elseif x == 3 then
        itemToSave = itemToSave .. y .. "} \n"
      else 
        itemToSave = itemToSave .. y .. ","
      end
    end
    file:write(itemToSave)
  end
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
     var = var
  end
end

local function main(arg1,arg2)
  LoadFluids()
  printTable()
  SaveFluids()
  print("saved fluids!")
end

main()
--eof
