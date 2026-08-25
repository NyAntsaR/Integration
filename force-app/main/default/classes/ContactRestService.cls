@RestResource(urlMapping='/contacts')
global with sharing class ContactRestService {
   
    @HttpPut
    global static String updateOrCreateContact(String FirstName, String LastName, String Email, String Phone, String Title) {
        List<Contact> existingContacts = [
            SELECT Id, FirstName, LastName, Email, Phone, Title 
            FROM Contact 
            WHERE Email = :Email LIMIT 1];

        if(!existingContacts.isEmpty()) {
            Contact contact = existingContacts[0];
            contact.FirstName = FirstName;
            contact.LastName = LastName;
            contact.Phone = Phone;
            contact.Title = Title;
            update contact;
            return 'Contact updated successfully. Contact Id:' + contact.Id;
        } else {
            Contact contact = new Contact(FirstName = FirstName, LastName = LastName, Email = Email, Phone = Phone, Title = Title);
            insert contact;
            return 'Contact created successfully. Contact Id:' + contact.Id;
        }
    }
}