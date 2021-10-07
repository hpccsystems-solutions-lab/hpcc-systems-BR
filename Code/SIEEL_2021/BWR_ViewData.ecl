IMPORT $;
// Visualização da extração dos dados
OUTPUT($.modFile.File);
COUNT($.modFile.File);
OUTPUT($.XTAB_PriceState);
// Preparação dos dados
OUTPUT($.modPrep.MyDataPrep);
COUNT($.modPrep.MyDataPrep);
// Segregação dos dados
OUTPUT($.modSeg.myIndTrainDataNF, NAMED('IndTrainData')); 
OUTPUT($.modSeg.myDepTrainDataNF, NAMED('DepTrainData')); 
OUTPUT($.modSeg.myIndTestDataNF, NAMED('IndTestData')); 
OUTPUT($.modSeg.myDepTestDataNF, NAMED('DepTestData')); 
// Teste do modelo
OUTPUT($.modFile.File(propertyid=68570)); //118720
OUTPUT($.modFile.File(propertyid=828195)); //62614
// Teste da Função
$.FN_GetPrice(95451,118720,2011,14774,1437,3,2,1,1968); //~130k
