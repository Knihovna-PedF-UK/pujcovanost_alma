 # Statistika půjčovanosti z Almy

V dashboardu pro "Statistiky správy fondu a katalogizaci" si vygeneruju XML
soubor pro "Výpůjčky dle knihoven za konkrétní období - jednotky". Ten obsahuje
čárový kódy a počet výpůjček, ale ne signatury, autory, atd. Takže je musíme
propojit s něčím, co tyhle údaje obsahuje. Třeba "Místní seznam (pořadí dle
signatury jednotky)".

Použití:

    $ texlua src/almapujcovanost.lua vypujcky.xml seznam_jednotek.xml > vysledek.tsv

Pro použití s půjčovaností titulů můžem vygenerovat z "Výpůjčky dle knihoven za konkrétní období - tituly" a pak: 

    $ texlua src/almatitulypujcovanost.lua vypujcky.xml seznam_jednotek.xml > vysledek.tsv
