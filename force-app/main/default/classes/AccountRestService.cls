@RestResource(urlMapping='/account')
global with sharing class AccountRestService {
    
    @HttpPost
    global static String createAccount(String Name) {
        if(String.isBlank(Name)) {
            return 'Account name cannot be blank.';
        }

        Account acc = new Account(Name = Name);
        insert acc;
        return 'Account created successfully.';
    }
}