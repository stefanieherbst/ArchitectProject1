/**
 * Created by StefanieHerbst on 6/2/2021.
 */

public with sharing class ApprovalRequestHandler extends TriggerHandlerExtension{

    List<ApprovalStep__c> approvalStepUpdateList = new List<ApprovalStep__c>();

    public ApprovalRequestHandler(){
        super();
    }

    public override void bulkAfter() {
        System.debug('approvalRequestHandlerInsert1');
        if (Trigger.isInsert) {
            System.debug('approvalRequestHandlerInsert');
            initiiereApprovalProcesses(Trigger.new);
        } else if (Trigger.isUpdate){
        //schreibeEntscheidungAufApprovalRequest();
        //schreibeApprovalEntscheidungAufApprovalStep();
    }
    }

  /*  private void initiiereApprovalProcesses(){



        if(oldRequest.Decision__c == 'Not Decided' && newRequest.Decision__c != 'Not Decided'){
            schreibeApprovalEntscheidungAufApprovalStep(newRequest);
        }
    }*/

    public override void andFinally(){
        if(!approvalStepUpdateList.isEmpty()){
            update approvalStepUpdateList;
        }
    }

    public void initiiereApprovalProcesses(List<ApprovalRequest__c> newList){
        System.debug('approverprocess : ' + newList);
        for (ApprovalRequest__c appReq : newList) {
            approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setObjectId(appReq.id);
            req.setNextApproverIds(new Id[]{
                    appReq.Approver__c
            });
            System.debug('req: ' + req);
            Approval.ProcessResult result = Approval.process(req);
            System.debug('result: ' + result);        }
    }

    public void schreibeApprovalEntscheidungAufApprovalStep(ApprovalRequest__c request){
        ApprovalStep__c parentStep = new ApprovalStep__c();

        parentStep.Id = request.ApprovalStep__c;
        parentStep.Decision__c = request.Decision__c;

        approvalStepUpdateList.add(parentStep);
    }
}