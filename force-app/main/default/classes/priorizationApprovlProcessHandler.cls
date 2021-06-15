/**
 * Created by StefanieHerbst on 6/2/2021.
 */

public with sharing class priorizationApprovlProcessHandler extends TriggerHandlerExtension{

    public priorizationApprovlProcessHandler(){
        super();
    }

    public override void bulkAfter() {
        if(Trigger.isInsert) {
            erstelleApprovalStepsmitHilfeVonMatrix(Trigger.new);
        } else if (Trigger.isUpdate) {
            updateStatusAufOpportunity(Trigger.new);
            setztePriorizationApprovalProcessInaktiv(Trigger.new);
        }
    }

    private void erstelleApprovalStepsmitHilfeVonMatrix(List<priorizationApprovalProcess__c> listNew) {
        List<ApprovalStep__c> appStepList = new List <ApprovalStep__c>();

        for(priorizationApprovalProcess__c process : listNew){
            ApprovalStep__c appStep = new ApprovalStep__c();
            appStep.priorizationApprovalProcess__c = process.id;
            appStepList.add(appStep);
        }

        if (!appStepList.isEmpty() && appStepList != null) {
            insert appStepList;
        }
    }

    private void updateStatusAufOpportunity(List<priorizationApprovalProcess__c> listNew) {

    }

    private void setztePriorizationApprovalProcessInaktiv(List<priorizationApprovalProcess__c> listNew) {

    }
}