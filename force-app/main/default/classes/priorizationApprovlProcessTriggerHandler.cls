/**
 * Created by StefanieHerbst on 6/2/2021.
 */

public with sharing class priorizationApprovlProcessTriggerHandler {

    private void beforeInsert(List<priorizationApprovalProcess__c> listNew) {
        erstelleApprovalStepsmitHilfeVonMatrix(listNew);
    }

    private void beforeUpdate(List<priorizationApprovalProcess__c> listNew) {
        updateStatusAufOpportunity(listNew);
        setztePriorizationApprovalProcessInaktiv(listNew);
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