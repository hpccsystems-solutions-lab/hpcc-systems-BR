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





