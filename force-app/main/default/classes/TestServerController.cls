/**
 * Created by dudunato on 14/02/23.
 */

public with sharing class TestServerController {

    @AuraEnabled
    public static List<Contact> getContacts() {
        return [
                SELECT Id, Name, Email, Increment__c, LastName
                FROM Contact
                ORDER BY Name ASC
        ];
    }

    @AuraEnabled
    public static void incrementContact(Id contactId, String lastName) {
        Contact contact = [
                SELECT Id, Increment__c
                FROM Contact
                WHERE Id = :contactId
        ];

        if (contact.Increment__c == null) contact.Increment__c = 0;

        contact.LastName = lastName;
        contact.Increment__c = contact.Increment__c + 1;
        update contact;
    }

}