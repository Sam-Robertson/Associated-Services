@isTest
public class AccountTiggerTest {
    @isTest static void TestAddAccount() {
        // Test data setup
        Account acct = new Account(Name='Test Account', Branch__c= '5');
       
        test.setMock(httpcalloutmock.class, new MockHttpResponseGenerator());
        
        Test.startTest();
        insert acct;
        Test.stopTest();
        
        account a = [SELECT id, SAP_ID__c FROM account];
        System.assertEquals('504982', a.SAP_ID__c);

    }
    
}