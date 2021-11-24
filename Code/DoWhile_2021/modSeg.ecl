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
