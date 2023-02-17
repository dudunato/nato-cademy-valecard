/**
 * Created by dudunato on 14/02/23.
 */

({
    getContacts: function (component) {

        const getContact = component.get('c.getContacts');

        getContact.setCallback(this, (response) => {
            const state = response.getState();

            if (state === 'SUCCESS') {
                const contacts = response.getReturnValue();
                console.log('contacts', JSON.stringify(contacts));
                component.set('v.contacts', contacts);
            }
        });

        $A.enqueueAction(getContact);
    },
    incrementContact: function(component, contact) {

        const incrementContact = component.get('c.incrementContact');

        incrementContact.setParams({
            contactId: contact.Id,
            lastName: contact.LastName
        });

        const self = this;
        incrementContact.setCallback(this, (response) => {
            const state = response.getState();

            if (state === 'SUCCESS') {
                self.getContacts(component);
            }

        });

        $A.enqueueAction(incrementContact);
    }
});