/**
 * Created by StefanieHerbst on 6/2/2021.
 */

public with sharing class ApprovalRequestHandler extends TriggerHandlerExtension{

    List<ApprovalStep__c> approvalStepUpdateList = new List<ApprovalStep__c>();

    public ApprovalRequestHandler(){
        super();
    }

    public override void afterUpdate(SObject oldSObj,SObject newSObj){
        ApprovalRequest__c oldRequest = (ApprovalRequest__c) oldSObj;
        ApprovalRequest__c newRequest = (ApprovalRequest__c) newSObj;


        if(oldRequest.Decision__c == 'Not Decided' && newRequest.Decision__c != 'Not Decided'){
            schreibeApprovalEntscheidungAufApprovalStep(newRequest);
        }
    }

    public override void andFinally(){
        if(!approvalStepUpdateList.isEmpty()){
            update approvalStepUpdateList;
        }
    }

    public void initiiereApprovalProcesses(){
    }

    public void schreibeApprovalEntscheidungAufApprovalStep(ApprovalRequest__c request){
        ApprovalStep__c parentStep = new ApprovalStep__c();

        parentStep.Id = request.ApprovalStep__c;
        parentStep.Decision__c = request.Decision__c;

        approvalStepUpdateList.add(parentStep);
    }
}