/**
 * Created by dudunato on 23/02/23.
 */

trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerHandlerDispatcher.dispatch(OpportunityDomain.class);
}