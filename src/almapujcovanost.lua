kpse.set_program_name "luatex"
local xml = require "src.almaxmlhandler"
-- pouziti: almapujcovanost.lua vypujcky.xml seznam_jednotek.xml
local vypujcky_file = arg[1]
local seznam_file   = arg[2]

local function help()
  print "Chyba: nepodařilo se nahrát soubory"
  print("výpůjčky: " .. (vypujcky_file or ""))
  print("seznam jednotek: " .. (seznam_file or ""))
  print "pouziti: texlua almapujcovanost.lua vypujcky.xml seznam_jednotek.xml"
  os.exit()
end

if not vypujcky_file or not seznam_file then
  help()
end

local vypujcky_text = xml.load(vypujcky_file)
local seznam_text   = xml.load(seznam_file)

if not vypujcky_text or not seznam_text then
  help()
end

local vypujcky_mapping = {
  C0 = "vypujcky",
  C3 = "ck"
}

-- nahrat pocty vypujcek pro ck
local vypujcky_data = {}
local vypujcky_xml = xml.process(vypujcky_text, vypujcky_mapping, function(tbl)
  vypujcky_data[tbl.ck] = tbl.vypujcky
end)

local seznam_mapping = {
		C0 = "lokace",
		C1 = "signatura",
		C3 = "ck",
		C4 = "typ_dokumentu",
		C11 = "status",
		C12 = "mms",
		C13 = "autor",
		C14 = "nazev", 
		C15 = "rok",

}

-- poradi dat, jak budou vytisteny
local heading = {
		"ck",
    "typ_signatury",
    "poradi_signatury",
		"signatura",
    "pocet_vypujcek",
		"lokace",
		"typ_dokumentu",
		"status",
		"autor",
		"nazev", 
		"rok",
		"mms",
}

local function print_line(line)
  print(table.concat(line, "\t"))
end

-- vytiskni záhlaví tabulky
print_line(heading)

xml.process(seznam_text, seznam_mapping, function(tbl)
  -- nastavit pocet vypujcek
  tbl.pocet_vypujcek = vypujcky_data[tbl.ck] or 0
  local signatura = tbl.signatura or ""
  tbl.typ_signatury, tbl.poradi_signatury = signatura:match("^([0-9]?[A-Za-z%-]+)([0-9]+)")
  local line = {}
  -- srovnat tabulku pro tisk
  for _, head in ipairs(heading) do 
    -- vychytat prázdný buňky
    local value =  tbl[head] 
    if not value or value == "" then value = "-" end
    line[#line+1] = value
  end
  print_line(line)
end)


