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
