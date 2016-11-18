clear
set mo off
set ou e

use "final.dta"

* PRELIMINARY ANALYSIS

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
est clear
drop intPOL*

forv i = 1/5 {
    g intPOLITY2_lag`i' = F`i'.polity2
    g intPOLITY2_chg`i' = F`i'.polity2 - polity2
    xtreg intPOLITY2_lag`i' dblTIV polity2, fe
      est sto lag`i'
    xtreg intPOLITY2_chg`i' dblTIV polity2, fe
      est sto chg`i'
}

noi est tab lag*, se p
noi est tab chg*, se p
est clear

sa "final.dta", replace
