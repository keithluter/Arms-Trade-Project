clear

do "https://raw.githubusercontent.com/keithluter/Arms-Trade-Project/master/present.do"

statsby _b _se, by(ccode) sa(regs): xtreg intPOLITY2_lag1 dblTIV_ln bytColdWar, fe
