//Record definition of the file#1
PersonRec := RECORD
 UNSIGNED4 id;
 STRING40  name;
 STRING5   zip_code;
END;

// reference to the data within the file#1
persondata := DATASET('~person_file',PersonRec,FLAT);

//Record definition of the file#2
ZipLookupRec := RECORD
 STRING5  zip5;
 STRING20 city;
 STRING2  state;
END;

// reference to the data within the file#2
zipdata := DATASET('~zip_lookup',ZipLookupRec,FLAT); 

//Record definition of the merged file
MergedRec := RECORD
 UNSIGNED4 id;
 STRING40  name;
 STRING20  city;
 STRING2   state;
 STRING5   zip_code;
END;

//Definition of the logic do join files#1 and #2
MergedRec MergePersonAndZip(personRec personinfo,ZipLookupRec zipinfo) := TRANSFORM
 SELF := personinfo; //Copy all matching values from personinfo
 SELF := zipinfo;    //Copy all matching values from zipinfo
END;

PersonAndZipInfo := JOIN(persondata,ZipData,
												 LEFT.zip_code = RIGHT.zip5,
												 MergePersonAndZip(LEFT,RIGHT),
												 LEFT OUTER);

//Output first 100 joined records
OUTPUT(personandzipinfo,NAMED('MergedPersonInfo'));

		