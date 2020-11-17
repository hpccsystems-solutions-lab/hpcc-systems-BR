EXPORT File_Reviews := MODULE
//Record definition of the file
	EXPORT Layout := RECORD
		UNSIGNED4 Property_id;
		UNSIGNED4 Review_id;
		UNSIGNED4 Review_date;
		UNSIGNED4 Reviewer_id;
		STRING Reviewer_name;
		STRING Review_text;
	END;
//Reference to the data within the file
	EXPORT File := DATASET('~CLASS::HPCC::XXX::PropertyReviews',
													Layout,CSV(SEPARATOR(','),HEADING(1)));
END;
