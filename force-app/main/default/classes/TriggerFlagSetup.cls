public class TriggerFlagSetup 
{
    public static Boolean isTriggerRunning = false;

    public static void UncheckBox()
    {
        List<Rajesh_Loan_Bank__c> LoanBank = [SELECT Is_Amount_Paid__c FROM Rajesh_Loan_Bank__c];
        
        for(Rajesh_Loan_Bank__c LoanBankRetrieve : LoanBank)
        {    
            if(LoanBankRetrieve.Is_Amount_Paid__c == true)
            {    
                isTriggerRunning = true;
                LoanBankRetrieve.Is_Amount_Paid__c = false;
                update LoanBankRetrieve;
            } 
        }    
    }
    
    public static void UpdateCurrentOutstandingBalance(Decimal Str)
    {
        List<Rajesh_Loan_Bank__c> LoanBank = [SELECT Is_Amount_Paid__c FROM Rajesh_Loan_Bank__c];
        
        for(Rajesh_Loan_Bank__c LoanBankRetrieve : LoanBank)
        {       
                LoanBankRetrieve.Current_Outstanding_Principle__c = Str;
                System.debug('Current_Outstanding_Principle__c = '+LoanBankRetrieve.Current_Outstanding_Principle__c);
                update LoanBankRetrieve;
        }    
    }
}