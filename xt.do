clear
set mo off

use "final.dta"
so ccode intYear

g intPOLITY_lag = F.intPOLITY2
  la var intPOLITY_lag "[POLITY-Deriv] Lagged POLITY2 Score"

g intPRCL = intPR + intCL
  la var intPRCL "[FH-Deriv] PR, CL Combined"

g intPRCL_lag = F.intPRCL
  la var intPRCL_lag "[FH-Deriv] Lagged PR, CL Combined"
  
xtreg intPOLITY_lag dblTIV, fe
xtreg intPRCL_lag dblTIV, fe

xtreg intPOLITY_lag dblTIV_ln, fe
xtreg intPRCL_lag dblTIV_ln, fe
