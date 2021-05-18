IMPORT $;
IMPORT ML_Core;
IMPORT LearningTrees AS LT;
// Selecione o algoritmo
myLearnerR    := LT.RegressionForest(10,,10,[1]); 
// myLearnerR    := LT.RegressionForest(,,,[1]); 
// Obtenha o modelo treinado
myModelR      := myLearnerR.GetModel($.modSeg.myIndTrainDataNF,$.modSeg.myDepTrainDataNF);
OUTPUT(myModelR,,'~mymodelHMW',NAMED('ModeloTreinado'),OVERWRITE);
// Teste o modelo
predictedDeps := myLearnerR.Predict(myModelR, $.modSeg.myIndTestDataNF);
OUTPUT(predictedDeps,NAMED('ValoresPrevistos'));
// Avalie o modelo
assessmentR   := ML_Core.Analysis.Regression.Accuracy(predictedDeps,$.modSeg.myDepTestDataNF);
OUTPUT(assessmentR,NAMED('AvaliacaodoModelo'));
