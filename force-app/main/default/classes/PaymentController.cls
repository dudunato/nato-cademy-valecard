/**
 * Created by dudunato on 16/02/23.
 */

public with sharing class PaymentController {

    @AuraEnabled
    public static List<Payment__c> getPayments() {
        return [
                SELECT Id, Name, PaymentAmount__c, PaymentType__c, Contact__r.Name,
                        Opportunity__r.Name, Opportunity__r.Bonus__c
                FROM Payment__c
                ORDER BY CreatedDate ASC
        ];
    }

    @AuraEnabled
    public static List<Opportunity> getOpportunitiesBySearchTerm(String searchTerm) {
        searchTerm = '%' + searchTerm + '%';

        return [
                SELECT Id, Name, Amount, StageName, CloseDate, Account.Name
                FROM Opportunity
                WHERE Name LIKE  :searchTerm
                ORDER BY CreatedDate ASC
        ];
    }

    @AuraEnabled
    public static void savePayment(Payment__c payment) {
        upsert payment;
    }

    @AuraEnabled
    public static void deletePayment(Id paymentId) {
        delete new Payment__c(Id = paymentId);
    }

    public class PaymentException extends Exception {}
}