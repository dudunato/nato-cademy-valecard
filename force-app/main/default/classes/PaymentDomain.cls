/**
 * Created by dudunato on 28/02/23.
 */

public with sharing class PaymentDomain implements TriggerHandler {

    private final List<Payment__c> payments;

    public PaymentDomain() {
    }

    private PaymentDomain(List<Payment__c> payments) {
        this.payments = payments;
    }

    public TriggerHandler newInstance(List<SObject> newRecords) {
        return new PaymentDomain((List<Payment__c>) newRecords);
    }

    public void beforeInsert() {
    }

    public void afterInsert() {
    }

    public void beforeUpdate(Map<Id, SObject> oldRecords) {
        calculateBonusOnOpportunity(oldRecords);
    }

    public void afterUpdate(Map<Id, SObject> oldRecords) {
    }

    public void beforeDelete() {
    }

    public void afterDelete() {

    }

    private void calculateBonusOnOpportunity(Map<Id, SObject> oldMap) {

        Map<Id, SObject> paymentMap = oldMap;

        Set<Id> oppIds = new Set<Id>();
        Map<Id, List<Payment__c>> paymentsByOppId = new Map<Id, List<Payment__c>>();
        for (Payment__c currentPayment : this.payments) {
            Payment__c oldPayment = (Payment__c) paymentMap.get(currentPayment.Id);

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