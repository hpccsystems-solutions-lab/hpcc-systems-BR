IMPORT ML_Core.Discretize;
IMPORT ML_Core;
IMPORT LearningTrees AS LT;
IMPORT $;

// Reference your training and test dataset´s
myDepTrainData := $.Convert02.myDepTrainDataNF;
myDepTestData  := $.Convert02.myDepTestDataNF;
myIndTrainData := $.Convert02.myIndTrainDataNF;
myIndTestData  := $.Convert02.myIndTestDataNF; 
myDepTrainDataDF := Discretize.ByRounding(myDepTrainData);
myDepTestDataDF  := Discretize.ByRounding(myDepTestData);
// OUTPUT(myDepTrainDataDF);

// Define your leaner
myLearnerC := LT.ClassificationForest();

// Train your model
myModelC := myLearnerC.GetModel(myIndTrainData, myDepTrainDataDF); 

// Test your model
predictedClasses := myLearnerC.Classify(myModelC, myIndTestData);

// Assess your model
assessmentC := ML_Core.Analysis.Classification.Accuracy(predictedClasses, myDepTestDataDF); 

// Both params are DF dataset
OUTPUT(assessmentC,NAMED('Model_assess'));
// To test new data
// predictedClasses := myLearnerC.Classify(myModelC, myNewIndData);
// NEW TASK: predict zip code values by other fields.
