IMPORT STD;
//Record definition of the file
PersonRec := RECORD
 UNSIGNED4 id;
 STRING40  name;
 STRING5   zip_code;
END;

// reference to the data within the file
persondata := DATASET('~person_file',PersonRec,FLAT);
	
//Output first 100 records
OUTPUT(persondata, NAMED('PersonSample'));
	
//Define a transform that uppercases all names
PersonRec UppercaseName(PersonRec rec) := TRANSFORM
 SELF.name := STD.STR.ToUpperCase(rec.name);
 SELF := rec;
END;
uppercasePersons := PROJECT(persondata, UpperCaseName(LEFT));

//Output first 100 records in UPPERCASE
OUTPUT(uppercasePersons, NAMED('UpperCasePersonSample'));

 
	