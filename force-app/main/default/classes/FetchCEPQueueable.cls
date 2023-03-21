/**
 * Created by dudunato on 02/03/23.
 */

public with sharing class FetchCEPQueueable implements Queueable, Database.AllowsCallouts{

    private final List<Contact> currentContacts;

    public FetchCEPQueueable(List<Contact> currentContacts) {
        this.currentContacts = currentContacts;
    }

    public void execute(QueueableContext context) {
        callFetchCEP();
    }

    public void callFetchCEP(){
        CepAPI cepAPI = new CepAPI();

        for (Contact contact : currentContacts) {
            Map<String, Object> cepData = cepAPI.fetch(contact.MailingPostalCode);
            System.debug('Current CEP' + contact.MailingPostalCode);
            contact.MailingStreet = (String) cepData.get('address') + ', ' + (String) cepData.get('district');
            contact.MailingCity = (String) cepData.get('city');
            contact.MailingState = (String) cepData.get('state');
            contact.MailingPostalCode = (String) cepData.get('code');
            contact.MailingCountry = 'Brazil';
        }

        update currentContacts;
    }

}