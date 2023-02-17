/**
 * Created by dudunato on 14/02/23.
 */

({
    callGetContacts : function(component, event, helper) {
        helper.getContacts(component);
    },
    callEditContact : function(component, event, helper) {
        const contact = event.getSource().get('v.value');
        console.log('contact', JSON.stringify(contact));
        helper.incrementContact(component, contact);
    }
});