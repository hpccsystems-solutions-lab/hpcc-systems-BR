PersonRec := RECORD
 UNSIGNED4 id;
 STRING40  name;
 STRING5   zip_code;
END;

// reference to the data within the file
persondata := DATASET('~person_file',PersonRec,FLAT);

ZipLookupRec := RECORD
 STRING5  zip5;
 STRING20 city;
 STRING2  state;
END;

zipdata := DATASET('~zip_lookup',ZipLookupRec,FLAT); 

MergedRec := RECORD
 UNSIGNED4 id;
 STRING40  name;
 STRING20  city;
 STRING2   state;
 STRING5   zip_code;
END;

MergedRec MergePersonAndZip(personRec personinfo,ZipLookupRec zipinfo) := TRANSFORM
 SELF := personinfo; //Copy all matching values from personinfo
 SELF := zipinfo;    //Copy all matching values from zipinfo
END;

PersonAndZipInfo := JOIN
  (
	   persondata,
    ZipData,
    LEFT.zip_code = RIGHT.zip5,
    MergePersonAndZip(LEFT,RIGHT),
    LEFT OUTER
		);
		
OUTPUT(personandzipinfo,NAMED('MergedPersonInfo'));

		