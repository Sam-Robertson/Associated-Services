public with sharing class SAP_Activities implements Queueable, database.allowscallouts{
    private Set<id> triggerNewIds;
    public SAP_Activities(Set<id> triggerNewIds){
        this.triggerNewIds = triggerNewIds;
        System.debug('I will be testing this class');
    }

    public void execute(System.QueueableContext context){
        syncActivites();  
    }

    public void syncActivites(){

        list<task>selectedActivities = [SELECT id, subject, description, action__c, contact_Type__c, ActivityDate, whatId, status, Type FROM task WHERE id IN :triggerNewIds];  //

        list<activityModel> activityList = new List<activityModel>();

        Set<id> whatId = new Set<id>();
        
        for (task  a : selectedActivities) {
            whatId.add(a.whatId);
        }
        System.debug(whatId);

        map<id, account> mappedAccount = new map<id, account> ([SELECT id, SAP_ID__c FROM account WHERE id IN :whatId]);
        
        System.debug(selectedActivities);


        for (task b : selectedActivities) {



            if (b.contact_Type__c == null) {
                b.contact_Type__c = '6 (Customer Relations call)';
            }

            
            if (b.status == 'Completed' || b.Type == 'Call') {
                
                ActivityModel myActivity = new ActivityModel();

                System.debug(mappedAccount.containsKey(b.whatId));
                System.debug(b);
                System.debug(mappedAccount);


                myActivity.Details = b.subject;  
                myActivity.CardCode = mappedAccount.get(b.whatId).SAP_ID__c; 
                myActivity.Notes = b.description;
                myActivity.Activity = b.action__c.left(2).trim(); 
                myActivity.ActivityType = b.contact_Type__c.left(1);
                myActivity.EndDueDate = b.ActivityDate;


                string myXML =  XMLUtility.serialize(myActivity, 'Activity'); 
                myXML = myXML.replace('<?xml version="1.0" encoding="UTF-8"?>', '');
                system.debug(myXML);
                SAP_Callout.postXML('/activity/insert.aspx', myXML); 
            }
            
        }   
        //https://steuberportal.vision33.com/ASSOC_TEST/activity/get/26448.aspx
    }

    

    public class ActivityModel {
        public string Details; 
        public string CardCode; 
        public string Notes; 
        public string Activity; 
        public string ActivityType; 
        public dateTime EndDueDate; 
    
            


    }
}


        // for (task a : myActivites){

        //     if (oldActivites.get(a.id).status != a.status) {
        //         selectedActivities.add(a);
        //         whatId.add(a.whatId);
        //     } 
        // }

            // check keyset to see if mappedAccount does no contain whatid.
            // if (mappedAccount.containsKey(b.whatId)==false) {
            //     System.debug('You are doing great');
            // continue;
            // } 
            // else {
            //     System.debug('You got booted');
            // }

            // if whatid is not an account skip the rest of the for loop. Use a continue to do that.