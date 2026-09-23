public with sharing class ExchangeRateService {
    public static final string API_KEY = 'c638fa6f03baf9e060de2c99';
    public static final string BASE_URL = 'https://v6.exchangerate-api.com/v6/'+API_KEY+'/latest';
   
    
    public static void getExchangeRate(String baseCurrency) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(BASE_URL+baseCurrency.toUpperCase());
        req.setMethod('GET');
        req.setHeader('Accept', 'application/json');
        req.setTimeout(15000);

        Http http = new Http();
        HttpResponse res = http.send(req);
        if (res.getStatusCode() != 200) {
            throw new CalloutException('Failed to retrieve exchange rate: ' + res.getStatus());
        }
        
        System.debug(res.getBody());
    }
}