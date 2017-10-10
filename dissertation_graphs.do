use diss.dta, clear

qui forv i = 1/5 {
	use diss.dta, clear
	statsby alpha`i' = _b[dblTIV_ln] se`i' = _se[dblTIV_ln] df`i' = e(df_r), by(ccode) clear: xtreg intPOLITY2_lag`i' dblTIV_ln bytColdWar dblMaddison_ln, fe
	g t`i' = alpha`i' / se`i'
	g p`i' = 2 * ttail(df, abs(t`i'))
	sa postest`i'.dta, replace
	noi di "`i'-Year Lag Complete"
}

qui forv i = 1/4 {
	mer m:m ccode using postest`i'.dta
	drop _m
}

reshape long alpha se df t p, i(ccode)

keep if p < 0.05
keep if !mi(p)

graph box alpha, over(ccode, sort(1) label(angle(vertical))) nofill
