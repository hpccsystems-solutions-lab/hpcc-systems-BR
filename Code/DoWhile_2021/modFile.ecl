EXPORT modFile := MODULE
// Estrutura de campos do dataset bruto
		EXPORT Layout := RECORD
			 UNSIGNED8 personid;
			 UNSIGNED4 propertyid;
			 UNSIGNED2 house_number;
			 STRING8   house_number_suffix;
			 STRING2   predir;
			 STRING29  street;
			 STRING5   streettype;
			 STRING2   postdir;
			 STRING6   apt;
			 STRING27  city;
			 STRING2   state;
			 STRING5   zip;
			 UNSIGNED4 total_value;
			 UNSIGNED4 assessed_value;
			 UNSIGNED3 year_acquired;
			 UNSIGNED4 land_square_footage;
			 UNSIGNED3 living_square_feet;
			 UNSIGNED2 bedrooms;
			 UNSIGNED2 full_baths;
			 UNSIGNED2 half_baths;
			 UNSIGNED3 year_built;
		END;
		// Declaração do dataset bruto
		EXPORT File := DATASET('~propriedadesXXX',Layout,CSV);  //Substitua XXX pelas iniciais do seu nome completo
END;
