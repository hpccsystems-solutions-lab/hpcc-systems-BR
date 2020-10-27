PersonRec := RECORD
 UNSIGNED4 id;
 STRING40  name;
 STRING5   zip_code;
END;

// reference to the data within the file
persondata := DATASET('~person_file',PersonRec,FLAT);

ZipPeopleCount := TABLE
   (
	    persondata,
			 {
      zip_code,
      UNSIGNED4 num_people := COUNT(GROUP)
     },
     zip_code,
     MERGE
		 );
		 
OUTPUT(SORT(ZipPeopleCount,-num_people), NAMED('NumPeopleInEachZipCode'));		 