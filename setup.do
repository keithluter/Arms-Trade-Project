* SET UP WORKSPACE

clear
set mo off
set ou e

* IMPORT SIPRI DATA, SAVE AS .DTA

import delim "sipri.csv", varn(11) colr(2) enc(ISO-8859-1)
drop total

ren v1 strCountry

* FROM STATALIST 199421
foreach v of var v* {
    loc x : var l `v'
    ren `v' yr`x'
}

reshape long yr, i(strCountry)
ren yr dblTIV
ren _j intYear

la var strCountry "Country"
la var intYear "Year"

* Delete non-state entities
drop if substr(strCountry, length(strCountry), 1) == "*"
keep if !mi(strCountry)

replace dblTIV = 0.5 if dblTIV == 0
replace dblTIV = 0 if mi(dblTIV)
replace dblTIV = dblTIV / 1000

la var dblTIV "[SIPRI] Value of Imports (Billions of 1990 USD)"

replace strCountry = "Bosnia" if strCountry == "Bosnia-Herzegovina"
replace strCountry = "Congo Brazzaville" if strCountry == "Congo"
replace strCountry = "Congo Kinshasa" if strCountry == "DR Congo"
replace strCountry = "Ivory Coast" if strCountry == "Cote d'Ivoire"
replace strCountry = "Germany East" if strCountry == "East Germany (GDR)"
replace strCountry = "Germany West" if strCountry == "Germany (FRG)" & intYear < 1991
replace strCountry = "Germany" if strCountry == "Germany (FRG)" & intYear > 1990
replace strCountry = "Korea North" if strCountry == "North Korea"
replace strCountry = "Korea South" if strCountry == "South Korea"
replace strCountry = "Myanmar (Burma)" if strCountry == "Myanmar"
replace strCountry = "Macedonia" if strCountry == "Macedonia (FYROM)"
replace strCountry = "Yemen North" if strCountry == "North Yemen"
replace strCountry = "Yemen South" if strCountry == "South Yemen"
replace strCountry = "Slovak Republic" if strCountry == "Slovakia"
replace strCountry = "Vietnam South" if strCountry == "South Vietnam"
replace strCountry = "Vietnam" if strCountry == "Viet Nam"
replace strCountry = "USSR" if strCountry == "Soviet Union"
replace strCountry = "Taiwan" if strCountry == "Taiwan (ROC)"
replace strCountry = "East Timor" if strCountry == "Timor-Leste"

drop if inlist(strCountry, "Total", "Bahamas", "Barbados", "Belize", "Biafra")
drop if inlist(strCountry, "Brunei", "Grenada", "Iceland", "Katanga")
drop if inlist(strCountry, "Kiribati", "Maldives", "Malta", "Marshall Islands")
drop if inlist(strCountry, "Micronesia", "Northern Cyprus", "Palau") 
drop if inlist(strCountry, "Palestine", "Saint Kitts and Nevis")
drop if inlist(strCountry, "Saint Vincent", "Samoa", "Tuvalu")
drop if inlist(strCountry, "Unknown country", "Western Sahara")

sa "final.dta", replace

noi di "SIPRI data imported...."

* IMPORT POLITY DATASET, MERGE WITH FINAL.DTA, RESAVE

import exc "polity.xls", sh("p4v2015") first clear
ren country strCountry
ren year intYear
drop if intYear < 1950

replace scode = "PAK" if scode == "PKS"
replace ccode = 770 if ccode == 769

replace strCountry = "Vietnam" if strCountry == "Vietnam North"
replace strCountry = "Sudan" if strCountry == "Sudan-North"

mer m:m strCountry intYear using "final.dta"
drop _merge
keep if !mi(dblTIV)
keep if !mi(ccode)

sa "final.dta", replace

noi di "POLITY data imported...."

* IMPORT NMC-COW DATASET, MERGE WITH FINAL.DTA, RESAVE

insheet using "NMC_v4_0.csv", clear
ren year intYear
keep if intYear >= 1950
mer m:m ccode intYear using "final.dta"

sa "final.dta", replace

* STATISTICAL ANALYSIS

g bytTIV = dblTIV > 0
    la var bytTIV "[SIPRI] Importer? (1 = Y)"
g dblTIV_ln = log(dblTIV)
    la var dblTIV_ln "[SIPRI] Logged TIV"

la var democ "[POLITY] Democracy Score (1-10)"
replace democ = . if democ < 0
ren democ intDemoc

