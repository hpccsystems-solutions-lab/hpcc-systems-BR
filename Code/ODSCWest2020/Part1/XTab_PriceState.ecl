IMPORT $;

Property := $.File_Property.File;

OutRec := RECORD
	Property.state;
	UNSIGNED4 avg_value := AVE(GROUP,Property.total_value);
	UNSIGNED4 cnt:=COUNT(GROUP);
END;

EXPORT XTAB_PriceState := TABLE(Property,OutRec,state);





