public with sharing class SAP_AccountsToSAP implements Promise.Deferred {
    private Id accountId;
    Boolean isUpdate = false;
    public ING_PromiseData promiseData;

    public SAP_AccountsToSAP(Id accountId, Boolean isUpdate) {
        this.accountId = accountId;
        this.isUpdate = isUpdate;
    }

    public Object resolve(Object incomingObject) {
        promiseData = (ING_PromiseData) incomingObject;
        AccountsToSAP();
        return promiseData;
    }


    public void AccountsToSAP() {
        List<Account> insertedAccounts = [
                SELECT Id, Branch__c, SAP_ID__c, Name, Type, ParentId, Day__c, Monthly_Budget__c, Headcount__c, Phone, Key_Customer__c, Snack_Account__c,
                        Product_Only__c, Fixed_Price_Contract__c, Notify_Price_Changes__c, Rental_Only__c, Equipment_Only__c, Royal_Connection__c, OwnerId,
                        ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, Budget_Min_Max__c, Website, Owner.Sales_Employee_Number_SAP__c, BillingStreet, BillingPostalCode, BillingCountry,
                        BillingState, Account_Status__c
                FROM Account
                WHERE Id =:accountId
        ];


        XMLString__c debuggedXML = XMLString__c.getorgdefaults();

        Set<String> accountSet = new Set<String>();

        // This code was supposed to get the current contacts in SAP so we can put in empty <row /> and not delete any existing data
        //  List<Object> rows = SAP_Callout.get('/query/QueryPortal/729_Portal_CntctInfo.aspx?accept=application/json&AsOfDate=20200101');
        //  System.debug(rows);


        // I don't think we'll need this


        for (Account a : insertedAccounts) {
            accountSet.add(a.Id);
        }

        List<Lead> myLeads = [SELECT Id, Name, ConvertedAccountId FROM Lead WHERE ConvertedAccountId IN :accountSet];

        Set<String> leadSet = new Set<String>();
        for (Lead l : myLeads) {
            leadSet.add(l.ConvertedAccountId);
        }

        for (Account b : insertedAccounts) {

            System.debug('This is the current account id ' + b.Id);
            // Check this
            List<Contact> insertedContacts = [
                    SELECT Id, Email, FirstName, LastName, Name, Phone, MobilePhone, Birthdate, Title, Fax,
                            Account.SAP_ID__c, LastModifiedDate, Account.Id, Phone_Extension__c
                    FROM Contact
                    WHERE Account.Id = :b.Id
            ];


            if (leadSet.contains(b.Id) || b.Type == 'Customer') {
                BOModel myBO = new BOModel();
                myBO.BusinessPartners = new BusinessPartnersModel();
                myBO.BusinessPartners.row = new rowModel();
                myBO.BusinessPartners.row.CardCode = b.SAP_ID__c;
                myBO.BusinessPartners.row.CardName = b.Name;
                myBO.BusinessPartners.row.CardType = 'cCustomer';

                myBO.BusinessPartners.row.U_V33_DAILY_EE_BDGT = b.Day__c;
                myBO.BusinessPartners.row.U_V33_MNTHLY_BDGT = b.Monthly_Budget__c;
                myBO.BusinessPartners.row.U_V33_HEADCOUNT = b.Headcount__c;
                myBO.BusinessPartners.row.Phone1 = b.Phone;
                myBO.BusinessPartners.row.Properties1 = b.Key_Customer__c;
                myBO.BusinessPartners.row.Properties2 = b.Snack_Account__c;
                myBO.BusinessPartners.row.Properties5 = b.Product_Only__c;
                myBO.BusinessPartners.row.Properties10 = b.Fixed_Price_Contract__c;
                myBO.BusinessPartners.row.Properties23 = b.Notify_Price_Changes__c;
                myBO.BusinessPartners.row.Properties4 = b.Rental_Only__c;
                myBO.BusinessPartners.row.Properties6 = b.Equipment_Only__c;
                myBO.BusinessPartners.row.Properties9 = b.Royal_Connection__c;
                myBO.BusinessPartners.row.U_V33_SalesEmp = b.Owner.Sales_Employee_Number_SAP__c;
                myBO.BusinessPartners.row.MailAddress = b.ShippingStreet;
                myBO.BusinessPartners.row.MailCity = b.ShippingCity;
                myBO.BusinessPartners.row.MailZipCode = b.ShippingPostalCode;
                myBO.BusinessPartners.row.MailAddress = b.ShippingStreet;
                myBO.BusinessPartners.row.MailCity = b.ShippingCity;
                myBO.BusinessPartners.row.MailZipCode = b.ShippingPostalCode;
                myBO.BusinessPartners.row.U_V33_BudMinMax = b.Budget_Min_Max__c ;
                myBO.BusinessPartners.row.U_STU_ASSIGNED_BRANCH = b.Branch__c;
                myBO.BusinessPartners.row.Website = b.Website;
                myBO.BusinessPartners.row.Frozen = b.Account_Status__c;
                myBO.BusinessPartners.row.BilltoDefault = b.Name;
                myBO.BusinessPartners.row.ShipToDefault = b.Name;
                myBO.ContactEmployees = new ContactEmployeesModel();

                for (Contact c : insertedContacts) {

                    // Contact Mappings
                    myBO.ContactEmployees.Contactrow = new ContactrowModel();
                    myBO.ContactEmployees.Contactrow.CardCode = c.Account.SAP_ID__c;
                    myBO.ContactEmployees.Contactrow.Name = c.Name;
                    myBO.ContactEmployees.Contactrow.FirstName = c.FirstName;
                    myBO.ContactEmployees.Contactrow.LastName = c.LastName;
                    myBO.ContactEmployees.Contactrow.Position = c.Title;
                    myBO.ContactEmployees.Contactrow.E_Mail = c.Email;
                    myBO.ContactEmployees.Contactrow.Phone1 = c.Phone;
                    myBO.ContactEmployees.Contactrow.Phone2 = c.MobilePhone;
                    myBO.ContactEmployees.Contactrow.U_V33_PhoneExtDirect = c.Phone_Extension__c;
                    myBO.ContactEmployees.Contactrow.Fax = c.Fax;
                    myBO.ContactEmployees.Contactrow.DateOfBirth = c.Birthdate;

                }


                //   myBO.BusinessPartners.row.FatherCard = parentAccount.SAP_ID__c;
                // myBO.BPAddresses = new BPAddressesModel();
                // myBO.BPAddresses.row_address = new rowAddressModel();
                // myBO.BPAddresses.row_address.TypeOfAddress = 'B';
                // myBO.BPAddresses.row_address.Street = b.BillingStreet;
                // myBO.BPAddresses.row_address.ZipCode = b.BillingPostalCode;
                // myBO.BPAddresses.row_address.Country = 'US';
                // myBO.BPAddresses.row_address.State = b.BillingState; //This needs to be converted into a UT or CA. Max is two characters 


                String myXML = XMLUtility.serialize(myBO, 'BOM'); // Check rootname
                myXML = myXML.replace('<?xml version="1.0" encoding="UTF-8"?>', ' ');
                myXML = myXML.replace('<BOM>', '<BOM><myBO><AdmInfo><Version>2</Version><Object>2</Object></AdmInfo>');
                myXML = myXML.replace('</BOM>', '</myBO></BOM>');
                myXML = myXML.replaceAll('false', 'tNO');
                myXML = myXML.replaceAll('true', 'tYES');
                myXML = myXML.replaceAll('<Frozen>Inactive</Frozen>', '<Frozen>tYES</Frozen>');
                myXML = myXML.replaceAll('<Frozen>Active</Frozen>', '<Frozen>tNO</Frozen>');
                myXML = myXML.replaceAll('<Frozen />', '');
                myXML = myXML.replaceAll('myBO', 'BO');
                myXML = myXML.replaceAll('row_address', 'row');
                myXML = myXML.replaceAll('Contactrow', 'row');
                System.debug(myBO.BusinessPartners.row.CardCode);
                System.debug(b.ParentId);
                System.debug(myBO.BusinessPartners.row.CardName);
                System.debug(myXML);
                if (this.isUpdate) {
                    SAP_Callout.postXML('uow/update/oBusinessPartners/' + b.SAP_ID__c + '.aspx', myXML);
                } else {
                    SAP_Callout.postXML('uow/insert/oBusinessPartners.aspx', myXML);
                    ING_ProcessorBatch.runBatch();
                }
            }
        }
//        upsert debuggedXML;

    }

    public void execute(System.QueueableContext context) {
        AccountsToSAP();
    }
    public class BOModel {
        public BusinessPartnersModel BusinessPartners;
        public ContactEmployeesModel ContactEmployees;
        //  public BPAddressesModel BPAddresses;
    }
    public class AdmInfoModel {
        public String Object_x;
        public String Version;
    }
    public class BusinessPartnersModel {
        public rowModel row;
    }
    public class rowModel {
        public String CardCode;
        public String CardName;
        public String CardType;
        public String FatherCard;
        public Decimal U_V33_DAILY_EE_BDGT;
        public Decimal U_V33_MNTHLY_BDGT;
        public Decimal U_V33_HEADCOUNT;
        public String Phone1;
        public Boolean Properties1;
        public Boolean Properties2;
        public Boolean Properties5;
        public Boolean Properties10;
        public Boolean Properties23;
        public Boolean Properties4;
        public Boolean Properties6;
        public Boolean Properties9;
        public String U_V33_SalesEmp;
        public String MailAddress;
        public String MailCity;
        public String MailZipCode;
        public String U_V33_BudMinMax;
        public String U_STU_ASSIGNED_BRANCH;
        public String Website;
        public String Frozen;
        public String BilltoDefault;
        public String ShipToDefault;


    }
    public class ContactEmployeesModel {
        public ContactrowModel Contactrow;
    }
    public class ContactrowModel {
        public String CardCode;
        public String Name;
        public String E_Mail;
        public String FirstName;
        public String LastName;
        public String Position;
        public String Phone1;
        public String Phone2;
        public String U_V33_PhoneExtDirect;
        public String Fax;
        public Datetime DateOfBirth;

    }
}


// I'll need to add code to put in empty rows for exisitng contacts

// for (Object c : rows) {    
//     numEmptyRows = numEmptyRows + 1; 

// } 
// System.debug(numEmptyRows);

// for (Integer i = 0; i < numEmptyRows; i++) {
//     myXML = myXML.replace('<ContactEmployees>', '<ContactEmployees><row/>');
// }