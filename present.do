di "Loading Data...."

do "https://raw.githubusercontent.com/keithluter/Arms-Trade-Project/master/setup.do"

di "Analyzing Data...."

do "https://raw.githubusercontent.com/keithluter/Arms-Trade-Project/master/xt.do"

hist dblTIV, freq xti(Value of Imports (Billions of 1990-Constant USD)) yti("")
su dblTIV

hist dblTIV_ln, freq xti(Logged Value of Imports (Billions of 1990-Constant USD)) yti("")
su dblTIV_ln

hist intPOLITY2, freq xti(POLITY2 Score (-10 = Autocracy, 10 = Democracy)) yti("")
su intPOLITY2

hist intPRCL, freq xti(Combined Freedom House Scores (2 = Free)) xlab(2(1)14) yti("")
su intPRCL

forv i = 1/5 {
  g intPOLITY2_lag`i' = F`i'.intPOLITY2
  g intPRCL_lag`i' = F`i'.intPRCL
  xtreg intPOLITY2_lag`i' dblTIVAutoc dblTIVAnoc dblTIVDemoc, fe
  xtreg intPRCL_lag`i' dblTIVAutoc dblTIVAnoc dblTIVDemoc, fe
}
