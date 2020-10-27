IMPORT $;

// View your cleaned dataset
OUTPUT($.Prep01.myDataE,NAMED('CleanProperty'));
COUNT($.Prep01.myDataE);

// View your training dataset
OUTPUT($.Prep01.myTrainData,NAMED('TrainData'));
COUNT($.Prep01.myTrainData);

// View your test dataset
OUTPUT($.Prep01.myTestData,NAMED('TestData'));
COUNT($.Prep01.myTestData);

// View your dependent and indenpendent variables (training dataset)
OUTPUT($.Convert02.myIndTrainDataNF,NAMED('IndTrainData'));
OUTPUT($.Convert02.myDepTrainDataNF,NAMED('DepTrainData'));
