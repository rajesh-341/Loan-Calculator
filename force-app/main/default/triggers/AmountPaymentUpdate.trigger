trigger AmountPaymentUpdate on Rajesh_Loan_Bank__c ( after update) 
{
    List<Rajesh_Loan_Bank__c> RajeshBank = new List<Rajesh_Loan_Bank__c>();
        
    		for (Rajesh_Loan_Bank__c LoanBank : Trigger.new) 
            {
                Decimal Str;
                Date UpdatedDatePaymentDate = LoanBank.Payment_Date__c;
                List<Loan_History__c> LoanHistory = [SELECT Id, Payment_Date__c, OustandingPrincipalAmount__c From Loan_History__c];      
                    
                for(Loan_History__c LoanHis : LoanHistory)
                {
                    Integer ChildMonth = LoanHis.Payment_Date__c.month();
                    Integer ParentMonth = UpdatedDatePaymentDate.month();
                    Integer ChildYear = LoanHis.Payment_Date__c.year();
                    Integer ParentYear = UpdatedDatePaymentDate.year();            
                    
                    if(ParentMonth == ChildMonth && ParentYear == ChildYear && TriggerFlagSetup.isTriggerRunning == false)
                    {                
                        String IsAmountPaid = String.valueOf(LoanBank.Is_Amount_Paid__c);
                        Switch on IsAmountPaid
                        {
                            when 'true'
                            { 
                                LoanHis.Payment_Status__c = 'Paid';                               
                            }	
                            when 'false'
                            { 
                                LoanHis.Payment_Status__c = 'UnPaid';
                            }
                            when else
                            {
                                System.debug('Out of the bounds');
                            }    
                        }
                        Str = LoanHis.OustandingPrincipalAmount__c;
                        update LoanHis;                        
                    } 
			} 
            TriggerFlagSetup.UncheckBox(); 
             if(Str != null)
                    {
                        TriggerFlagSetup.UpdateCurrentOutstandingBalance(Str.setScale(2, RoundingMode.HALF_UP));
                    }   
        }        
}