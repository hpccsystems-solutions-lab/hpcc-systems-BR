IMPORT $, STD;

//Raw input data view
OUTPUT($.File_Property.File,NAMED('Raw_data'));

//Profilling view
// OUTPUT(STD.DataPatterns.Profile($.File_Property.File),ALL,NAMED('Profiled_data'));
OUTPUT($.File_Property.File,,'~WKSHOP::ODSCWest2020::XXX::PropertyDP',OVERWRITE,NAMED('Disk_output'));

//Marketing view (aggr. price value from Property in small streets)
OUTPUT($.PropValSmallStreet,NAMED('Small_street_prop'));

//Graphical view (avg. property price across US states)
OUTPUT($.XTAB_PriceState,NAMED('Prop_price_per_st'));
