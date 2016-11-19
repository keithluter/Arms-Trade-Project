clear
set mo off

use "final.dta"
so ccode intYear

recode intPOLITY2 (-10/-6 = 1) (-5/5 = 2) (6/10 = 3) (mis = .), gen(ordRegime)
recode ordRegime (3 = 1) (nonm = 0) (mis = .), gen(bytDemoc)
  la var bytDemoc "[POLITY-Deriv] Democracy = 1"
recode ordRegime (2 = 1) (nonm = 0) (mis = .), gen(bytAnoc)
  la var byAnoc "[POLITY-Deriv] Anocracy = 1"
recode ordRegime (1 = 1) (nonm = 0) (mis = .), gen(bytAutoc)
  la var bytAutoc "[POLITY-Deriv] Autocracy = 1"

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
