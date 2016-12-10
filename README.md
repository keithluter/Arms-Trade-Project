# Arms Trade Project

The do-file `setup.do` will import and merge five datasets, provided they are in Stata's working directory:

* `sipri.csv`––The Stockholm International Peace Research Institute's [Trend-Indicator Value](https://www.sipri.org/databases/armstransfers) tables.
* `polity.xls`––The [Polity IV](http://www.systemicpeace.org/inscrdata.html) dataset from the Center for Systemic Peace.
* `NMC_v4_0.csv`––The [National Military Capabilities](http://www.correlatesofwar.org/data-sets/national-material-capabilities) dataset from the Correlates of War Project.
* `fh1972_20161.xlsx`––Amanda Edgell's spreadsheet capturing annual [Freedom House](https://acrowinghen.com/2016/08/10/freedom-house-2016-update/) data.
* `API_DT.ODA.ALLD.KD_DS2_en_csv_v2.csv`––The OECD's [annual data on official aid receipts](http://data.worldbank.org/indicator/DT.ODA.ALLD.KD).

The `xt.do` do-file will designate the merged dataset as panel data and clean up the Stata workspace for later use.
