public class SAP_BranchtoSAP_ID {
    public static void getCardCode() {

        Set<id> emptyIdAccounts = new Set<id>();
        for (sObject a : trigger.new) {
            if (a.get('SAP_ID__c') == null) {
                emptyIdAccounts.add(a.id);
            }
        }

        system.debug(trigger.new);
        system.debug(trigger.newmap);

        if (emptyIdAccounts.isempty() == false) {
            assignSAPId(emptyIdAccounts);
        }


    }
    @Future(callout=true)
    public static void assignSAPId(Set<id> triggerNewIds) {
        List<Object> rows = SAP_Callout.get('/query/QueryPortal/_NextCustomerNumbers.aspx?accept=application/json');
        List<account> insertedAccounts = [SELECT id, branch__c FROM account WHERE id IN :triggerNewIds];
        for (account a : insertedAccounts) {
            for (object obj : rows) {
                map<string, object> rowMap = (map<string, object>) obj;
                string branchName = (string) rowMap.get('OBPL_BPLID');
                if (branchName == a.branch__c) {
                    string branchId = string.valueOf(rowMap.get('NextNumber'));
                    a.SAP_ID__c = branchId;
                    break;
                }
            }
        }
        system.debug(insertedAccounts);
        update insertedAccounts;
//        system.enqueueJob(new SAP_AccountsToSAP(triggerNewIds));
        ING_PromiseData promiseData = new ING_PromiseData();
        Promise promise = new Promise(new SAP_AccountsToSAP(triggerNewIds, false));
        promise.execute(promiseData);
    }

}