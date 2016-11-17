clear

set more off
set ou e

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
la var dblTIV "Value of Imports (1990 USD)"

* Delete non-state entities
drop if substr(strCountry, length(strCountry), 1) == "*"
keep if !mi(strCountry)

replace dblTIV = 0.5 if dblTIV == 0
replace dblTIV = 0 if mi(dblTIV)
replace dblTIV = dblTIV / 1000

la var dblTIV "Value of Imports (Thousands of 1990 USD)"

replace strCountry = "Bosnia" if strCountry == "Bosnia-Herzegovina"
replace strCountry = "Congo Brazzaville" if strCountry == "Congo"
replace strCountry = "Congo Kinshasa" if strCountry == "DR Congo"
replace strCountry = "Ivory Coast" if strCountry == "Cote d'Ivoire"
replace strCountry = "Germany East" if strCountry == "East Germany (GDR)"
replace strCountry = "Germany West" if strCountry == "Germany (FRG)"
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



import exc "polity.xls", sh("p4v2015") first clear
ren country strCountry
ren year intYear
drop if intYear < 1950

replace strCountry = "Vietnam" if strCountry == "Vietnam North"
replace strCountry = "Sudan" if strCountry == "Sudan-North"



mer m:m strCountry intYear using "final.dta"
drop _merge
keep if !mi(dblTIV)
keep if !mi(ccode)

xtset ccode intYear

g bytTIV = dblTIV > 0
    la var bytTIV "Importer? (1 = Y)"
g dblTIV_ln = log(dblTIV)
    la var dblTIV_ln "Logged TIV"

forv i = 1/5 {
    g intPOLITY2_lag`i' = F`i'.polity2
    g intPOLITY2_chg`i' = F`i'.polity2 - polity2
    xtreg intPOLITY2_lag`i' dblTIV, fe
    est sto lag`i'
    xtreg intPOLITY2_chg`i' dblTIV, fe
    est sto chg`i'
}

noi est tab lag*, se p
noi est tab chg*, se p
est drop _all
