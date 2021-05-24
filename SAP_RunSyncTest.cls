@IsTest
public with sharing class SAP_RunSyncTest {
    @IsTest
    public static void SAP_RunSyncTest() {

       
        List<Integration_Data__c> finalIntegrationData = new List<Integration_Data__c>();  
      
        endpoint__c myEndpoint = new endpoint__c(name = 'account', Salesforce_object__c = 'Account');  
        insert myEndpoint;
       
        insert new mapping__c(endpoint__c = myEndpoint.id, External_Id__c = true, incoming_field__c = '@id', salesforce_field__c = 'SAP_ID__c' );

        String sch = '0 0 23 * * ?';


        test.setMock(httpcalloutmock.class, new MockHttpResponseGenerator());

        Test.startTest();
        System.schedule('ScheduledApexTest', sch, new SAP_RunSync());
        Test.stopTest();

        finalIntegrationData = [SELECT Id, Name FROM Integration_Data__c];

        System.assertEquals(0, finalIntegrationData.size(),'Your method did not upsert any accounts');
    }
}

// I need to edit this to make sure that it actually tests the right class. Look into testing schedualbe classes