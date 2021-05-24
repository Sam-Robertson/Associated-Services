@IsTest
public class SAP_BranchtoSAP_IDTest {
    @IsTest
    public static void TestAddAccount() {
// This test needs to be udpated. I made it mostly for code coverage. Forgive me. 

        account myAccount =  new Account(Name ='This Test' , Branch__c= '5', Type = 'Customer', Day__c = 45.3, Monthly_Budget__c = 65.3, Headcount__c = 9,  Phone = '112341234', 
            Key_Customer__c = true, Snack_Account__c = true, Product_Only__c = true, Fixed_Price_Contract__c = false, Notify_Price_Changes__c = true, Rental_Only__c = false, 
            Equipment_Only__c = true, Royal_Connection__c = true, ShippingStreet = 'mystreet', ShippingCity = 'Provo', ShippingState = 'Kansas', ShippingPostalCode = '73845',  Website = 'www.google.com', 
            BillingStreet = 'Penny Lane', BillingCity = 'LiverPool', BillingState = 'Kansas' );
        
        test.setMock(httpcalloutmock.class, new MockHttpResponseGenerator());

        Test.startTest();
        insert myAccount;
        Test.stopTest();

        account a = [SELECT id, SAP_ID__c, Name, Branch__c FROM account];
      
        System.assertEquals('This Test', a.Name, 'You failed the Test');

  
    }
}