la var autoc "[POLITY] Autocracy Score (1-10)"
replace autoc = . if autoc < 0
ren autoc intAutoc

la var polity "[POLITY] POLITY Score"
replace polity = . if polity < -10
ren polity intPOLITY

la var polity2 "[POLITY] POLITY2 Score"
replace polity2 = . if polity2 < -10
ren polity2 intPOLITY2

la var cinc "[NMC] CINC Score"
replace cinc = . if cinc == -9
ren cinc dblCINC

la var irst "[NMC] Iron and Steel Production (1000s tons)"
replace irst = . if irst == -9
ren irst intIrSt

la var milex "[NMC] Military Expenditure (1000s CY USD)"
replace milex = . if milex == -9
ren milex intMilEx

la var milper "[NMC] Military Personnel (1000s)"
replace milper = . if milper == -9
ren milper intMilPer

la var pec "[NMC] Primary Energy Consumption (1000s coal-ton equivalents)"
replace pec = . if pec == -9
ren pec intPEC

la var tpop "[NMC] Total Population (1000s)"
replace tpop = . if tpop == -9
ren tpop intTPop

la var upop "[NMC] Urban Population (1000s)"
replace upop = . if upop == -9
ren upop intUPop

g dblUrban = 100 * intUPop / intTPop
la var dblUrban "[NMC-Deriv] Urbanization (%)"

g dblMilitarization = 100 * intMilPer / intTPop
la var dblMilitarization "[NMC-Deriv] Military Share of Pop. (%)"

drop _merge version stateabb scode

sa "final.dta", replace

noi di "NMC data imported...."

* IMPORT FREEDOM HOUSE DATASET

import exc "fh1972_20161.xlsx", sh("data") first clear
ren year intYear
mer m:m ccode intYear using "final.dta"

la var ccode "[ID-Panel] Country Code"
la var intYear "[ID-Time] Year"

la var pr "[FH] Political Rights Score (1-7)"
ren pr intPR

la var cl "[FH] Civil Liberties Score (1-7)"
ren cl intCL

drop _merge edition inverse* min max sum mean status
drop bday bmonth bprec byear
drop eday emonth eprec eyear
drop cyear

la var durable "[POLITY] Regime Durability"
ren durable intDurable

noi di "Freedom House data imported...."

xtset ccode intYear

* Fill all missing -scode- values
bys ccode (scode): replace scode = scode[_N]
bys ccode (country): replace country = country[_N]
so ccode intYear

* IMPORT AID DATA
import delim "API_DT.ODA.ALLD.CD_DS2_en_excel_v2.csv", varn(4) enc(ISO-8859-1) clear

foreach v of var v* {
    loc x : var l `v'
    ren `v' yr`x'
}

reshape long yr, i(countrycode)
ren _j intYear
ren yr intAid
ren countrycode scode
drop ind*

drop if inlist(scode, "ARB", "CEB", "CSS", "EAP", "EAR", "EAS", "ECA", "ECS")
drop if inlist(scode, "EMU", "EUU", "FCS", "HIC", "HPC", "IBD", "IBT", "IDA")
drop if inlist(scode, "IDB", "IDX", "INX", "LAC", "LCN", "LDC", "LIC", "LMC")
drop if inlist(scode, "LMY", "LTE", "MEA", "MIC", "MNA", "OED", "OSS", "PRE")
drop if inlist(scode, "PSS", "PST", "SAS", "SSA", "SSF", "SST", "TEA", "TEC")
drop if inlist(scode, "TLA", "TMN", "TSA", "TSS", "UMC", "WLD", "NAC")

