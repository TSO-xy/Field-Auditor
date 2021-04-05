public class FieldAuditService {

    public static void auditFields(List<SObject> newList, Map<Id, SObject> oldMap)  {
        List<Field_History__c> fhToInsert = new List<Field_History__c>();
        List<String> fieldsToTrack = new List<String>();
        String objType = newList[0].getSObjectType().getDescribe().getName();
        Map<String, Object_Field_Audit__mdt> mdtMap = Object_Field_Audit__mdt.getAll();
        
        for(Object_Field_Audit__mdt mdtRec : mdtMap.values()){
            if (mdtRec.Object_Name__c == objType){
                fieldsToTrack.add(mdtRec.Field_Name__c);
            }
        }
        
        if (!fieldsToTrack.isEmpty()){
            for (SObject obj : newList){
                for(String field : fieldsToTrack){
                    String newFieldVal = (String)obj.get(field);
                    String oldFieldVal = (String)oldMap.get(obj.Id).get(field);
                    if (newFieldVal != oldFieldVal){
                        Field_History__c fh = new Field_History__c(
                            Previous_Value__c = oldFieldVal,
                            New_Value__c = newFieldVal,
                            User__c = UserInfo.getName(),
                            Date_Modified__c =   DateTime.now().format(),
                            Object_Name__c = objType,
                            Field_Name__c = field,
                            Object_Id__c = obj.Id
                        );
                        fhToInsert.add(fh);
                    }
                }
            }
        }

        if (!fhToInsert.isEmpty()){
            try {
                insert fhToInsert;
            } catch (Exception e) {
                System.debug('Problem recording field history: ' + e.getMessage());
            }
        }
    }
}
        