//Import:ecl:Workshops.UCP_2020.App.ML.BWR_TrainRegress03
IMPORT LearningTrees AS LT;
IMPORT ML_Core;
IMPORT $;
myLearnerR2    := LT.RegressionForest(,,,[1]); 
myModelR2      := myLearnerR2.GetModel($.Convert02.myIndTrainDataNF, $.Convert02.myDepTrainDataNF);
predictedDeps2 := myLearnerR2.Predict(myModelR2, $.Convert02.myIndTestDataNF);
OUTPUT(predictedDeps2);
assessmentR2   := ML_Core.Analysis.Regression.Accuracy(predictedDeps2, $.Convert02.myDepTestDataNF);
OUTPUT(assessmentR2);

//Import:ecl:Workshops.UCP_2020.App.ML.BWR_ViewPrepData
IMPORT $;
OUTPUT($.Prep01.myDataE,NAMED('CleanProperty'));
COUNT($.Prep01.myDataE);
OUTPUT($.Prep01.myTrainData,NAMED('TrainData'));
COUNT($.Prep01.myTrainData);
OUTPUT($.Prep01.myTestData,NAMED('TestData'));
COUNT($.Prep01.myTestData);
OUTPUT($.Convert02.myIndTrainDataNF,NAMED('IndTrainData'));
OUTPUT($.Convert02.myDepTrainDataNF,NAMED('DepTrainData'));

//Import:ecl:Workshops.UCP_2020.App.ML.Convert02
IMPORT $;
IMPORT ML_Core;
myTrainData := $.Prep01.myTrainData;
myTestData  := $.Prep01.myTestData;
ML_Core.ToField(myTrainData, myTrainDataNF);
ML_Core.ToField(myTestData, myTestDataNF);
// myTrainDataNF;
// myTestDataNF;
EXPORT Convert02 := MODULE
		
		EXPORT myIndTrainDataNF := myTrainDataNF(number < 10); // Number is the field number
		EXPORT myDepTrainDataNF := PROJECT(myTrainDataNF(number = 10), 
																			 TRANSFORM(RECORDOF(LEFT), 
																								 SELF.number := 1,
																								 SELF := LEFT));
		EXPORT myIndTestDataNF := myTestDataNF(number < 10); // Number is the field number
		EXPORT myDepTestDataNF := PROJECT(myTestDataNF(number = 10), 
																			TRANSFORM(RECORDOF(LEFT), 
																								SELF.number := 1,
																								SELF := LEFT));
																									
END;

//Import:ecl:Workshops.UCP_2020.App.ML.File_Property
EXPORT File_Property := MODULE
EXPORT Layout := RECORD
   UNSIGNED8 personid;
   INTEGER8  propertyid;
   STRING10  house_number;
   STRING10  house_number_suffix;
   STRING2   predir;
   STRING30  street;
   STRING5   streettype;
   STRING2   postdir;
   STRING6   apt;
   STRING40  city;
   STRING2   state;
   STRING5   zip;
   UNSIGNED4 total_value;
   UNSIGNED4 assessed_value;
   UNSIGNED2 year_acquired;
   UNSIGNED4 land_square_footage;
   UNSIGNED4 living_square_feet;
   UNSIGNED2 bedrooms;
   UNSIGNED2 full_baths;
   UNSIGNED2 half_baths;
   UNSIGNED2 year_built;
  END;
EXPORT File := DATASET('~CLASS::HPCC::XXX::property',Layout,THOR);
EXPORT MLProp := RECORD
   UNSIGNED8 PropertyID;
   UNSIGNED3 zip; //qualitative
   UNSIGNED4 assessed_value;
   UNSIGNED2 year_acquired;
   UNSIGNED4 land_square_footage;
   UNSIGNED4 living_square_feet;
   UNSIGNED2 bedrooms;
   UNSIGNED2 full_baths;
   UNSIGNED2 half_baths;
   UNSIGNED2 year_built;
   UNSIGNED4 total_value; //Dependent Variable - what we are trying to predict
END;
EXPORT MLPropMI := RECORD
 MLProp;
 UNSIGNED4 wi_id;
END;
//This file is not currently used
EXPORT MLPropDS := DATASET('~CLASS::HPCC::FullPropML',MLProp,THOR);
END;

