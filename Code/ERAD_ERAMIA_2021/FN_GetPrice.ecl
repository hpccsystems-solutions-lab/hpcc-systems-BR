IMPORT $;
IMPORT ML_Core;
IMPORT LearningTrees as LT;
EXPORT FN_GetPrice(Zip, Assess_val, Year_acq, 
						Land_sq_ft, Living_sq_ft, Bedrooms, 
						Full_baths, Half_baths, Year_built) := FUNCTION
		myInSet := [zip, assess_val, year_acq, land_sq_ft, living_sq_ft, 
								bedrooms, full_baths, half_baths, year_built];
		myInDs := DATASET(myInSet, {REAL8 myInValue});
		ML_Core.Types.NumericField PrepData(RECORDOF(myInDS) Le, INTEGER C) := TRANSFORM
				SELF.wi 		:= 1,
				SELF.id		 	:= 1,
				SELF.number := C,
				SELF.value 	:= Le.myInValue;
		END;
		myIndepData := PROJECT(myInDs, PrepData(LEFT,COUNTER));
		mymodel := DATASET('~mymodelXXX',ML_Core.Types.Layout_Model2,FLAT,PRELOAD);
		myLearner := LT.RegressionForest(10,,10,[1]);
		myPredictDeps := MyLearner.Predict(myModel, myIndepData);
	
		RETURN OUTPUT(myPredictDeps,{preco:=ROUND(value)});
		
END;
