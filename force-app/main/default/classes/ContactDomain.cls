/**
 * Created by dudunato on 02/03/23.
 */

public with sharing class ContactDomain implements TriggerHandler {

    private final List<Contact> contacts;

    public ContactDomain() {
    }

    private ContactDomain(List<Contact> contacts) {
        this.contacts = contacts;
    }

    public TriggerHandler newInstance(List<SObject> newRecords) {
        return new ContactDomain((List<Contact>) newRecords);
    }

    public void beforeInsert() {
    }

    public void afterInsert() {
    }

    public void beforeUpdate(Map<Id, SObject> oldRecords) {
    }

    public void afterUpdate(Map<Id, SObject> oldRecords) {
        enqueueCEPSearch(oldRecords);
    }

    public void beforeDelete() {
    }

    public void afterDelete() {
    }

    private void enqueueCEPSearch(Map<Id, SObject> oldRecords) {

        List<Contact> changedContacts = new List<Contact>();

        for (Contact contact : this.contacts) {
            Contact oldContact = (Contact) oldRecords.get(contact.Id);
            if (contact.MailingPostalCode == oldContact.MailingPostalCode) continue;
            changedContacts.add(contact);
        }

        if (changedContacts.isEmpty()) return;

        System.enqueueJob(new FetchCEPQueueable(changedContacts.deepClone(true)));
    }
}