/**
 * Created by StefanieHerbst on 6/2/2021.
 */

public with sharing class ApprovalStepHandler extends TriggerHandlerExtension{

    public ApprovalStepHandler(){
        super();
    }

   public override void bulkAfter() {
        if(Trigger.isInsert) {
            Map<string, id> userProcessIdMap = nehmeUserMitRichtigemUserAssignment(Trigger.new);
            erstelleApprovalRequest(userProcessIdMap);
        } else if (Trigger.isUpdate) {
        }
    }

    private Map<string, id> nehmeUserMitRichtigemUserAssignment(List<ApprovalStep__c> listNew) {

        Map<string, id> approverRoleProcessIdMap = new Map<string, id>();
        List<ApprovalStep__c> approvalStepsProcess = [
                select id, priorizationApprovalProcess__r.Opportunity__r.Account__c, priorizationApprovalProcess__r.Opportunity__r.Plant__c,
                        priorizationApprovalProcess__r.Opportunity__r.Lieferstandort__c, priorizationApprovalProcess__r.Opportunity__r.Product_Family__c
                from ApprovalStep__c where id in :listNew
        ];
    System.debug('approvalStepsProcess :' + approvalStepsProcess);
        for (ApprovalStep__c appStep : approvalStepsProcess) {

            List<MatrixToFindCommitee__mdt> neededUserRolesHelper = [
                    Select ApproverRole__c
                    from MatrixToFindCommitee__mdt
                    where Account__c = :appStep.priorizationApprovalProcess__r.opportunity__r.Account__c and
                    Lieferstandort__c = :appStep.priorizationApprovalProcess__r.opportunity__r.Lieferstandort__c and
                    Plant__c = :appStep.priorizationApprovalProcess__r.opportunity__r.plant__c
                    and Product_Family__c = :appStep.priorizationApprovalProcess__r.opportunity__r.Product_Family__c
            ];
        System.debug( 'neededUserRolesHelper : ' + neededUserRolesHelper);
            System.debug('Account__c : ' + appStep.priorizationApprovalProcess__r.opportunity__r.Account__c);

            System.debug( 'Lieferstandort__c : ' + appStep.priorizationApprovalProcess__r.opportunity__r.Lieferstandort__c);

            System.debug( 'plant__c  : ' + appStep.priorizationApprovalProcess__r.opportunity__r.plant__c );

            System.debug( 'Product_Family__c : ' + appStep.priorizationApprovalProcess__r.opportunity__r.Product_Family__c);

            System.debug( 'general : ' + [
                    Select ApproverRole__c, Plant__c, Lieferstandort__c, Product_Family__c, Account__c
                    from MatrixToFindCommitee__mdt] );


            for (MatrixToFindCommitee__mdt helper : neededUserRolesHelper) {
                approverRoleProcessIdMap.put(helper.ApproverRole__c, appStep.id);
            }
        }
        System.debug( 'approverRoleProcessIdMap : ' + approverRoleProcessIdMap);

        return approverRoleProcessIdMap;
    }

    private void erstelleApprovalRequest(Map<string, id> userProcessIdMap) {
        List<userAssignment__c> userToBeAssignedList = [Select Id, User__c, ApproverRole__c from userAssignment__c where ApproverRole__c in :userProcessIdMap.keySet()];
        System.debug( 'userToBeAssignedList : ' + userToBeAssignedList);

        for (userAssignment__c userToBeAssigned : userToBeAssignedList) {
            ApprovalRequest__c appReq = new ApprovalRequest__c();
            appReq.User__c = userToBeAssigned.User__c;
            appReq.ApprovalStep__c = userProcessIdMap.get(userToBeAssigned.ApproverRole__c);
            System.debug( 'appReq : ' + appReq);

            /* approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
             req.setObjectId(userProcessIdMap.get(userToBeAssigned.ApproverRole__c));
             req.setNextApproverIds(new Id[]{
                     userToBeAssigned.User__c
             });
             approval.process(req);*/
            lstInsert.add(appReq);
            System.debug(lstInsert);

        }
    }


    private void deaktiviereAlleZugehoerigenApprovalRequests() {

    }

    private void pruefeObAlleApprovalStepsGefuelltSind() {

    }

    private void updateStatusVonPriorizationApprovalProcess() {

    }

    public override void andFinally(){
        System.debug(lstInsert);
        if(!lstInsert.isEmpty()){
            insert lstInsert;
        }
    }
}