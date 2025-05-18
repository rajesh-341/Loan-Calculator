trigger CreateChildRecords on Rajesh_Loan_Bank__c (after insert) 
{
	List<Loan_History__c> LoanHistory = new List<Loan_History__c>();

    for (Rajesh_Loan_Bank__c LoanBank : Trigger.new) 
    {   
       	String StringValue = LoanBank.Tenure__c;
        Decimal intValue;
        String numericPart;
       	Decimal InterestPercentage = LoanBank.Interest_Percentage__c;  
        Decimal TotalAmount = LoanBank.Total_Loan_Amount__c;
        
        if(StringValue.contains('month'))
        {
           numericPart = StringValue.replaceAll('[^0-9.]', ''); 
           intValue = Decimal.valueOf(numericPart);
		   intValue = intValue/2;         
        }
        else
        {    
            numericPart = StringValue.replaceAll('[^0-9.]', ''); 
            intValue = Decimal.valueOf(numericPart);
        }
        if(StringValue.contains('10'))
        {
           numericPart = StringValue.replaceAll('[^0-9.]', ''); 
           intValue = Decimal.valueOf(numericPart);
		   intValue = 10;         
        }
        Decimal Principal = TotalAmount;
        Decimal Principal2 = TotalAmount;
        System.debug('Principal = '+Principal + 'Principal2 = ' + Principal2);
        for(Integer i=1; i <= (intValue*2); i++)
        {  
            Double EMI;                       
            Decimal LoanTenure = intValue*12;
            Decimal MonthlyRate = (InterestPercentage/(12*100));
            
           	Double LoanTenureDouble = LoanTenure.doubleValue();
            Double MonthlyRateDouble = MonthlyRate.doubleValue();
            Double Exponential = Math.pow((1+MonthlyRateDouble), LoanTenureDouble);                       
            EMI = Principal2 * MonthlyRate * ( Exponential / (Exponential -1));
            /* EMI Round Off Value */
            Decimal EMIRoundOff = Decimal.valueOf(EMI).setScale(2, RoundingMode.HALF_UP);
           
            Double InterestMonth = Principal * MonthlyRateDouble;
            Double PrincipalMonth = EMI - InterestMonth;
            Double OustandingPrincipalDouble = Principal - PrincipalMonth;
            Decimal OustandingPrincipal = Decimal.valueOf(OustandingPrincipalDouble);
            Principal = OustandingPrincipal;
			            
            Loan_History__c child = new Loan_History__c();
            child.LAN__c = LoanBank.Id;
            Integer month = LoanBank.Payment_Date__c.month();
            Integer year = LoanBank.Payment_Date__c.year();   
			Integer day = LoanBank.Payment_Date__c.day();            
            Date newDate = Date.newInstance(year, (month+i), day);
            
            if(i == 1)
            {
               child.Payment_Date__c = LoanBank.Payment_Date__c;  
               child.Payment_Status__c = 'Paid';
            }
            else
            {    
                child.Payment_Date__c = newDate;
            } 
            
            child.Payment_Due_Date__c = child.Payment_Date__c.addDays(8);
            child.Interest_Amount__c = EMIRoundOff;
            child.OustandingPrincipalAmount__c = Principal;
            LoanHistory.add(child);            
        }    
    }

    if (!LoanHistory.isEmpty()) 
    {
        insert LoanHistory;
    }    
}