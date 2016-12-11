di "Loading Data...."
do "https://raw.githubusercontent.com/keithluter/Arms-Trade-Project/master/setup.do"

di "Analyzing Data...."
do "https://raw.githubusercontent.com/keithluter/Arms-Trade-Project/master/xt.do"

set graph off

  * GRAPHICS 1 THROUGH 3

hist intPOLITY2, freq xti(POLITY2 Score (-10 = Autocracy, 10 = Democracy)) yti("Frequency") bin(21)
hist intPRCL, freq xla(2(1)14) xti(Freedom House Score (2 = Not Free, 14 = Free)) yti("Frequency") bin(13)

bys intYear: egen dblPOLITY = mean(intPOLITY2)
bys intYear: egen dblPRCL = mean(intPRCL)

tw (tsline dblPOLITY, xti("") xla(1950(10)2015) yti("Score") lwidth(thick)) (tsline dblPRCL, lwidth(thick) msize(vsmall))

hist dblTIV, freq xti(Value of Imports (Billions of 1990-Constant USD)) yti("Frequency")
hist dblTIV_ln, freq xti(Logged Value of Imports (Billions of 1990-Constant USD)) yti("Frequency")

  * TABLE 1

xtsum intPOLITY2 intPRCL dblTIV

  * TABLE 2

qui xtreg intPOLITY2 dblTIV bytColdWar, fe
  est sto f
qui xtreg intPOLITY2 dblTIV bytColdWar, re
  est sto r
hausman f r
  * p = 0.4587

est tab r*, b(%9.2fc) stats(r2_w rho chi2 p F F_f corr) star(.05 .01 .001)

qui xtreg intPOLITY2 dblTIV_ln bytColdWar, fe
  est sto f
qui xtreg intPOLITY2 dblTIV_ln bytColdWar, re
  est sto r
hausman f r
  * p = 0.0530

est tab r*, b(%9.2fc) stats(r2_w rho chi2 p F F_f corr) star(.05 .01 .001)

qui xtreg intPRCL dblTIV bytColdWar, fe
  est sto f
qui xtreg intPRCL dblTIV bytColdWar, re
  est sto r
hausman f r
  * p = 0.5915

est tab r*, b(%9.2fc) stats(r2_w rho chi2 p F F_f corr) star(.05 .01 .001)

qui xtreg intPRCL dblTIV_ln bytColdWar, fe
  est sto f
qui xtreg intPRCL dblTIV_ln bytColdWar, re
  est sto r
hausman f r
  * p = 0.0530

est tab r*, b(%9.2fc) stats(r2_w rho chi2 p F F_f corr) star(.05 .01 .001)

  * TABLE 3

est clear

qui forv i = 1/5 {
  xtreg F`i'.intPOLITY2 dblTIV bytColdWar, fe
    est sto f`i'
  xtreg F`i'.intPOLITY2 dblTIV bytColdWar, re
    est sto r`i'
  noi hausman f`i' r`i'
}

est tab r*, b(%9.2fc) stats(r2_w rho chi2 p F F_f corr) star(.05 .01 .001)

  * TABLE 4

est clear

qui forv i = 1/5 {
  xtreg F`i'.intPRCL dblTIV bytColdWar, fe
    est sto f`i'
  xtreg F`i'.intPRCL dblTIV bytColdWar, re
    est sto r`i'
  noi hausman f`i' r`i'
}

est tab r*, b(%9.2fc) stats(r2_w rho chi2 p F F_f corr) star(.05 .01 .001)

  * TABLE 5

est clear

qui forv i = 1/5 {
  xtreg F`i'.intPOLITY2 dblTIV_ln bytColdWar, fe
    est sto f`i'
  xtreg F`i'.intPOLITY2 dblTIV_ln bytColdWar, re
    est sto r`i'
  noi hausman f`i' r`i'
}

est tab r*, b(%9.2fc) stats(r2_w rho chi2 p F F_f corr) star(.05 .01 .001)

  * TABLE 6
  
est clear

