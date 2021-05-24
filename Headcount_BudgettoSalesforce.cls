public with sharing class Headcount_BudgettoSalesforce  implements Schedulable{
    @future(callout=true)
    public static void getHeadcount(string endpoint) {
        List<Object> rows = SAP_Callout.get('/query/QueryPortal/_AcctHeadCount_ByDate.aspx?accept=application/json&DateTime=' + endpoint); // Update endpoint query/QueryPortal/_AcctHeadCount_ByDate.aspx?DateTime=5/13/21

        List<Integration_Data__c> sfData = new List<Integration_Data__c>();
        for (Object row : rows) {
            Integration_Data__c intData = ING_Endpoint.processData('headcount', JSON.serialize(row)); // Create mappings in integration engine for headcount and then update the endpoint
            intData.type__c = 'inbound';
            sfData.add(intData);
        }
        upsert sfData External_Id__c;
    }
    public void execute(SchedulableContext sc) {
        string endpoint = '20210101'; //This is the date of where you want to pull in the data 
        getHeadcount(endpoint);
    }
}

// Headcount_BudgettoSalesforce c = new Headcount_BudgettoSalesforce ();
// System.schedule('Headcount 1',  '0 33 * * * ?', c);