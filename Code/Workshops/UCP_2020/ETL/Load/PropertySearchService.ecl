IMPORT $.^.Transformation as Transformation;
//uses payload which eliminates the need for an extra I/O FETCH
base_key	:= Transformation.IDX;
	
EXPORT PropertySearchService(STRING25 Lname, STRING15 Fname) := FUNCTION
	Prop_filter := IF(Fname = '',
	                  base_key(lastname=Lname),
										base_key(lastname=Lname,firstname=Fname));
	RETURN Prop_filter;
END;
