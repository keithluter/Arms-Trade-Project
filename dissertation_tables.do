use "diss.dta", clear

qui forv i = 1 / 5 {
  xtreg intPOLITY2_lag`i' dblTIV_ln dblMaddison_ln bytColdWar, fe
    est sto f`i'
  xtreg intPOLITY2_lag`i' dblTIV_ln dblMaddison_ln bytColdWar, re
    est sto r`i'
  hausman f`i' r`i'
}

*** TABLE OF GLOBAL AVERAGES, POLITY AGAINST LOGGED IMPORTS,
*** LOGGED GDP, AND COLD WAR DUMMY
est tab f*, b(%9.2fc) stats(r2_w) star(.05 .01 .001)

qui forv i = 1 / 5 {
  xtreg intPRCL_lag`i' dblTIV_ln dblMaddison_ln bytColdWar, fe
    est sto f`i'
  xtreg intPRCL_lag`i' dblTIV_ln dblMaddison_ln bytColdWar, re
    est sto r`i'
  hausman f`i' r`i'
}

*** TABLE OF GLOBAL AVERAGES, FH AGAINST LOGGED IMPORTS,
*** LOGGED GDP, AND COLD WAR DUMMY
est tab f*, b(%9.2fc) stats(r2_w) star(.05 .01 .001)

*** FINDINGS ARE ROBUST TO REGRESSION SPECIFICATION.
*** OLOGITS FOR BOTH MEASURES ARE STATISTICALLY
*** SIGNIFICANT

xtologit ordRegime dblTIV_ln dblMaddison_ln bytColdWar, or
xtologit F1.ordRegime dblTIV_ln dblMaddison_ln bytColdWar, or
xtologit F5.ordRegime dblTIV_ln dblMaddison_ln bytColdWar, or

recode intPRCL (2/5 = 3) (6/10 = 2) (11/14 = 1), generate(ordFH)
xtologit F1.ordFH dblTIV_ln dblMaddison_ln bytColdWar, or
xtologit F5.ordFH dblTIV_ln dblMaddison_ln bytColdWar, or

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

*** One- to five-year Freedom House regressions for each case 

qui foreach x of local cases {
  forv i = 1/5 {
    xtreg intPRCL_lag`i' dblTIV_ln dblMaddison_ln bytColdWar if ccode == `x', fe
    est sto prcl_lag_`x'_`i'
  }
  noi est tab prcl_lag_`x'_*, b(%9.2fc) stats(r2_w) star(.05 .01 .001)
}

*** GRAPHICS
tssmooth ma fh=intPRCL, window(4 1 0)
tssmooth ma tiv=dblTIV_ln, window(4 1 0)
tssmooth ma pol=intPOLITY2, window(4 1 0)

la var fh "Freedom House"
la var tiv "Logged Arms Imports"
la var pol "POLITY"

twoway (tsline fh, lcolor(midgreen) lwidth(0.6)) (tsline pol, lcolor(blue) lwidth(0.6)) (tsline tiv, lcolor(red) lwidth(0.6)) if ccode == 800, tscale(off) title(Thailand) legend(on rows(3) position(9) ring(0))

twoway (tsline fh, lcolor(midgreen) lwidth(0.6)) (tsline pol, lcolor(blue) lwidth(0.6)) (tsline tiv, lcolor(red) lwidth(0.6)) if ccode == 666, tscale(off) title(Israel) legend(on rows(3) position(9) ring(0))

twoway (tsline fh, lcolor(midgreen) lwidth(0.6)) (tsline pol, lcolor(blue) lwidth(0.6)) (tsline tiv, lcolor(red) lwidth(0.6)) if ccode == 840, tscale(off) title(Philippines) legend(on rows(3) position(9) ring(0))

twoway (tsline fh, lcolor(midgreen) lwidth(0.6)) (tsline pol, lcolor(blue) lwidth(0.6)) (tsline tiv, lcolor(red) lwidth(0.6)) if ccode == 790, tscale(off) title(Nepal) legend(on rows(3) position(9) ring(0))