replace scode = "AAB" if scode == "ATG"
replace scode = "ALG" if scode == "DZA"
replace scode = "ANG" if scode == "AGO"
replace scode = "UAE" if scode == "ARE"
replace scode = "AUL" if scode == "AUS"
replace scode = "AUS" if scode == "AUT"
replace scode = "BAH" if scode == "BHR"
replace scode = "BAR" if scode == "BRB"
replace scode = "BFO" if scode == "BFA"
replace scode = "BHM" if scode == "BHS"
replace scode = "BHU" if scode == "BTN"
replace scode = "BNG" if scode == "BGD"
replace scode = "BOS" if scode == "BIH"
replace scode = "BOT" if scode == "BWA"
replace scode = "BRU" if scode == "BRN"
replace scode = "BUI" if scode == "BDI"
replace scode = "BUL" if scode == "BGR"
replace scode = "CAM" if scode == "KHM"
replace scode = "CAO" if scode == "CMR"
replace scode = "CAP" if scode == "CPV"
replace scode = "CDI" if scode == "CIV"
replace scode = "CEN" if scode == "CAF"
replace scode = "CHA" if scode == "TCD"
replace scode = "CON" if scode == "COG"
replace scode = "COS" if scode == "CRI"
replace scode = "CRO" if scode == "HRV"
replace scode = "CZR" if scode == "CZE"
replace scode = "DEN" if scode == "DNK"
replace scode = "DRC" if scode == "COD"
replace scode = "FIJ" if scode == "FJI"
replace scode = "FRN" if scode == "FRA"
replace scode = "GAM" if scode == "GMB"
replace scode = "GMY" if scode == "DEU"
replace scode = "GRG" if scode == "GEO"
replace scode = "GRN" if scode == "GRD"
replace scode = "GUA" if scode == "GTM"
replace scode = "GUI" if scode == "GIN"
replace scode = "HAI" if scode == "HTI"
replace scode = "HON" if scode == "HND"
replace scode = "ICE" if scode == "ISL"
replace scode = "INS" if scode == "IDN"
replace scode = "IRE" if scode == "IRL"
replace scode = "KOS" if scode == "KSV"
replace scode = "KUW" if scode == "KWT"
replace scode = "KYR" if scode == "KGZ"
replace scode = "KZK" if scode == "KAZ"
replace scode = "ROK" if scode == "KOR"
replace scode = "LES" if scode == "LSO"
replace scode = "LAT" if scode == "LVA"
replace scode = "LIB" if scode == "LBY"
replace scode = "MAA" if scode == "MRT"
replace scode = "MAC" if scode == "MKD"
replace scode = "MAD" if scode == "MDV"
replace scode = "MAG" if scode == "MDG"
replace scode = "MAL" if scode == "MYS"
replace scode = "MAS" if scode == "MUS"
replace scode = "MAW" if scode == "MWI"
replace scode = "MLD" if scode == "MDA"
replace scode = "MNC" if scode == "MCO"
replace scode = "MON" if scode == "MNG"
replace scode = "MNG" if scode == "MNE"
replace scode = "MOR" if scode == "MAR"
replace scode = "MSI" if scode == "MHL"
replace scode = "MYA" if scode == "MMR"
replace scode = "MZM" if scode == "MOZ"
replace scode = "NAU" if scode == "NRU"
replace scode = "NEP" if scode == "NPL"
replace scode = "NEW" if scode == "NZL"
replace scode = "NIG" if scode == "NGA"
replace scode = "NIR" if scode == "NER"
replace scode = "NTH" if scode == "NLD"
replace scode = "OMA" if scode == "OMN"
replace scode = "PAL" if scode == "PLW"
replace scode = "PAR" if scode == "PRY"
replace scode = "PHI" if scode == "PHL"
replace scode = "POR" if scode == "PRT"
replace scode = "ROM" if scode == "ROU"
replace scode = "SAF" if scode == "ZAF"
replace scode = "SAL" if scode == "SLV"
replace scode = "SIN" if scode == "SGP"
replace scode = "SIE" if scode == "SLE"
replace scode = "SKN" if scode == "KNA"
replace scode = "SLO" if scode == "SVK"
replace scode = "SLU" if scode == "LCA"
replace scode = "SLV" if scode == "SVN"
replace scode = "SNM" if scode == "SMR"
replace scode = "SOL" if scode == "SLB"
replace scode = "SPN" if scode == "ESP"
replace scode = "SRI" if scode == "LKA"
replace scode = "SUD" if scode == "SDN"
replace scode = "SVG" if scode == "VCT"
replace scode = "SWA" if scode == "SWZ"
replace scode = "SWD" if scode == "SWE"
replace scode = "SWZ" if scode == "CHE"
replace scode = "TAJ" if scode == "TJK"
replace scode = "TAZ" if scode == "TZA"
replace scode = "THI" if scode == "THA"
replace scode = "TOG" if scode == "TGO"
replace scode = "TRI" if scode == "TTO"
replace scode = "UKG" if scode == "GBR"
replace scode = "ZAM" if scode == "ZMB"
replace scode = "ZIM" if scode == "ZWE"

mer m:m scode intYear using "final.dta"

noi di "Aid data imported...."

sa "final.dta", replace
