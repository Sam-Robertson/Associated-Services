@IsTest
public with sharing class SAP_AccountsToSAPTest {
    @IsTest
    public static void SAP_AccountsToSAPTest() {

        
        // might have to create account with the same whatid 

        test.setMock(httpcalloutmock.class, new MockHttpResponseGenerator());

        Test.startTest();
            account myAccount =  new Account(Name ='More Tests 1' , Branch__c= '1', Type = 'Customer', Day__c = 45.3, Monthly_Budget__c = 65.3, Headcount__c = 9,  Phone = '112341234', 
            Key_Customer__c = true, Snack_Account__c = true, Product_Only__c = true, Fixed_Price_Contract__c = false, Notify_Price_Changes__c = true, Rental_Only__c = false, 
            Equipment_Only__c = true, Royal_Connection__c = true, ShippingStreet = 'mystreet', ShippingCity = 'Provo', ShippingState = 'Kansas', ShippingPostalCode = '73845',  Website = 'www.google.com', 
            BillingStreet = 'Penny Lane', BillingCity = 'LiverPool', BillingState = 'Kansas' );
        
        System.debug(myAccount);
        insert myAccount;
        Test.stopTest();

        //  System.assert(httpcalloutmock.calloutComplete,'Your callout is complete');
    }
}