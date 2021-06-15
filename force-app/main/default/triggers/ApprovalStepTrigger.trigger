trigger ApprovalStepTrigger on ApprovalStep__c (before update, before insert, before delete, after update, after insert, after delete){
    TriggerFactory.executeTriggerHandlers(ApprovalStep__c.SObjectType);
  }