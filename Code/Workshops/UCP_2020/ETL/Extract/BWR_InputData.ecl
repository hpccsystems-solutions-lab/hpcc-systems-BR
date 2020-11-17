IMPORT $;
//Browse raw input data
OUTPUT($.File_People.File,,'~CLASS::HPCC::XXX::PeopleDP',NAMED('DiskOutput'),OVERWRITE);  
OUTPUT($.File_People.File,NAMED('People'));  
OUTPUT($.File_Property.File,NAMED('Property'));
OUTPUT($.File_Taxdata.File,NAMED('Taxdata'));