qui forv i = 1/5 {
  xtreg F`i'.intPRCL dblTIV_ln bytColdWar, fe
    est sto f`i'
  xtreg F`i'.intPRCL dblTIV_ln bytColdWar, re
    est sto r`i'
  noi hausman f`i' r`i'
}

est tab f*, b(%9.2fc) stats(r2_w rho chi2 p F F_f corr) star(.05 .01 .001)

  * TABLE 7

qui forv i = 1/5 {
  xtreg F`i'.intPOLITY2 dblTIVAutoc dblTIVAnoc dblTIVDemoc bytColdWar, fe
    est sto f`i'
  xtreg F`i'.intPOLITY2 dblTIVAutoc dblTIVAnoc dblTIVDemoc bytColdWar, re
    est sto r`i'
  noi hausman f`i' r`i'
  noi xtoverid
}

est tab f*, b(%9.2fc) stats(r2_w rho chi2 p F F_f corr) star(.05 .01 .001)

  * TABLE 8

qui forv i = 1/5 {
  xtreg F`i'.intPOLITY2 dblTIVlnAutoc dblTIVlnAnoc dblTIVlnDemoc bytColdWar, fe
    est sto f`i'
  xtreg F`i'.intPOLITY2 dblTIVlnAutoc dblTIVlnAnoc dblTIVlnDemoc bytColdWar, re
    est sto r`i'
  noi hausman f`i' r`i'
  noi xtoverid
}

est tab f*, b(%9.2fc) stats(r2_w rho chi2 p F F_f corr) star(.05 .01 .001)

  * TABLE 9

qui forv i = 1/5 {
  xtreg F`i'.intPRCL dblTIVAutoc dblTIVAnoc dblTIVDemoc bytColdWar, fe
    est sto f`i'
  xtreg F`i'.intPRCL dblTIVAutoc dblTIVAnoc dblTIVDemoc bytColdWar, re
    est sto r`i'
  noi hausman f`i' r`i'
  noi xtoverid
}

est tab f*, b(%9.2fc) stats(r2_w rho chi2 p F F_f corr) star(.05 .01 .001)

  * TABLE 10

qui forv i = 1/5 {
  xtreg F`i'.intPRCL dblTIVlnAutoc dblTIVlnAnoc dblTIVlnDemoc bytColdWar, fe
    est sto f`i'
  xtreg F`i'.intPRCL dblTIVlnAutoc dblTIVlnAnoc dblTIVlnDemoc bytColdWar, re
    est sto r`i'
  noi hausman f`i' r`i'
  noi xtoverid
}

est tab f*, b(%9.2fc) stats(r2_w rho chi2 p F F_f corr) star(.05 .01 .001)

  * TABLE 11

g dblTIVfrac = dblTIV / intAid
g dblTIVfrac_ln = log(dblTIV) / log(intAid)

qui forv i = 1/5 {
  xtreg F`i'.intPOLITY2 dblTIVfrac bytColdWar, fe
    est sto f`i'
  xtreg F`i'.intPOLITY2 dblTIVfrac bytColdWar, re
    est sto r`i'
  noi hausman f`i' r`i'
  noi xtoverid
}

est tab r*, b(%9.2fc) stats(r2_w rho chi2 p F F_f corr) star(.05 .01 .001)

qui forv i = 1/5 {
  xtreg F`i'.intPOLITY2 dblTIVfracln* dblTIV_ln bytColdWar, fe
    est sto f`i'
  xtreg F`i'.intPOLITY2 dblTIVfracln* dblTIV_ln bytColdWar, re
    est sto r`i'
  noi hausman f`i' r`i'
  noi xtoverid
}

est tab f*, b(%9.2fc) stats(r2_w rho chi2 p F F_f corr) star(.05 .01 .001)

qui forv i = 1/5 {
  xtreg F`i'.intPRCL dblTIVfracln* dblTIV_ln bytColdWar, fe
    est sto f`i'
  xtreg F`i'.intPRCL dblTIVfracln* dblTIV_ln bytColdWar, re
    est sto r`i'
  noi hausman f`i' r`i'
  noi xtoverid
}

est tab f*, b(%9.2fc) stats(r2_w rho chi2 p F F_f corr) star(.05 .01 .001)