//Import:ecl:Workshops.UCP_2020.App.ML.Prep01
IMPORT $;
Property := $.File_Property.File;
ML_Prop  := $.File_Property.MLProp;
EXPORT Prep01 := MODULE
			CleanFilter := Property.zip <> '' AND Property.assessed_value <> 0 AND Property.year_acquired <> 0 AND 
										 Property.land_square_footage <> 0 AND Property.living_square_feet <> 0 AND 
										 Property.bedrooms <> 0 AND Property.year_Built <> 0;
			
			MLPropExt := RECORD(ML_Prop)
				UNSIGNED4 rnd; 
			END;
		
			EXPORT myDataE := PROJECT(Property(CleanFilter), TRANSFORM(MLPropExt, 
																																 SELF.rnd := RANDOM(),
																																 SELF.Zip := (UNSIGNED3)LEFT.Zip,
																																 SELF := LEFT))
																																 :PERSIST('~CLASS::HPCC::XXX::PrepProp');
		
			SHARED myDataES := SORT(myDataE, rnd);
			EXPORT myTrainData := PROJECT(myDataES[1..5000], ML_Prop)
																		:PERSIST('~CLASS::HPCC::XXX::Train');  
			
			EXPORT myTestData  := PROJECT(myDataES[5001..7000], ML_Prop)
																		:PERSIST('~CLASS::HPCC::XXX::Test'); 
END;


//Import:ecl:Workshops.UCP_2020.App.NLP.BWR_ParseReviews
IMPORT $;
//Reference your dataset definition
datafile	:=	$.File_Reviews.File;
//Define your PATTERNS, TOKENS and RULES
PATTERN ws          := ' ';
PATTERN alpha				:= PATTERN('[a-zA-Z]');
PATTERN preposition := ['a','the','and','to','both','for','by','until','with'];
PATTERN adverb		  := ['so','extremely','really','very','little','both','some','a lot of',
												'completely','more','close to','in a','kind of','right next to',
												'exactly as','just','while','when'];
PATTERN verb        := ['was','wasn\'t','was not','were','weren\'t','were not',
												'is','isn\'t','is not','are','aren\'t','are not',
												'had','hadn\'t','has','hasn\'t','has not','have','haven\'t','have not'] 
												OPT(ws preposition) OPT(ws adverb);
TOKEN substantive   := alpha alpha+;	
PATTERN adjective   := alpha alpha+ OPT(ws preposition) OPT(ws adverb) OPT(ws alpha+);	
RULE compliment     := substantive ws verb ws adjective ;
//Define your output record structure
results := {UNSIGNED4 prop_id 	:=  datafile.property_id; 
						STRING subst				:=  MATCHTEXT(substantive);
						STRING verb_prep_adv:=  MATCHTEXT(verb);  	              
						STRING adjct  			:=  MATCHTEXT(adjective)};
	             
// Define your PARSE function
outfile := PARSE(datafile,review_text,compliment,results);
//Output the first 100 records
OUTPUT(outfile,NAMED('Parsed_data'));

//Import:ecl:Workshops.UCP_2020.App.NLP.BWR_RawData
IMPORT $;
//Raw input data view
OUTPUT($.File_Reviews.File,NAMED('RawData'));

//Import:ecl:Workshops.UCP_2020.App.NLP.BWR_TVDemo
// Import the TextVectors module

IMPORT TextVectors AS tv;

// Import the Types TextVectors Types module

IMPORT tv.Types;

// Our input will be a list of sentences in Types.Sentence format.

Sentence := Types.Sentence;

// Note that capitalization and punctuation are ignored.

trainSentences := PROJECT($.File_Reviews.File[1..5000],TRANSFORM(Types.Sentence,
																												SELF.sentID:=COUNTER,
																												SELF.text:=LEFt.review_text)); //using Review comments										
trainSentences;
// Create a SentenceVectors instance.  Use default parameters.
// Note that there are many parameters that can be set here, but all
// are optional and default values usually work.

// sv := tv.SentenceVectors(,,,,,,,100);
sv := tv.SentenceVectors();

// Train and return the model, given your set of sentences
model := sv.GetModel(trainSentences);

// We could persist this model and use it later, but we're just
// going to use it in place.

// First lets define some words and sentences for testing.
Word := Types.Word;
testWords := DATASET([{1, 'treat'}, {2, 'neighbourhood'}, {3, 'block'}, {4, 'area'}],
                    Word);
testSents := DATASET([{1, 'the apartment was spacious'},
                      {2, 'the neighbourhood was great'}], Sentence);

// Get the word vectors for the test words.
wordVecs := sv.GetWordVectors(model, testWords);

// Get the sentence vectors for the test sentences.
sentVecs := sv.GetSentVectors(model, testSents);

// Find the 3 closest words to each test word
closestWords := sv.ClosestWords(model, testWords, 6);
OUTPUT(closestWords,NAMED('Closest_words'));

// Find the two closest sentences for each test sentence
closestSents := sv.ClosestSentences(model, testSents, 2);
OUTPUT(closestSents,NAMED('Closest_sents'));

// Find the 1 word that stands out from the rest.
leastSim := sv.LeastSimilarWords(model, testWords, 1);
OUTPUT(leastSim,NAMED('Least_sim'));

