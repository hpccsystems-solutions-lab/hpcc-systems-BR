IMPORT $;
Property := $.modFile.File;
EXPORT modPrep := MODULE
		
		// Limpando os dados
		CleanFilter := Property.zip <> '' AND Property.assessed_value <> 0 AND Property.year_acquired <> 0 AND 
									 Property.land_square_footage <> 0 AND Property.living_square_feet <> 0 AND 
									 Property.bedrooms <> 0 AND Property.full_baths <> 0 AND Property.year_Built <> 0;
		EXPORT CleanProperty := Property(CleanFilter);
		EXPORT STD_Layout := RECORD
			UNSIGNED8 PropertyID;
			UNSIGNED3 zip; 								//variável categórica
			UNSIGNED4 assessed_value;
			UNSIGNED2 year_acquired;
			UNSIGNED4 land_square_footage;
			UNSIGNED4 living_square_feet;
			UNSIGNED2 bedrooms;
			UNSIGNED2 full_baths;
			UNSIGNED2 half_baths;
			UNSIGNED2 year_built;
			UNSIGNED4 total_value; 				// variável dependente - a ser determinada
			UNSIGNED4 rnd; 								// número aleatório
		END;
		EXPORT myDataP := PROJECT(CleanProperty, TRANSFORM(STD_Layout, 
																													SELF.rnd := RANDOM(),
																													SELF.Zip := (UNSIGNED3)LEFT.Zip,
																													SELF := LEFT));
		// Aleatorize os dados ordenando o campo com número aleatório
		EXPORT myDataPS := SORT(myDataP, rnd);
		EXPORT myDataPrep := PROJECT(myDataPS,STD_Layout and NOT rnd);
END;
