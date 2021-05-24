@IsTest
public with sharing class SAP_AccountTest {
    @IsTest
    public static void SAP_AccountTest() {

       
        List<Integration_Data__c> finalIntegrationData = new List<Integration_Data__c>();  
      
        endpoint__c myEndpoint = new endpoint__c(name = 'account', Salesforce_object__c = 'Account');  
        insert myEndpoint;
       
        insert new mapping__c(endpoint__c = myEndpoint.id, External_Id__c = true, incoming_field__c = '@id', salesforce_field__c = 'SAP_ID__c' );


        test.setMock(httpcalloutmock.class, new MockHttpResponseGenerator());

        
        String sch = '0 0 23 * * ?';


        Test.startTest();
        SAP_Account.getAccounts('20210101');
        System.schedule('ScheduledApexTest', sch, new SAP_Account());
        Test.stopTest();

        finalIntegrationData = [SELECT Id, Name, type__c FROM Integration_Data__c];

        System.assertNotEquals(0, finalIntegrationData.size(),'Your method did not upsert any accounts');
    }
}