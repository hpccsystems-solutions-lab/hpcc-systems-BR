//Import:ecl:Workshops.SIEEL_2021.BWR_Hello
//Definição de uma string de caracteres
MyString := 'Hello World';
//Ação que permite visualizar a string:
OUTPUT(MyString);
// Equivale a:
OUTPUT('Hello World 2');

//Import:ecl:Workshops.SIEEL_2021.BWR_Train
IMPORT $;
IMPORT ML_Core;
IMPORT LearningTrees AS LT;
// Selecione o algoritmo
myLearnerR    := LT.RegressionForest(10,,10,[1]); 
// myLearnerR    := LT.RegressionForest(,,,[1]); 
// Obtenha o modelo treinado
myModelR      := myLearnerR.GetModel($.modSeg.myIndTrainDataNF,$.modSeg.myDepTrainDataNF);
OUTPUT(myModelR,,'~mymodelXXX',NAMED('ModeloTreinado'),OVERWRITE);
// Teste o modelo
predictedDeps := myLearnerR.Predict(myModelR, $.modSeg.myIndTestDataNF);
OUTPUT(predictedDeps,NAMED('ValoresPrevistos'));
// Avalie o modelo
assessmentR   := ML_Core.Analysis.Regression.Accuracy(predictedDeps,$.modSeg.myDepTestDataNF);
OUTPUT(assessmentR,NAMED('AvaliacaodoModelo'));

//Import:ecl:Workshops.SIEEL_2021.BWR_ViewData
IMPORT $;
// Visualização da extração dos dados
OUTPUT($.modFile.File);
COUNT($.modFile.File);
// OUTPUT($.XTAB_PriceState);
// Preparação dos dados
// OUTPUT($.modPrep.MyDataPrep);
// COUNT($.modPrep.MyDataPrep);
// Segregação dos dados
// OUTPUT($.modSeg.myIndTrainDataNF, NAMED('IndTrainData')); 
// OUTPUT($.modSeg.myDepTrainDataNF, NAMED('DepTrainData')); 
// OUTPUT($.modSeg.myIndTestDataNF, NAMED('IndTestData')); 
// OUTPUT($.modSeg.myDepTestDataNF, NAMED('DepTestData')); 
// Teste do modelo
// OUTPUT($.modFile.File(propertyid=68570)); //118720
// OUTPUT($.modFile.File(propertyid=828195)); //62614
// Teste da Função
// $.FN_GetPrice(95451,118720,2011,14774,1437,3,2,1,1968); //~130k

//Import:ecl:Workshops.SIEEL_2021.FN_GetPrice
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

//Import:ecl:Workshops.SIEEL_2021.modFile
EXPORT modFile := MODULE
		EXPORT Layout := RECORD
			 UNSIGNED8 personid;
			 UNSIGNED4 propertyid;
			 UNSIGNED2 house_number;
			 STRING8   house_number_suffix;
			 STRING2   predir;
			 STRING29  street;
			 STRING5   streettype;
			 STRING2   postdir;
			 STRING6   apt;
			 STRING27  city;
			 STRING2   state;
			 STRING5   zip;
			 UNSIGNED4 total_value;
			 UNSIGNED4 assessed_value;
			 UNSIGNED3 year_acquired;
			 UNSIGNED4 land_square_footage;
			 UNSIGNED3 living_square_feet;
			 UNSIGNED2 bedrooms;
			 UNSIGNED2 full_baths;
			 UNSIGNED2 half_baths;
			 UNSIGNED3 year_built;
		END;
		EXPORT File := DATASET('~propriedadesXXX',Layout,CSV);
END;

//Import:ecl:Workshops.SIEEL_2021.modPrep
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

//Import:ecl:Workshops.SIEEL_2021.modSeg
IMPORT $,ML_Core;
// Considere os primeiros 5000 registros como amostra de treinamento
myTrainData := $.modPrep.myDataPrep[1..5000];  
// Considere os 2000 registros seguintes como amostra de teste
myTestData  := $.modPrep.myDataPrep[5001..7000]; 
																	
// Conversão matricial dos campos numéricos
ML_Core.ToField(myTrainData, myTrainDataNF);
ML_Core.ToField(myTestData, myTestDataNF);
// OUTPUT(myTrainDataNF);
// OUTPUT(myTestDataNF);
EXPORT modSeg := MODULE;
  EXPORT myIndTrainDataNF := myTrainDataNF(number < 10); 
     
	EXPORT myDepTrainDataNF := PROJECT(myTrainDataNF(number = 10), 
																		 TRANSFORM(RECORDOF(LEFT), 
																							SELF.number := 1,
                                              SELF := LEFT));
         			 
	EXPORT myIndTestDataNF := myTestDataNF(number < 10); 
       
  EXPORT myDepTestDataNF := PROJECT(myTestDataNF(number = 10), 
                                    TRANSFORM(RECORDOF(LEFT), 
                                              SELF.number := 1,
                                              SELF := LEFT));
END;

//Import:ecl:Workshops.SIEEL_2021.XTab_PriceState
IMPORT $;
//Referência aos dados em outro arquivo de definição ECL 
Property := $.modFile.File;
//Tabulação cruzada dos preços médios de imóveis por Estado
OutRec := RECORD
	Property.state;
	UNSIGNED4 avg_value := AVE(GROUP,Property.total_value);
END;
EXPORT XTAB_PriceState := TABLE(Property,OutRec,state);


