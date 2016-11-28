di "Loading Data...."
do "https://raw.githubusercontent.com/keithluter/Arms-Trade-Project/master/setup.do"

di "Analyzing Data...."
do "https://raw.githubusercontent.com/keithluter/Arms-Trade-Project/master/xt.do"

set graph off

* SLIDE 2
hist intPOLITY2, freq xti(POLITY2 Score (-10 = Autocracy, 10 = Democracy)) yti("") bin(21)
hist intPRCL, freq xla(2(1)14) xti(Freedom House Score (2 = Not Free, 14 = Free)) yti("") bin(13)

* SLIDE 3
xtreg intPRCL intPOLITY2, fe
dotplot intPRCL, over(intPOLITY2) xla(-10(2)10) xti("POLITY2 Score") yla(2(2)14) yti("Freedom House Score")

* SLIDE 4
bys intYear: egen dblPOLITY = mean(intPOLITY2)
bys intYear: egen dblPRCL = mean(intPRCL)
la var dblPOLITY "POLITY"
la var dblPRCL "Freedom House"
tw (tsline dblPOLITY, xti("") xla(1950(10)2015) yti("Score") lwidth(thick)) (tsline dblPRCL, lwidth(thick) msize(vsmall))

so ccode intYear

* SLIDE 5
hist dblTIV, freq xti(Value of Imports (Billions of 1990-Constant USD)) yti("Frequency")
hist dblTIV_ln, freq xti(Logged Value of Imports (Billions of 1990-Constant USD)) yti("")

* SLIDE 6
li intYear ccode strCountry dblTIV in 1/10

* SLIDES 7 AND 8
recode intYear (1950/1990 = 1) (1991/2016 = 0), gen(bytColdWar)

qui forv i = 1/5 {
  g intPOLITY2_lag`i' = F`i'.intPOLITY2
  xtreg intPOLITY2_lag`i' dblTIVDemoc dblTIVAnoc dblTIVAutoc bytColdWar, fe
  est sto pol_lag_`i'
}
est tab pol_lag*, b(%9.2fc) stats(r2_w) star(.05 .01 .001)

qui forv i = 1/5 {
  g intPRCL_lag`i' = F`i'.intPRCL
  xtreg intPRCL_lag`i' dblTIVDemoc dblTIVAnoc dblTIVAutoc bytColdWar, fe
  est sto prcl_lag`i'
}
est tab prcl_lag*, b(%9.2fc) stats(r2_w) star(.05 .01 .001)

* SLIDES 9 AND 10
g dblMilExChange = 100 * intMilEx / L.intMilEx
g dblMilExChange_lag = F.dblMilExChange
g dblMilitarization_lag = F.dblMilitarization
sem (dblTIV -> dblMilExChange_lag, ) (dblTIV -> dblMilitarization_lag, ) (dblMilExChange_lag -> intPRCL_lag1, ) (bytColdWar -> intPRCL_lag1, ) (dblMilitarization_lag -> intPRCL_lag1, ), nocapslatent
sem (dblTIV -> dblMilExChange_lag, ) (dblTIV -> dblMilitarization_lag, ) (dblMilExChange_lag -> intPOLITY2_lag1, ) (bytColdWar -> intPOLITY2_lag1, ) (dblMilitarization_lag -> intPOLITY2_lag1, ), nocapslatent

set graph on

/* ADDITIONAL ANALYSIS

qui forv i = 1/5 {
  xtreg intPOLITY2_lag`i' dblTIV_ln bytColdWar, fe cluster(ccode)
  est sto simp`i'
}
est tab simp*, b(%9.2fc) stats(r2_w) star(.05 .01 .001)

qui forv i = 1/5 {
  xtreg intPRCL_lag`i' dblTIV_ln bytColdWar, fe cluster(ccode)
  est sto simp`i'
}
est tab simp*, b(%9.2fc) stats(r2_w) star(.05 .01 .001)

qui forv i = 1/5 {
  xtreg intPRCL_lag`i' dblTIVlnAutoc bytColdWar, fe cluster(ccode)
  est sto aut`i'
  xtreg intPRCL_lag`i' dblTIVlnAnoc bytColdWar, fe cluster(ccode)
  est sto ano`i'
  xtreg intPRCL_lag`i' dblTIVlnDemoc bytColdWar, fe cluster(ccode)
  est sto dem`i'
}

est tab aut*, b(%9.2fc) stats(r2_w) star(.05 .01 .001)
est tab ano*, b(%9.2fc) stats(r2_w) star(.05 .01 .001)
est tab dem*, b(%9.2fc) stats(r2_w) star(.05 .01 .001)
