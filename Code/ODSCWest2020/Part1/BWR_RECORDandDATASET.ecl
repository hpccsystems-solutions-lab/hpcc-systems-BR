//Record definition of the file
PersonRec := RECORD
 UNSIGNED4 id;
 STRING40  name;
 STRING5   zip_code;
END;

// reference to the data within the file
persondata := DATASET
  (
	   '~person_file',
		  PersonRec,
			 FLAT
  );
	
	//Output first 100 records
	OUTPUT(persondata, NAMED('PersonSample'));
	
	onezip:= persondata(zip_code = '60505');
	OUTPUT(onezip,NAMED('Zip60505'));
	
	