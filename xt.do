clear
set mo off
set ou e

use "final.dta"
so ccode intYear

recode intPOLITY2 (-10/-6 = 1) (-5/5 = 2) (6/10 = 3) (mis = .), gen(ordRegime)
recode ordRegime (3 = 1) (nonm = 0) (mis = .), gen(bytDemoc)
  la var bytDemoc "[POLITY-Deriv] Democracy = 1"
recode ordRegime (2 = 1) (nonm = 0) (mis = .), gen(bytAnoc)
  la var bytAnoc "[POLITY-Deriv] Anocracy = 1"
recode ordRegime (1 = 1) (nonm = 0) (mis = .), gen(bytAutoc)
  la var bytAutoc "[POLITY-Deriv] Autocracy = 1"

g intPOLITY_lag = F.intPOLITY2
  la var intPOLITY_lag "[POLITY-Deriv] Lagged POLITY2 Score"

g intPRCL = intPR + intCL
  la var intPRCL "[FH-Deriv] PR, CL Combined"

g intPRCL_lag = F.intPRCL
  la var intPRCL_lag "[FH-Deriv] Lagged PR, CL Combined"

* Correlation between two DV specifications

reg intPOLITY2 intPRCL

* Time-series regressions

xtreg intPOLITY_lag dblTIV, fe
  est sto POL_raw_fix
xtreg intPRCL_lag dblTIV, fe
  est sto FH_raw_fix
xtreg intPOLITY_lag dblTIV, re
  est sto POL_raw_rnd
xtreg intPRCL_lag dblTIV, re
  est sto FH_raw_rnd

xtreg intPOLITY_lag dblTIV_ln, fe
  est sto POL_log_fix
xtreg intPRCL_lag dblTIV_ln, fe
  est sto FH_log_fix
xtreg intPOLITY_lag dblTIV_ln, re
  est sto POL_log_rnd
xtreg intPRCL_lag dblTIV_ln, re
  est sto FH_log_rnd

hausman POL_raw_fix POL_raw_rnd
hausman FH_raw_fix FH_raw_rnd
hausman POL_log_fix POL_log_rnd
hausman FH_log_fix FH_log_rnd

* Interaction between regime type and TIV

g dblTIVAutoc = dblTIV * bytAutoc
g dblTIVAnoc = dblTIV * bytAnoc
g dblTIVDemoc = dblTIV * bytDemoc

g dblTIVlnAutoc = dblTIV_ln * bytAutoc
g dblTIVlnAnoc = dblTIV_ln * bytAnoc
g dblTIVlnDemoc = dblTIV_ln * bytDemoc

xtreg intPOLITY_lag dblTIVlnAutoc dblTIVlnAnoc dblTIVlnDemoc, fe
xtreg intPOLITY_lag dblTIVAutoc dblTIVAnoc dblTIVDemoc, fe