// Try an analogy of the form  A is to B as C is to ?
// Return the closest 2 solutions.
result := sv.WordAnalogy(model, 'location', 'quiet', 'place', 2);
OUTPUT(result,NAMED('Word_analogy'));

// Get information about the training: Parameters used, Vocabulary
// size, Number of sentences in Corpus, etc.

trainingStats := sv.GetTrainStats(model);
OUTPUT(trainingStats,NAMED('Training_stats'));


//Import:ecl:Workshops.UCP_2020.App.NLP.File_Reviews
EXPORT File_Reviews := MODULE
//Record definition of the file
	EXPORT Layout := RECORD
		UNSIGNED4 Property_id;
		UNSIGNED4 Review_id;
		UNSIGNED4 Review_date;
		UNSIGNED4 Reviewer_id;
		STRING Reviewer_name;
		STRING Review_text;
	END;
//Reference to the data within the file
	EXPORT File := DATASET('~CLASS::HPCC::XXX::PropertyReviews',
													Layout,CSV(SEPARATOR(','),HEADING(1)));
END;

//Import:ecl:Workshops.UCP_2020.App.Viz.BWR_ViewData
IMPORT $, STD;

//Graphical view (avg. property price across US states)
OUTPUT($.XTAB_PriceState,NAMED('PropPricePerSt'));

//Import:ecl:Workshops.UCP_2020.App.Viz.XTab_PriceState
IMPORT $.^.^.ETL.Extract as Extract;

// reference to the data within another definition 
Property := Extract.File_Property.File;

//Crosstab property average price per state 
OutRec := RECORD
	Property.state;
	UNSIGNED4 avg_value := AVE(GROUP,Property.total_value);
	UNSIGNED4 cnt:=COUNT(GROUP);
END;

EXPORT XTAB_PriceState := TABLE(Property,OutRec,state);






//Import:ecl:Workshops.UCP_2020.ETL.Extract.BWR_InputData
IMPORT $;
//Browse raw input data
OUTPUT($.File_People.File,,'~CLASS::HPCC::XXX::PeopleDP',NAMED('DiskOutput'),OVERWRITE);  
OUTPUT($.File_People.File,NAMED('People'));  
OUTPUT($.File_Property.File,NAMED('Property'));
OUTPUT($.File_Taxdata.File,NAMED('Taxdata'));

//Import:ecl:Workshops.UCP_2020.ETL.Extract.File_People
EXPORT File_People := MODULE
EXPORT Layout := RECORD
  UNSIGNED8 ID;
  STRING15  FirstName;
  STRING25  LastName;
  STRING15  MiddleName;
  STRING2   NameSuffix;
  STRING8   FileDate;
  STRING1   Gender;
  STRING8   BirthDate;
  END;
EXPORT File := DATASET('~CLASS::HPCC::XXX::People',Layout,THOR);
END;

//Import:ecl:Workshops.UCP_2020.ETL.Extract.File_Property
EXPORT File_Property := MODULE
EXPORT Layout := RECORD
   UNSIGNED8 personid;
   INTEGER8  propertyid;
   STRING10  house_number;
   STRING10  house_number_suffix;
   STRING2   predir;
   STRING30  street;
   STRING5   streettype;
   STRING2   postdir;
   STRING6   apt;
   STRING40  city;
   STRING2   state;
   STRING5   zip;
   UNSIGNED4 total_value;
   UNSIGNED4 assessed_value;
   UNSIGNED2 year_acquired;
   UNSIGNED4 land_square_footage;
   UNSIGNED4 living_square_feet;
   UNSIGNED2 bedrooms;
   UNSIGNED2 full_baths;
   UNSIGNED2 half_baths;
   UNSIGNED2 year_built;
  END;
EXPORT File := DATASET('~CLASS::HPCC::XXX::property',Layout,THOR);
 END;

//Import:ecl:Workshops.UCP_2020.ETL.Extract.File_Taxdata
EXPORT File_Taxdata := MODULE
EXPORT Layout :=  RECORD
    INTEGER8  propertyid;
    STRING4   document_year;
    UNSIGNED4 total_val_calc;
    UNSIGNED4 land_val_calc;
    UNSIGNED4 improvement_value_calc;
    UNSIGNED4 assd_total_val;
    UNSIGNED4 tax_amount;
    UNSIGNED4 mkt_total_val;
    UNSIGNED4 mkt_land_val;
    UNSIGNED4 mkt_improvement_val;
    UNSIGNED4 tax_year;
    UNSIGNED4 land_square_footage;
    UNSIGNED4 adjusted_gross_square_feet;
    UNSIGNED4 living_square_feet;
    UNSIGNED2 bedrooms;
    UNSIGNED2 full_baths;
    UNSIGNED2 half_baths;
    UNSIGNED2 stories_number;
   END;
	 
		EXPORT File :=	DATASET('~CLASS::HPCC::XXX::taxdata',Layout,THOR);
   END; 

