clear
do "https://raw.githubusercontent.com/keithluter/Arms-Trade-Project/master/dissertation_gdp.do"
sa diss.dta, replace

clear

clear

import exc "mpd_2013-01.xlsx", sh("PerCapitaGDPUpdate") cellra(A3:GH252) first

qui {
ren A intYear
drop if intYear < 1950

drop GB GD GE GF GG GH PuertoRico Taiwan HongKong Asia CG CI DH T
drop CentreNorthItal WEurope smallWEC WOffshoots EEurope LAmerica Caribbean
drop EAsia SmEAsia WAsia SmallAfr TotalAfrica TotalWorld
drop Germany Vietnam Yemen Serbia Montenegro Kosovo WBankGaza EritreaEthiopia
drop Czechoslovakia FCzechoslovakia FUSSR FYugoslavia

keep if !mi(intYear)

ren USA cty2
ren EnglandGBUK cty200
ren Sweden cty380
ren Austria cty305
ren Belgium cty211
ren Denmark cty390
ren Finland cty375
ren France cty220
ren HollandNetherlands cty210
ren Norway cty385
ren Switzerland cty225
ren Ireland cty205
ren Greece cty350
ren Portugal cty235
ren Spain cty230
ren Australia cty900
ren NZealand cty920
ren Canada cty20
ren Albania cty339
ren Bulgaria cty355
ren Hungary cty310
ren Poland cty290
ren Bosnia cty346
ren Croatia cty344
ren Macedonia cty343
ren Slovenia cty349
ren CzechRep cty316
ren Slovakia cty317
ren Armenia cty371
ren Azerbaijan cty373
ren Belarus cty370
ren Estonia cty366
ren Georgia cty372
ren Kazakhstan cty705
ren Latvia cty367
ren Kyrgyzstan cty703
ren Moldova cty359
ren Russia cty365
ren Tajikistan cty702
ren Turkmenistan cty701
ren Ukraine cty369
ren Uzbekistan cty704
ren Argentina cty160
ren Brazil cty140
ren Chile cty155
ren Colombia cty100
ren Mexico cty70
ren Peru cty135
ren Venezuela cty101
ren Bolivia cty145
ren CostaRica cty94
ren Cuba cty40
ren DominicanRep cty42
ren Ecuador cty130
ren ElSalvador cty92
ren Guatemala cty90
ren Haïti cty41
ren Honduras cty91
ren Jamaica cty51
ren Nicaragua cty93
ren Panama cty95
ren Paraguay cty150
ren TTobago cty52
ren China cty710
ren India cty750
ren IndonesiaJavabefore1880 cty850
ren Japan cty740
ren Philippines cty840
ren SKorea cty732
ren Thailand cty800
ren Bangladesh cty771
ren Burma cty775
ren Malaysia cty820
ren Nepal cty790
ren Pakistan cty770
ren Singapore cty830
ren SriLanka cty780
ren Afghanistan cty700
ren Cambodia cty811
ren Laos cty812
ren Mongolia cty712
ren NorthKorea cty731
ren Bahrain cty692
ren Iran cty630
ren Iraq cty645
ren Israel cty666
ren Jordan cty663
ren Kuwait cty690
ren Oman cty698
ren Qatar cty694
ren SaudiArabia cty670
ren Syria cty652
ren UAE cty696
ren Algeria cty615
ren Angola cty540
ren Benin cty434
ren Botswana cty571
ren BurkinaFaso cty439
ren Burundi cty516
ren Cameroon cty471
ren CapeVerde cty402
ren CentrAfrRep cty482
ren Chad cty483
ren CongoBrazzaville cty484
  ren Djibouti cty522
  ren Egypt cty651
  ren Guinea cty438
  ren GuineaBissau cty404
  ren Kenya cty501
  ren Lesotho cty570
  ren Liberia cty450
  ren Libya cty620
  ren Madagascar cty580
  ren Malawi cty554
  ren Mali cty432
  ren Mauritania cty435
  ren Mauritius cty590
  ren Morocco cty600
  ren Mozambique cty541
  ren Namibia cty565
  ren Niger cty436
  ren Nigeria cty475
  ren Rwanda cty517
  ren SaoToméPrincipe cty403
  ren Senegal cty433
  ren SierraLeone cty451
  ren Somalia cty520
  ren CapeColonySouthAfrica cty560
  ren Sudan cty625
  ren Swaziland cty572
  ren Tanzania cty510
  ren Togo cty461
  ren Tunisia cty616
  ren Uganda cty500
  ren Zambia cty551
  ren Zimbabwe cty552
  ren DT cty640
  ren ComoroIslands cty581
  ren CongoKinshasa cty490
  ren Gabon cty481
  ren EquatorialGuinea cty411
  ren Ghana cty452
  ren Lebanon cty660
  ren Lithuania cty368
  ren Uruguay cty165
  ren Yugoslavia cty345
  ren Gambia cty430
  ren CôtedIvoire cty437
  ren Romania cty360
  ren Seychelles cty591

  reshape long cty, i(intYear)

  ren _j ccode
  ren cty dblMaddison

  sa gdpmadd.dta, replace

  use diss.dta, clear
  drop if mi(ccode)
  drop _merge
  mer m:m ccode intYear using "gdpmadd.dta"
}

g dblMaddison_ln = log(dblMaddison)
