/**
 * Created by dudunato on 21/03/23.
 */

@IsTest
private class TestServerControllerTest {

    @TestSetup
    static void setup() {
    }

    @IsTest
    static void testGetContactsSuccess() {

        insert new Contact(
                FirstName = 'Test',
                LastName = 'Test',
                Email = 'test@example.com'
        );

        Assert.isTrue(TestServerController.getContacts().size() == 1);
    }

    @IsTest
    static void testGetContactsEmpty() {
        Assert.isFalse(TestServerController.getContacts().size() == 1);
    }

    @IsTest
    static void testIncrementContact() {

        Contact contact = new Contact(
                FirstName = 'Test',
                LastName = 'Test',
                Email = 'test@example.com'
        );
        insert contact;

        TestServerController.incrementContact(contact.Id, 'DUDU');

        Contact contactUpdated = [
                SELECT Id, FirstName, LastName, Email, Increment__c
                FROM Contact
                WHERE Id = :contact.Id
        ];

        Assert.areEqual(1, contactUpdated.Increment__c);
        Assert.areEqual('DUDU', contactUpdated.LastName);
    }

}