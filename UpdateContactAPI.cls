public with sharing class UpdateContactAPI {    
    public final static String PATH = 'https://fxyozmgb2xs5iogcheotxi6hoa0jdhiz.lambda-url.eu-central-1.on.aws';

    public static void sendContacts(String body){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(PATH);
        req.setBody(body);
        req.setMethod('PATCH');
        req.setHeader('Authorization', 'salesforceAuthToken');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        HttpResponse rsp;
        try{
            rsp = http.send(req);
            System.debug('rsp = ' + rsp);
            if(rsp.getStatusCode() != 200){
                throw new CalloutException(rsp.getBody());
            }
        }catch (Exception ex) {
            system.debug('### ex' + ex);
        }
        return;
    }
}
