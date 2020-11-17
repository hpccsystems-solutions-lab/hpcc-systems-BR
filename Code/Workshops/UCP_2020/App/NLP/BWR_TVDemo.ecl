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

