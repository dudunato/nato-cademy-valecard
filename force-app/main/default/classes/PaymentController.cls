/**
 * Created by dudunato on 16/02/23.
 */

public with sharing class PaymentController {

    @AuraEnabled
    public static List<Payment__c> getPayments() {
        return [
                SELECT Id, Name, PaymentAmount__c, PaymentType__c, Contact__r.Name
                FROM Payment__c
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


}