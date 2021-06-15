trigger OpportunityTrigger on Opportunity (before update, before insert, before delete, after update, after insert, after delete){
    TriggerFactory.executeTriggerHandlers(Account.SObjectType);
  }