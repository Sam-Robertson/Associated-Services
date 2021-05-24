public with sharing class SAP_RunSync  implements Schedulable {
    public static void runSync(string endpoint) {
        SAP_Account.getAccounts(endpoint); // I need to make this dynamic so it grabs the current date and goes back like three months
        ING_ProcessorBatch.runBatch();
    }
    // public static void processData() {
    //     System.debug('what?');
        
    // }
    public void execute(SchedulableContext sc) {
        string endpoint = '20210101';
       runSync(endpoint);    
    }
}