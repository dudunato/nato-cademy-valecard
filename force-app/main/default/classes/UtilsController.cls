public without sharing class UtilsController {

    @AuraEnabled
    public static List<SObject> listSObjects(String objectName, List<String> fields, String filters) {
        String soql = 'SELECT ' + String.join(fields, ',');
        soql += ' FROM ' + objectName;

        if (filters != null && filters != '') {
            soql += ' WHERE Id != NULL ' + filters;
        }

        System.debug('UtilsController => listSObjects(soql) = ' + soql);

        return Database.query(soql);
    }

}