public with sharing class SAP_Callout {
    public static List<Object> get(string path){
        String jsonData = callout(path, 'GET', null);
        return jsonToList(jsonData);
    }

    public static List<Object> post(string path, string body){
        String jsonData = callout(path, 'POST', body);
        return jsonToList(jsonData);
    }

    public static void postXML(string path, string body){
        String XMLData = callout(path, 'POST', body);
        
    } 

    private static String callout(String path, String method, String body){
        system.debug('This is the SAP Callout');
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:SAP/' + path);
        req.setMethod(method);
        req.setTimeout(60000);
        if(body != null) {
            req.setBody(body);
        }
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        return res.getBody();
    }

    private static List<Object> jsonToList(String jsonData){
        Map<String,Object> dataMap = (Map<String,Object>)JSON.deserializeUntyped(jsonData);
        Map<String,Object> responseMap = (Map<String,Object>)dataMap.get('response');
        Map<String,Object> payload = (Map<String,Object>)responseMap.get('payload');
        Map<String,Object> querydata = (Map<String,Object>)payload.get('querydata');
        System.debug(querydata.get('columns'));
        Map<String,Object> data = (Map<String,Object>)querydata.get('data');

        List<Object> rows = (List<Object>)data.get('row');
        return rows;
    }
}