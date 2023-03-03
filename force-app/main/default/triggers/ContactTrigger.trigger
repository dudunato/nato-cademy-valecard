/**
 * Created by dudunato on 02/03/23.
 */

trigger ContactTrigger on Contact (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerHandlerDispatcher.dispatch(ContactDomain.class);
}