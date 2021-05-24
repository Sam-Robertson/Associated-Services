public with sharing class SAP_Contacts2SAP implements Queueable, database.allowscallouts{
    private Set<id> triggerNewIds;
    integer numberTries;
    public SAP_Contacts2SAP(Set<id> triggerNewIds, integer numberTries){
        this.numberTries = numberTries;
        this.triggerNewIds = triggerNewIds;
    }

    public void execute(System.QueueableContext context){
        ContactsToSAP();  
    
    }

    public void ContactstoSAP() {   

        integer numEmptyRows;

        List<Object> rows = SAP_Callout.get('/query/QueryPortal/729_Portal_CntctInfo.aspx?accept=application/json&AsOfDate=20200101');
        System.debug(rows);
        
        List<Contact> insertedContacts = [SELECT id, Email, FirstName, LastName, Name, Phone, MobilePhone, Birthdate, Title, Fax, 
        Account.SAP_ID__c, LastModifiedDate FROM contact WHERE id IN :triggerNewIds];  

        List<Contact> allContacts = [SELECT id FROM contact];

 

        integer numContacts = allContacts.size() - insertedContacts.size();

        system.debug(insertedContacts);

      

        // check to see if .SAP_ID__c
        // Call seperate sceualble class 
        set<id> contactId = new set<id>();

        for (contact b : insertedContacts) {    

            if (b.Account.SAP_ID__c == null) {
                contactId.add(b.id); 
                continue;
            }
            
            system.debug(b);
            BoModel BO = new BOModel();
            BO.ContactEmployees = new ContactEmployeesModel();
            BO.ContactEmployees.row = new rowModel();
            BO.ContactEmployees.row.CardCode = b.Account.SAP_ID__c; //customer look up fields item__r.[insertfield] 
            BO.ContactEmployees.row.Name = b.Name; 
            BO.ContactEmployees.row.FirstName = b.FirstName;
            BO.ContactEmployees.row.LastName = b.LastName;
            BO.ContactEmployees.row.Position  = b.Title;
            BO.ContactEmployees.row.E_Mail = b.Email; 
            BO.ContactEmployees.row.Phone1 = b.Phone;
            BO.ContactEmployees.row.Phone2 = b.MobilePhone;
            BO.ContactEmployees.row.Fax = b.Fax;
           // BO.ContactEmployees.row.UpdateDate = b.LastModifiedDate;
            BO.ContactEmployees.row.DateOfBirth = b.Birthdate;



            
            string myXML =  XMLUtility.serialize(BO, 'BOM'); 
            myXML = myXML.replace('<?xml version="1.0" encoding="UTF-8"?>', '');
            myXML = myXML.replace('<BOM>', '<BOM><BO><AdmInfo><Version>2</Version><Object>2</Object></AdmInfo>');
            myXML = myXML.replace('</BOM>', '</BO></BOM>');

            
            for (Object c : rows) {    
                numEmptyRows = numEmptyRows + 1;   
            } 
            
            for (Integer i = 0; i < numEmptyRows; i++) {
                myXML = myXML.replace('<ContactEmployees>', '<ContactEmployees><row/>');
            }
    

            system.debug(myXML);
            
            SAP_Callout.postXML('uow/update/oBusinessPartners/' + b.Account.SAP_ID__c + '.aspx', myXML); // Check endpoint
            
            // https://steuberportal.vision33.com/ASSOC_TEST/uow/update/oBusinessPartners/[accountNumber].aspx
            // https://steuberportal.vision33.com/ASSOC_TEST/uow/update/271765.aspx

            //  [/<optional-profile>]/uow/update/contact/<object-key>.aspx
            
    

        }
        
        if (contactId.isempty() == false && numberTries < 4) {
            system.enqueueJob(new SAP_Contacts2SAP(contactId, numberTries + 1)); 
        }
    }


  
    public class BOModel {
        public ContactEmployeesModel ContactEmployees;
    }
    
    public class ContactEmployeesModel {
        public rowModel row; 
    }
    public class rowModel {
        public string CardCode;
        public string Name; 
        public string E_Mail; 
        public string FirstName;
        public string LastName; 
        public string Position; 
        public string Phone1; 
        public string Phone2; 
        public string Fax; 
      //  public dateTime UpdateDate; 
        public dateTime DateOfBirth;   
    
    }
}
//tom.steuber@associatedcoffee.com.sap17grape
// http://steuberb1sql/ASSOC_TEST/uow/update/oBusinessPartners/271765.aspx