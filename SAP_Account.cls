public with sharing class SAP_Account  implements Schedulable{
    @future(callout=true)
    public static void getAccounts(string endpoint) {
        // https://steuberportal.vision33.com/ASSOC_TEST
        List<Object> rows = SAP_Callout.get('/query/QueryPortal/_AcctInfo_ByDate.aspx?accept=application/json&AsOfDate=' + endpoint);

        List<Integration_Data__c> sfData = new List<Integration_Data__c>();
        for (Object row : rows) {
            Integration_Data__c intData = ING_Endpoint.processData('account', JSON.serialize(row));
            intData.type__c = 'inbound';
            sfData.add(intData);
        }
        upsert sfData External_Id__c;
    }
    public void execute(SchedulableContext sc) {
        string endpoint = '20210101';
        getAccounts(endpoint);
    }
   
}