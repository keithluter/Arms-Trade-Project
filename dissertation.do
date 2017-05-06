clear

do "https://raw.githubusercontent.com/keithluter/Arms-Trade-Project/master/present.do"
sa diss.dta, replace

* http://www.statalist.org/forums/forum/general-stata-discussion/general/72259-t-stat-and-p-values
statsby alpha=_b[dblTIV_ln] se=_se[dblTIV_ln] df=e(df_r), sa(regs.dta, replace) by(ccode): xtreg intPOLITY2_lag1 dblTIV_ln bytColdWar, fe
g t = alpha/se
g p = 2*ttail(df,abs(t))
export delimited using "regs.csv", replace
sa regs.dta, replace

use diss.dta, clear

local cases 840 812 652 155 230 800 93 91

qui foreach x of local cases{
  forv i = 1/5 {
    xtreg intPOLITY2_lag`i' dblTIV_ln bytColdWar if ccode == `x', fe
    est sto pol_lag_`x'_`i'
  }
  noi est tab pol_lag_`x'_*, b(%9.2fc) stats(r2_w) star(.05 .01 .001)
}
