trigger CaseTrigger on Case (after update) {

    if (Trigger.isAfter){
        if (Trigger.isUpdate){
            FieldAuditService.auditFields(Trigger.new, Trigger.oldMap);
        }
    }
}