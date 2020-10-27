EXPORT File_Reviews := MODULE
	EXPORT Layout := RECORD
		UNSIGNED4 Property_id;
		UNSIGNED4 Review_id;
		UNSIGNED4 Review_date;
		UNSIGNED4 Reviewer_id;
		STRING Reviewer_name;
		STRING Review_text;
	END;
	EXPORT File := DATASET('~WKSHOP::ODSCWest2020::XXX::Reviews',
													Layout,CSV(SEPARATOR(','),HEADING(1)));
END;