IMPORT $;
//Referência aos dados em outro arquivo de definição ECL 
Property := $.modFile.File;
//Tabulação cruzada dos preços médios de imóveis por Estado
OutRec := RECORD
	Property.state;
	UNSIGNED4 avg_value := AVE(GROUP,Property.total_value);
END;
EXPORT XTAB_PriceState := TABLE(Property,OutRec,state);

