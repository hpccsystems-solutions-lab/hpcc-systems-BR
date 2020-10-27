EXPORT File_Property := MODULE
// Define your raw record structure
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
// Define your dataset
EXPORT File := DATASET('~WKSHOP::ODSCWest2020::XXX::property',Layout,THOR);

// Define the record structure for the numeric fields
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
EXPORT MLPropDS := DATASET('~WKSHOP::ODSCWest2020::XXX::FullPropML',MLProp,THOR);
END;
