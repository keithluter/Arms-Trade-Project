clear
use diss.dta
egen tiv = std(dblTIV_ln)
egen pol = std(intPOLITY2)
egen fh = std(intPRCL)

tssmooth ma mavg_tiv = tiv, window(4 1 0)
tssmooth ma mavg_pol = pol, window(4 1 0)

la var mavg_tiv "Arms Imports (Five-Year Moving Average)"
la var mavg_pol "POLITY Score (Five-Year Moving Average)"

set graphics off

twoway (tsline mavg_tiv mavg_pol) if ccode == 145, ylabel(#2) ttitle("") tlabel(, nolabels) title(Bolivia) legend(off) saving(Bolivia, replace)
twoway (tsline mavg_tiv mavg_pol) if ccode == 771, ylabel(#2) ttitle("") tlabel(, nolabels) title(Bangladesh) legend(off) saving(Bangladesh, replace)
twoway (tsline mavg_tiv mavg_pol) if ccode == 800, ylabel(#2) ttitle("") tlabel(, nolabels) title(Thailand) legend(off) saving(Thailand, replace)
twoway (tsline mavg_tiv mavg_pol) if ccode == 666, ylabel(#2) ttitle("") tlabel(, nolabels) title(Israel) legend(off) saving(Israel, replace)

twoway (tsline mavg_tiv mavg_pol) if ccode == 663, ylabel(#2) ttitle("") tlabel(, nolabels) title(Jordan) legend(off) saving(Jordan, replace)
twoway (tsline mavg_tiv mavg_pol) if ccode == 155, ylabel(#2) ttitle("") tlabel(, nolabels) title(Chile) legend(off) saving(Chile, replace)
twoway (tsline mavg_tiv mavg_pol) if ccode == 840, ylabel(#2) ttitle("") tlabel(, nolabels) title(Philippines) legend(off) saving(Philippines, replace)
twoway (tsline mavg_tiv mavg_pol) if ccode == 790, ylabel(#2) ttitle("") tlabel(, nolabels) title(Nepal) legend(off) saving(Nepal, replace)

set graphics on

gr combine Bolivia.gph Jordan.gph Bangladesh.gph Chile.gph Thailand.gph Philippines.gph Israel.gph Nepal.gph, rows(4) cols(2) graphregion(margin(zero))


egen tiv = std(dblTIV)
egen tivln = std(dblTIV_ln)
egen gdp = std(dblMaddison)
egen gdpln = std(dblMaddison_ln)
la var tiv "Arms Imports (z-score)"
la var tivln "Logged Arms Imports (z-score)"
la var gdp "GDP p.c. (z-score)"
la var gdpln "Logged GDP p.c. (z-score)"
graph hbox tiv tivln gdp gdpln, ylabel(none) legend(span) ti("Effects of Logging on Outliers")
