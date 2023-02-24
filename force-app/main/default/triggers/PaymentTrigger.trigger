/**
 * Created by dudunato on 23/02/23.
 */

trigger PaymentTrigger on Payment__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {


    if (Trigger.isBefore && Trigger.isUpdate) {
        Map<Id, Payment__c> paymentMap =  Trigger.oldMap;

        Set<Id> oppIds = new Set<Id>();
        Map<Id, List<Payment__c>> paymentsByOppId = new Map<Id, List<Payment__c>>();
        for (Payment__c currentPayment : Trigger.new) {
            Payment__c oldPayment = paymentMap.get(currentPayment.Id);

            if (oldPayment.Opportunity__c == currentPayment.Opportunity__c) continue;
            oppIds.add(currentPayment.Opportunity__c);

            if (paymentsByOppId.containsKey(currentPayment.Opportunity__c)) {
                paymentsByOppId.get(currentPayment.Opportunity__c).add(currentPayment);
            } else {
                paymentsByOppId.put(currentPayment.Opportunity__c, new List<Payment__c>{currentPayment});
            }
        }

        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([
                SELECT Id , Bonus__c
                FROM Opportunity
                WHERE Id IN :oppIds
        ]);

        for (Id oppId : paymentsByOppId.keySet()) {
            Opportunity opp = oppMap.get(oppId);

            if (opp.Bonus__c == null) opp.Bonus__c = 0;

            List<Payment__c> payments = paymentsByOppId.get(oppId);
            for (Payment__c payment : payments) {
                opp.Bonus__c = (payment.PaymentAmount__c * 0.1) + opp.Bonus__c;
            }
        }

        update oppMap.values();
    }

}