// EXPORT BWR_Hello := 'todo';

//Definition with string literal
MyString := 'Hello World';

//Action that displays the string in the workunit:
OUTPUT(MyString);

//OR

Suffix := 'World';

//Define a function
STRING AddSuffix(STRING prefix) := prefix + ' ' + Suffix;

myValue := AddSuffix('Hello');

OUTPUT(myValue);
