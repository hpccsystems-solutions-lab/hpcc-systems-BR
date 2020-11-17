IMPORT $;
Property := $.File_Property.File;
ML_Prop  := $.File_Property.MLProp;
EXPORT Prep01 := MODULE
			CleanFilter := Property.zip <> '' AND Property.assessed_value <> 0 AND Property.year_acquired <> 0 AND 
										 Property.land_square_footage <> 0 AND Property.living_square_feet <> 0 AND 
										 Property.bedrooms <> 0 AND Property.year_Built <> 0;
			
			MLPropExt := RECORD(ML_Prop)
				UNSIGNED4 rnd; 
			END;
		
			EXPORT myDataE := PROJECT(Property(CleanFilter), TRANSFORM(MLPropExt, 
																																 SELF.rnd := RANDOM(),
																																 SELF.Zip := (UNSIGNED3)LEFT.Zip,
																																 SELF := LEFT))
																																 :PERSIST('~CLASS::HPCC::XXX::PrepProp');
		
			SHARED myDataES := SORT(myDataE, rnd);
			EXPORT myTrainData := PROJECT(myDataES[1..5000], ML_Prop)
																		:PERSIST('~CLASS::HPCC::XXX::Train');  
			
			EXPORT myTestData  := PROJECT(myDataES[5001..7000], ML_Prop)
																		:PERSIST('~CLASS::HPCC::XXX::Test'); 
END;

