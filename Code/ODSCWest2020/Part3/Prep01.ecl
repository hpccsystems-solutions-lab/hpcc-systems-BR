IMPORT $;
// Reference your working data 
Property := $.File_Property.File;
ML_Prop  := $.File_Property.MLProp;

EXPORT Prep01 := MODULE
			// Filter out zero and null field values
			CleanFilter := Property.zip <> '' AND Property.assessed_value <> 0 AND Property.year_acquired <> 0 AND 
										 Property.land_square_footage <> 0 AND Property.living_square_feet <> 0 AND 
										 Property.bedrooms <> 0 AND Property.year_Built <> 0;
			
			// Randomize your data
			MLPropExt := RECORD(ML_Prop)
				UNSIGNED4 rnd; 
			END;
		
			EXPORT myDataE := PROJECT(Property(CleanFilter), TRANSFORM(MLPropExt, 
																																 SELF.rnd := RANDOM(),
																																 SELF.Zip := (UNSIGNED3)LEFT.Zip,
																																 SELF := LEFT))
																																 :PERSIST('~WKSHOP::ODSCWest2020::XXX::PrepProp');
		
			SHARED myDataES := SORT(myDataE, rnd);
			// Extract the first 5000 records as your training data
			EXPORT myTrainData := PROJECT(myDataES[1..5000], ML_Prop)
																		:PERSIST('~WKSHOP::ODSCWest2020::XXX::Train');  
			// Extract the next 2000 records as your test data
			EXPORT myTestData  := PROJECT(myDataES[5001..7000], ML_Prop)
																		:PERSIST('~WKSHOP::ODSCWest2020::XXX::Test'); 
END;

