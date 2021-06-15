/**
 * Created by StefanieHerbst on 6/2/2021.
 */

public with sharing class ApprovalStepHandler extends TriggerHandlerExtension{

    public ApprovalStepHandler(){
        super();
    }

    private void beforeInsert(List<ApprovalStep__c> listNew) {
        Map<id, id> userProcessIdMap = nehmeUserMitRichtigemUserAssignment(listNew);
        erstelleApprovalRequest(userProcessIdMap);
    }

    private Map<id, id> nehmeUserMitRichtigemUserAssignment(List<ApprovalStep__c> listNew) {

        Map<id, id> userProcessIdMap = new Map<id, id>();
        List<priorizationApprovalProcess__c> prioApprProcess = [
                select id, Opportunity__r.Account__c, Opportunity__r.Plant__c,
                        Opportunity__r.Lieferstandort__c, Opportunity__r.Product_Family__c
                from priorizationApprovalProcess__c
        ]; //where id list von approvalste.priorizationApprovalProzess in ..... fehlt noch

        for (priorizationApprovalProcess__c process : prioApprProcess) {

            List<MatrixToFindCommitee__mdt> neededUserRolesHelper = [
                    Select ApproverRole__c
                    from MatrixToFindCommitee__mdt
                    where Account__c = :process.opportunity__r.Account__c and
                    Lieferstandort__c = :process.opportunity__r.Lieferstandort__c and
                    Plant__c = :process.opportunity__r.plant__c and Product_Family__c = :process.opportunity__r.Product_Family__c
            ];

            for (MatrixToFindCommitee__mdt helper : neededUserRolesHelper) {
                userProcessIdMap.put(helper.ApproverRole__c, process.id);
            }
        }

        return userProcessIdMap;
    }

    private void erstelleApprovalRequest(Map<id, id> userProcessIdMap) {
        List<userAssignment__c> userToBeAssignedList = [Select Id, User__c from userAssignment__c where ApproverRole__c in :userProcessIdMap.keySet()];

        for (userAssignment__c userToBeAssigned : userToBeAssignedList) {
            approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setObjectId(userProcessIdMap.get(userToBeAssigned.user__C));
            req.setNextApproverIds(new Id[]{
                    userToBeAssigned.User__c
            });
        }
    }


    private void deaktiviereAlleZugehoerigenApprovalRequests() {

    }

    private void pruefeObAlleApprovalStepsGefuelltSind() {

    }

    private void updateStatusVonPriorizationApprovalProcess() {

    }
}