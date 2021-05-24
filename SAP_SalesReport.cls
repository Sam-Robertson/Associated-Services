public with sharing class SAP_SalesReport {
    
    @AuraEnabled(cacheable=true)
    public static List<rowData> getSalesReport(string recordId) { 
        System.debug(recordId);
       account cardId =  [SELECT id, SAP_ID__c from account WHERE id=:recordId]; 
       

        List<Object> rows = SAP_Callout.get('/query/QueryPortal/_SalesHistory.aspx?CardCode=' + cardId.SAP_ID__c + '&accept=application/json');
        system.debug(rows);
        List<rowData> dataList = new List<rowData>();
		for (Object row : rows) {
            map<string, object> rowMap = (map<string, object>)row;
            rowData data = new rowData();
            data.id = rowMap.get('@id')!=null? integer.valueOf(rowMap.get('@id')):0;
            data.month = rowMap.get('Month')!=null? string.valueOf(rowMap.get('Month')):'0';
            data.beverage = rowMap.get('Beverage')!=null? double.valueOf(rowMap.get('Beverage')):0;
            data.beveragePercent = rowMap.get('Beverage__')!=null? double.valueOf(rowMap.get('Beverage__')):0;
            data.coffeePercent = rowMap.get('Coffee__')!=null? double.valueOf(rowMap.get('Coffee__')):0;
            data.hotBeverage = rowMap.get('Hot_Beverage')!=null? double.valueOf(rowMap.get('Hot_Beverage')):0;
            data.kitchen = rowMap.get('Kitchen')!=null? double.valueOf(rowMap.get('Kitchen')):0;
            data.kitchenPercent = rowMap.get('Kitchen__')!=null? double.valueOf(rowMap.get('Kitchen__')):0;
            data.paper = rowMap.get('Paper_Goods')!=null? double.valueOf(rowMap.get('Paper_Goods')):0;
            data.paperPercent = rowMap.get('Paper__')!=null? double.valueOf(rowMap.get('Paper__')):0;
            data.snack = rowMap.get('Snack___Food')!=null? double.valueOf(rowMap.get('Snack___Food')):0;
            data.snackPercent = rowMap.get('Snack__')!=null? double.valueOf(rowMap.get('Snack__')):0;
            data.rentals = rowMap.get('Rentals_Svc')!=null? double.valueOf(rowMap.get('Rentals_Svc')):0;
            data.rentalsPercent = rowMap.get('Rentals_Svc__')!=null? double.valueOf(rowMap.get('Rentals_Svc__')):0;
            data.totals = rowMap.get('Totals')!=null? double.valueOf(rowMap.get('Totals')):0;
            data.totalsPercent = rowMap.get('Totals__')!=null? double.valueOf(rowMap.get('Totals__')):0;
            

            dataList.add(data);
 
        }
        return dataList;
    }
    public class RowData{
        @AuraEnabled
        public integer id; 
        @AuraEnabled
        public string month;
        @AuraEnabled
        public double beverage;
        @AuraEnabled
        public double beveragePercent;
        @AuraEnabled
        public double coffeePercent;
        @AuraEnabled
        public double hotBeverage;
        @AuraEnabled
        public double kitchen;
        @AuraEnabled
        public double kitchenPercent;
        @AuraEnabled
        public double paper;
        @AuraEnabled
        public double paperPercent;
        @AuraEnabled
        public double snack;
        @AuraEnabled
        public double snackPercent;
        @AuraEnabled
        public double rentals;
        @AuraEnabled
        public double rentalsPercent;
        @AuraEnabled
        public double totals;
        @AuraEnabled
        public double totalsPercent;
    }

}