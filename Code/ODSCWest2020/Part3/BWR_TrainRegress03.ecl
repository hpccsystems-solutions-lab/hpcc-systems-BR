IMPORT LearningTrees AS LT;
IMPORT ML_Core;
IMPORT $;

// Define your learning algorithm
myLearnerR2    := LT.RegressionForest(,,,[1]); 

// Train your model
myModelR2      := myLearnerR2.GetModel($.Convert02.myIndTrainDataNF, $.Convert02.myDepTrainDataNF);

// Test your model
predictedDeps2 := myLearnerR2.Predict(myModelR2, $.Convert02.myIndTestDataNF);
OUTPUT(predictedDeps2,NAMED('Predicted_prices'));

// Assess your model
assessmentR2   := ML_Core.Analysis.Regression.Accuracy(predictedDeps2, $.Convert02.myDepTestDataNF);
OUTPUT(assessmentR2,NAMED('Model_assess'));
