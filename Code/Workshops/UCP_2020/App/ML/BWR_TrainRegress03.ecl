IMPORT LearningTrees AS LT;
IMPORT ML_Core;
IMPORT $;
myLearnerR2    := LT.RegressionForest(,,,[1]); 
myModelR2      := myLearnerR2.GetModel($.Convert02.myIndTrainDataNF, $.Convert02.myDepTrainDataNF);
predictedDeps2 := myLearnerR2.Predict(myModelR2, $.Convert02.myIndTestDataNF);
OUTPUT(predictedDeps2);
assessmentR2   := ML_Core.Analysis.Regression.Accuracy(predictedDeps2, $.Convert02.myDepTestDataNF);
OUTPUT(assessmentR2);
