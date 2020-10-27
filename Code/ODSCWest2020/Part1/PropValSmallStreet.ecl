IMPORT $;

// Define your working datasets and fields
Property := $.File_Property.File;
Total    := Property.Total_value;
Assessed := Property.Assessed_value; 

// Define your filter conditions
IsSmallStreet := Property.StreetType IN ['CT','LN','WAY','CIR','PL','TRL'];
HighValue := IF($.IsValidAmount(Total) AND
                $.IsValidAmount(Assessed),
                 IF(Total > Assessed,Total,Assessed),
                 IF($.IsValidAmount(Total),Total,Assessed));

// Filter and aggregate your data										
SmallProperties := Property(IsSmallStreet AND $.IsValidAmount(HighValue));
EXPORT PropValSmallStreet := IF(NOT EXISTS(SmallProperties),
                                -9,
                                SUM(SmallProperties,HighValue));
