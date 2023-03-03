/**
 * Created by dudunato on 28/02/23.
 */

public with sharing class OpportunityDomain implements TriggerHandler {

    private final List<Opportunity> opportunities;

    public OpportunityDomain() {
    }

    private OpportunityDomain(List<Opportunity> opportunities) {
        this.opportunities = opportunities;
    }

    public TriggerHandler newInstance(List<SObject> newRecords) {
        return new OpportunityDomain((List<Opportunity>) newRecords);
    }

    public void beforeInsert() {
    }

    public void afterInsert() {
    }

    public void beforeUpdate(Map<Id, SObject> oldRecords) {
        setLastBonusReceivedAt(oldRecords);
    }

    public void afterUpdate(Map<Id, SObject> oldRecords) {
    }

    public void beforeDelete() {
    }

    public void afterDelete() {
    }

    private void setLastBonusReceivedAt(Map<Id, SObject> oldRecords) {

        for (Opportunity opp : this.opportunities) {
            Opportunity oldOpp = (Opportunity) oldRecords.get(opp.Id);

            if (oldOpp.Bonus__c != opp.Bonus__c) opp.LastBonusReceivedAt__c = Datetime.now();
        }

    }
}