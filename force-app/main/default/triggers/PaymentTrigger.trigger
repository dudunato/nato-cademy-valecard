/**
 * Created by dudunato on 23/02/23.
 */

trigger PaymentTrigger on Payment__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerHandlerDispatcher.dispatch(PaymentDomain.class);
}