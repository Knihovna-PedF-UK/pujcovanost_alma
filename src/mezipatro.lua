kpse.set_program_name "luatex"
local xml = require "src.almaxmlhandler"
-- pouziti: mezipatro.lua vypujcky.xml
-- počítáme  jednotky v mezipatře
local vypujcky_file = arg[1]

local function help()
  print "Chyba: nepodařilo se nahrát soubory"
  print("výpůjčky: " .. (vypujcky_file or ""))
  print "pouziti: texlua almapujcovanost.lua vypujcky.xml seznam_jednotek.xml"
  os.exit()
end

if not vypujcky_file then
  help()
end

local vypujcky_text = xml.load(vypujcky_file)

if not vypujcky_text then
  help()
end

local vypujcky_mapping = {
  C1 = "signatura",
}

local prefixy = {
  Dt = {},
  ["2Sc"] = {},
  F = {0, 22215},
  U = {},
}
local count = 0

xml.process(vypujcky_text, vypujcky_mapping, function(tbl)
  local signatura = tbl.signatura
  if signatura then
    local prefix = signatura:match("^(%d?%a+)")
    local cislo   = signatura:match("(%d+)")
    if not prefix and cislo then
      prefix = "NEZNAME"
      cislo = 0
    end
    local rule = prefixy[prefix] 
    if rule then
      local lower = rule[1] or 0
      local upper = rule[2] or math.huge
      cislo = tonumber(cislo) or -1
      if cislo >= lower and cislo <= upper then
        count = count + 1
        local count_prefix = prefixy[prefix]["count"] or 0
        prefixy[prefix]["count"] = count_prefix + 1
      end
    end
    -- prefixy[prefix] = count + 1
    -- print(string.format("%s\t%s\t%s", signatura, prefix, cislo))
  end
end)

for prefix, rule in pairs(prefixy) do
  if rule.count then
    print(prefix, rule.count)
  end
end

print("Celkem: " .. count)
