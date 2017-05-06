clear

do "https://raw.githubusercontent.com/keithluter/Arms-Trade-Project/master/present.do"
sa diss.dta, replace

* http://www.statalist.org/forums/forum/general-stata-discussion/general/72259-t-stat-and-p-values
statsby alpha=_b[dblTIV_ln] se=_se[dblTIV_ln] df=e(df_r), by(ccode): xtreg intPOLITY2_lag1 dblTIV_ln bytColdWar, fe
g t = alpha/se
g p = 2*ttail(df,abs(t))

statsby _b _se, by(ccode) sa(regs.dta, replace): xtreg intPOLITY2_lag1 dblTIV_ln bytColdWar, fe
use regs.dta, clear
so _b_dblTIV_ln
export delimited using "regs.csv", replace

use diss.dta, clear
