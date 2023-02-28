/**
 * Created by dudunato on 28/02/23.
 */

public interface TriggerHandler {

    TriggerHandler newInstance(List<SObject> newRecords);

    void beforeInsert();

    void afterInsert();

    void beforeUpdate(Map<Id, SObject> oldRecords);

    void afterUpdate(Map<Id, SObject> oldRecords);

    void beforeDelete();

    void afterDelete();

}