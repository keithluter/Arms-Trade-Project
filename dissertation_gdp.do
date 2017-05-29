clear

do "https://raw.githubusercontent.com/keithluter/Arms-Trade-Project/master/present.do"
mer m:m scode intYear using "gdp.dta"
sa "diss.dta", replace

* http://www.statalist.org/forums/forum/general-stata-discussion/general/72259-t-stat-and-p-values
statsby alpha=_b[dblTIV_ln] se=_se[dblTIV_ln] df=e(df_r), by(ccode) clear: xtreg intPOLITY2_lag1 dblTIV_ln bytColdWar dblGDP, fe
g t = alpha/se
g p = 2*ttail(df,abs(t))
export delimited using "regs.csv", replace
sa regs.dta, replace

loc title "Effect Size of Logged Imports on Democratization (One-Year Lag)"
hist alpha, bin(50) freq xti(`title') addplot(pci 0 -0.27 80 -0.27) legend(off)

keep if p < 0.05
hist alpha, bin(10) freq xti(`title') addplot(pci 0 -0.27 10 -0.27) legend(off)

use diss.dta, clear

forv i = 1 / 5 {
  qui xtreg intPOLITY2_lag`i' dblTIV_ln dblGDP bytColdWar, fe
  est sto f`i'
  qui xtreg intPOLITY2_lag`i' dblTIV_ln dblGDP bytColdWar, re
  est sto r`i'
  hausman f`i' r`i'
}

est tab f*, b(%9.2fc) stats(r2_w) star(.05 .01 .001)

local neg 790 840 551 663

qui foreach x of local neg {
  forv i = 1/5 {
    xtreg intPOLITY2_lag`i' dblTIV_ln dblGDP bytColdWar if ccode == `x', fe
    est sto pol_lag_`x'_`i'
  }
  noi est tab pol_lag_`x'_*, b(%9.2fc) stats(r2_w) star(.05 .01 .001)
}

local pos 433 630 93 800

qui foreach x of local pos {
  forv i = 1/5 {
    xtreg intPOLITY2_lag`i' dblTIV_ln dblGDP bytColdWar if ccode == `x', fe
    est sto pol_lag_`x'_`i'
  }
  noi est tab pol_lag_`x'_*, b(%9.2fc) stats(r2_w) star(.05 .01 .001)
}
