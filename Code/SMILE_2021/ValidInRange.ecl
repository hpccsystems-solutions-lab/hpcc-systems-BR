EXPORT ValidInRange(PassedVal, LoVal, HiVal):= FUNCTION
		IsNegative	:=	LoVal < 0 OR HiVAl < 0;
		IsBackwards	:=	HiVal < LoVal;
		IsInRange		:=	PassedVal BETWEEN LoVal AND HiVal;
		
		RETURN MAP(IsNegative	=> 'Invalid Input - Negative value',
							IsBackwards	=> 'Invalid Input - Parameters are reversed',
							IsInRange		=> 'In Range','Out of Range');
END;