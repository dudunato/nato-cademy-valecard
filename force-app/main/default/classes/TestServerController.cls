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

    @AuraEnabled
    public static Map<String, Object> getCEP(String cepNumber) {
       return new CepAPI().fetch(cepNumber);
    }

    @AuraEnabled
    public static void saveContact(Contact contact) {
        upsert contact;
    }

    @AuraEnabled
    public static List<Map<String, String>> getObjects() {
        List<SObjectType> sObjectTypes = Schema.getGlobalDescribe().values();

        List<Map<String, String>> objectNames = new List<Map<String, String>>();
        for (SObjectType sObjectType : sObjectTypes) {
            DescribeSObjectResult sObjectResult = sObjectType.getDescribe();
            objectNames.add(
                    new Map<String, String> {
                            'label' => sObjectResult.getLabel() + ' (' + sObjectResult.getName() + ')',
                            'value' => sObjectResult.getName()
                    }
            );
        }

        return objectNames;
    }

    @AuraEnabled
    public static List<Map<String, String>> getFields(String objectName) {
        Map<String, SObjectField> sObjectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();

        List<Map<String, String>> fieldsData = new List<Map<String, String>>();

        for (SObjectField sObjectField : sObjectFields.values()) {
            DescribeFieldResult fieldResult = sObjectField.getDescribe();
            fieldsData.add(
                    new Map<String, String> {
                            'label' => fieldResult.getLabel(),
                            'apiName' => fieldResult.getName(),
                            'type' => fieldResult.getType().name()
                    }
            );
        }

        return fieldsData;
    }


}