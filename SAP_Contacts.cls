public with sharing class SAP_Contacts  implements Schedulable{
    public static void getContacts(string endpoint) {
        List<Object> rows = SAP_Callout.get('/query/QueryPortal/729_Portal_CntctInfo.aspx?accept=application/json&AsOfDate=' + endpoint); // Update endpoint I think they might have the same endpoint. 
        System.debug(rows);
        List<Integration_Data__c> sfData = new List<Integration_Data__c>();
        for (Object row : rows) {
            Integration_Data__c intData = ING_Endpoint.processData('contact', JSON.serialize(row)); // Create mappings in integration engine for headcount and then update the endpoint
        System.debug(intData);
            sfData.add(intData);
        }
        upsert sfData External_Id__c;
    }
    public void execute(SchedulableContext sc) {
        string endpoint = '20210101'; //This is the date of where you want to pull in the data 
        getContacts(endpoint);
    }
}