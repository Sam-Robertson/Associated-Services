
public with sharing class Headcount_BudgettoSAP implements Queueable, database.allowscallouts{
    private Set<id> triggerNewIds;
    public Headcount_BudgettoSAP(Set<id> triggerNewIds){
        this.triggerNewIds = triggerNewIds;
    }


    public void execute(System.QueueableContext context){
        HeadcounttoSAP();  
    
    }
    public void HeadcounttoSAP() {
      
         List<Headcount_Budget_Log__c> insertedHeadcount = [SELECT id, Account__c, Name,
          Account__r.SAP_ID__c, Headcount__c, Date__c, Budget_Day_Employee__c  FROM Headcount_Budget_Log__c  WHERE id IN :triggerNewIds];

         //

         

        // List<Headcount_Budget_Log__c> newHeadcount = new List<Headcount_Budget_Log__c>(); 
         System.debug(insertedHeadcount);

        //  for (Headcount_Budget_Log__c h : currentHeadcount){
        //     if (oldHeadcount.get(h.id).Name != h.Name && oldHeadcount.get(h.id).Account__c != h.Account__c) {
        //         newHeadcount.add(h);
        //     } 
        // }      
        

        for (Headcount_Budget_Log__c b : insertedHeadcount) {
           

            HeadcountModel myHeadcount = new HeadcountModel();

            myHeadcount.cardCode = b.Account__r.SAP_ID__c;
            myHeadcount.theDate = b.Date__c.format();
            myHeadcount.headcount = (integer)b.Headcount__c; 
            myHeadcount.budget = (integer)b.Budget_Day_Employee__c;
          
          
          //  myHeadcount.headId = b.Name;
     
          //  myHeadcount.monthlyBudget = b.Monthly_Budget__c;

            

            string myXML =  XMLUtility.serialize(myHeadcount, 'UDTEntry'); // rootName
        
            SAP_Callout.postXML('query/QueryPortal/_HeadCount_Update.aspx?CardCode=' + myHeadcount.cardCode + '&Date=' + myHeadcount.theDate + '&HeadCount=' + myHeadcount.headcount + '&EE_Budget=' + myHeadcount.budget + '&accept=application/json', myXML);  

        }
    }

    public class HeadcountModel {
        public string cardCode; 
        public string theDate;
        public integer headcount;
        public integer budget; 

    }
}