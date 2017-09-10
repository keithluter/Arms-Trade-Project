use "diss.dta", clear

qui forv i = 1 / 5 {
  xtreg intPOLITY2_lag`i' dblTIV_ln dblMaddison_ln bytColdWar, fe
    est sto f`i'
  xtreg intPOLITY2_lag`i' dblTIV_ln dblMaddison_ln bytColdWar, re
    est sto r`i'
  hausman f`i' r`i'
}

est tab f*, b(%9.2fc) stats(r2_w) star(.05 .01 .001)

qui forv i = 1 / 5 {
  xtreg intPRCL_lag`i' dblTIV_ln dblMaddison_ln bytColdWar, fe
    est sto f`i'
  xtreg intPRCL_lag`i' dblTIV_ln dblMaddison_ln bytColdWar, re
    est sto r`i'
  hausman f`i' r`i'
}

est tab f*, b(%9.2fc) stats(r2_w) star(.05 .01 .001)

preserve

qui{
  statsby alpha=_b[dblTIV_ln] se=_se[dblTIV_ln] df=e(df_r), by(ccode) clear: xtreg intPOLITY2_lag1 dblTIV_ln bytColdWar dblMaddison_ln, fe
  g t = alpha/se
  g p = 2*ttail(df,abs(t))
  keep if p < 0.05
  so alpha
  sa regs_polity.dta, replace

  restore
  preserve

  statsby alpha=_b[dblTIV_ln] se=_se[dblTIV_ln] df=e(df_r), by(ccode) clear: xtreg intPRCL_lag1 dblTIV_ln bytColdWar dblMaddison_ln, fe
  g t = alpha/se
  g p = 2*ttail(df,abs(t))
  keep if p < 0.05
  so alpha
  sa regs_prcl.dta, replace

  restore
}

*** 800 (Thailand), 666 (Israel), 840 (Philippines), and 790 (Nepal) show up in both lists
*** with coefficients of opposite magnitudes.

loc cases 800 666 840 790

*** One- to five-year POLITY regressions for each case 

qui foreach x of local cases {
  forv i = 1/5 {
    xtreg intPOLITY2_lag`i' dblTIV_ln dblMaddison_ln bytColdWar if ccode == `x', fe
    est sto pol_lag_`x'_`i'
  }
  noi est tab pol_lag_`x'_*, b(%9.2fc) stats(r2_w) star(.05 .01 .001)
}

*** One- to five-year POLITY regressions for each case 

qui foreach x of local cases {
  forv i = 1/5 {
    xtreg intPRCL_lag`i' dblTIV_ln dblMaddison_ln bytColdWar if ccode == `x', fe
    est sto prcl_lag_`x'_`i'
  }
  noi est tab prcl_lag_`x'_*, b(%9.2fc) stats(r2_w) star(.05 .01 .001)
}
