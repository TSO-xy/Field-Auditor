@isTest
public with sharing class FieldAuditService_UT {
    
    @testSetup
    static void insertData(){
        insert new Case(
            Description = 'Test Description 1'
        );
    }
    static testMethod void testAudit(){
        Case c = [SELECT id, Description FROM Case][0];
        c.Description = 'Updated Description';
        Test.startTest();
        update c;
        Test.stopTest();

        Field_History__c fh = [SELECT id, User__c, Previous_Value__c, New_Value__c FROM Field_History__c WHERE Object_Id__c = :c.Id];

        System.assertEquals(fh.Previous_Value__c, 'Test Description 1');
        System.assertEquals(fh.New_Value__c, 'Updated Description');
        System.assertEquals(fh.User__c, UserInfo.getName());
    }
}
