@isTest
public with sharing class SAP_SalesReportTest {
    @isTest
    public static void TestAddAccount() {
        
    

        // Test data setup
        List<SAP_SalesReport.rowData> myDataList = new List<SAP_SalesReport.rowData>();

        Account myAccount = new Account(name = 'myTest');

        insert myAccount;
       
         test.setMock(httpcalloutmock.class, new MockHttpResponseGenerator());
        
        Test.startTest();
        myDataList = SAP_SalesReport.getSalesReport(myAccount.id);
        Test.stopTest();
        
     
        System.assertNotEquals(null, myDataList, 'Your data list is null');

    }
    
}