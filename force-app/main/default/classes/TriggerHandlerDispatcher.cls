/**
 * Created by dudunato on 28/02/23.
 */

public with sharing class TriggerHandlerDispatcher {

    public static void dispatch(Type triggerDomain) {
        if (!Trigger.isExecuting) throw new TriggerException('You can\'t use this if not in a trigger context');
        if (triggerDomain == null) throw new TriggerException('Trigger domain is null');

        TriggerHandler handler = null;

        try {

            handler = (TriggerHandler) triggerDomain.newInstance();

            handler = handler.newInstance(Trigger.new);

            switch on (Trigger.operationType) {

                when BEFORE_INSERT {
                    handler.beforeInsert();
                }

                WHEN BEFORE_UPDATE {
                    handler.beforeUpdate(Trigger.oldMap);
                }

                WHEN BEFORE_DELETE {
                    handler.beforeDelete();
                }

                WHEN AFTER_INSERT {
                    handler.afterInsert();
                }

                WHEN AFTER_UPDATE {
                    handler.afterUpdate(Trigger.oldMap);
                }

                WHEN AFTER_DELETE {
                    handler.afterDelete();
                }

                when else {
                    throw new TriggerException('TriggerHandlerDispatcher error: ' + String.valueOf(Trigger.operationType) + ' not implemented');
                }

            }

        } catch (Exception e) {
            throw new TriggerException('TriggerHandlerDispatcher error: ' + e.getMessage());
        }



    }


    public class TriggerException extends Exception {}
}