//Import:ecl:Workshops.UCP_2020.ETL.Load.PropertySearchService
IMPORT $.^.Transformation as Transformation;
//uses payload which eliminates the need for an extra I/O FETCH
base_key	:= Transformation.IDX;
	
EXPORT PropertySearchService(STRING25 Lname, STRING15 Fname) := FUNCTION
	Prop_filter := IF(Fname = '',
	                  base_key(lastname=Lname),
										base_key(lastname=Lname,firstname=Fname));
	RETURN Prop_filter;
END;

//Import:ecl:Workshops.UCP_2020.ETL.Transformation.BWR1_Relate
IMPORT $.^.Extract as Extract;
People    := Extract.File_People;
Property  := Extract.File_Property;
TaxData   := Extract.File_Taxdata;
PropTax   := $.File_PeopleAll.Layout_PropTax;
PeopleAll := $.File_PeopleAll.Layout;
//Step 1: Denorm Property and Taxdata
PropTax ParentMove(Property.Layout Le) := TRANSFORM
  SELF.TaxCount := 0;
  SELF.TaxRecs  := [];
  SELF := Le;
END;
PropParent := PROJECT(Property.File, ParentMove(LEFT));
PropTax ChildMove(PropTax Le, Taxdata.Layout Ri, INTEGER Cnt):=TRANSFORM
  SELF.TaxCount := Cnt;
  SELF.TaxRecs  := Le.TaxRecs + Ri;
  SELF := Le;
END;
PropTaxFile := DENORMALIZE(PropParent,
                           TaxData.File,
                           LEFT.propertyid = RIGHT.propertyid,
                           ChildMove(LEFT,RIGHT,COUNTER))
                           :PERSIST('~CLASS::HPCC::XXX::PERSIST::PropTax');
OUTPUT(PropTaxFile,NAMED('DenormPropTax'));
//Step 2: Denorm People to Property/Taxdata (PropTaxFile):
PeopleAll InitParent(People.Layout Le) := TRANSFORM
  SELF.PropCount := 0;
  SELF.PropRecs  := [];
  SELF := Le;
END;
ParentOnly := PROJECT(People.File, InitParent(LEFT));
PeopleAll ChildMove2(PeopleAll Le, 
                     PropTax Ri, 
                     INTEGER Cnt):=TRANSFORM
  SELF.PropCount := Cnt;
  SELF.PropRecs  := Le.PropRecs + Ri;
  SELF := Le;
END;
File := DENORMALIZE(ParentOnly, 
                    PropTaxFile,
                    LEFT.id = RIGHT.personid,
                    ChildMove2(LEFT,RIGHT,COUNTER))
													  :PERSIST('~CLASS::HPCC::XXX::PERSIST::PeopleAll');
														
OUTPUT(File,,'~~CLASS::HPCC::XXX::PeoplePropTax',OVERWRITE,NAMED('PeoplePropTax'));

//Import:ecl:Workshops.UCP_2020.ETL.Transformation.BWR2_Builds
IMPORT $;
//One file controls the building of indexes as needed
BUILD($.IDX,OVERWRITE);

//Import:ecl:Workshops.UCP_2020.ETL.Transformation.File_PeopleAll
 IMPORT $;
 IMPORT $.^.Extract as Extract;
EXPORT File_PeopleAll := MODULE
 EXPORT Layout_PropTax := RECORD
  Extract.File_Property.Layout;
  UNSIGNED1 TaxCount;
  DATASET(Extract.File_Taxdata.Layout) TaxRecs{MAXCOUNT(20)};
 END;
 EXPORT Layout := RECORD
  Extract.File_People.Layout; 
  UNSIGNED1 PropCount;
  DATASET(Layout_PropTax) PropRecs{MAXCOUNT(20)};
 END;  
 SHARED Filename   := '~CLASS::HPCC::XXX::PeoplePropTax';
 EXPORT People     := DATASET(Filename,Layout,THOR);
 EXPORT Property   := People.PropRecs;
 EXPORT Taxdata    := People.PropRecs.TaxRecs;
 EXPORT PeoplePlus := DATASET(Filename,{Layout,UNSIGNED8 RecPos {VIRTUAL(FilePosition)}},THOR);
END;

//Import:ecl:Workshops.UCP_2020.ETL.Transformation.IDX
IMPORT $;
EXPORT IDX := INDEX($.File_PeopleAll.People,{lastname,firstname},{$.File_PeopleAll.People},'~CLASS::HPCC::XXX::NameIndex');

//Import:ecl:Workshops.UCP_2020.BWR_Hello
//Definition with string literal
MyString := 'Hello World';

//Action that displays the string in the workunit:
OUTPUT(MyString);



