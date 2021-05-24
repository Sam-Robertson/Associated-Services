@IsTest
public with sharing class ActivitiesTriggerTest {
    @IsTest
    public static void ActivitiesTriggerTest() {

        
        // might have to create account with the same whatid 

        test.setMock(httpcalloutmock.class, new MockHttpResponseGenerator());

        account myAccount =  new Account(Name ='More Tests 1' , Branch__c= '1', Type = 'Customer');

        Task myTask = new task(Subject = 'This Test', Contact_Type__c ='20 (Snack Refresh Planning)', Status = 'Open', Action__c ='P (Phone Call)'); 	

        Test.startTest();
        insert myAccount;
        myTask.whatid =  myAccount.id;
        insert myTask;
        myTask.Status = 'Completed';
		update myTask; 
        System.debug(myTask);
        Test.stopTest();

      //  System.assert(httpcalloutmock.calloutComplete,'Your callout is complete');
    }
}