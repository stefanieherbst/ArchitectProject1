/**
 * Created by StefanieHerbst on 6/2/2021.
 */

public with sharing class OpportunityTriggerHandler {

    private void beforeInsert(Map<id, Opportunity> oppMapOld, Map<id, Opportunity> oppMapNew) {
        priorizationApprovalProcess(null, oppMapNew);
    }

    private void beforeUpdate(Map<id, Opportunity> oppMapOld, Map<id, Opportunity> oppMapNew) {
        priorizationApprovalProcess(oppMapOld, oppMapNew);
    }


    private void priorizationApprovalProcess(Map<id, Opportunity> oppMapOld, Map<id, Opportunity> oppMapNew) {
        List<Opportunity> oppListWithNewPriorization = checkIfPrioIsDefaultOrHasChanged(oppMapOld, oppMapNew);
        List<Opportunity> oppListWithNoActivePrio = pruefeObWeiterePriorizationApprovalProcessAktiv(oppListWithNewPriorization);
        erstellePriorizationApprovalProcess(oppListWithNoActivePrio);
    }

    private List<Opportunity> checkIfPrioIsDefaultOrHasChanged(Map<id, Opportunity> oppMapOld, Map<id, Opportunity> oppMapNew) {
        List<Opportunity> oppList = new List <Opportunity>();
        for (Opportunity opp : oppMapNew.values()) {
            if (opp.priorization__c == 'high' && (oppMapOld.keySet().isEmpty() || opp.priorization__c != oppMapOld.get(opp.id).priorization__c)) {
                oppList.add(opp);
            }
        }
        return oppList;
    }

    private List<Opportunity> pruefeObWeiterePriorizationApprovalProcessAktiv(List<Opportunity> oppList) {
        List<Opportunity> hasNoActiveApprovalProcess = new List<Opportunity>();
        if (!oppList.isEmpty() && oppList != null) {
            List<priorizationApprovalProcess__c> activePrioAprovalProcessList = [Select Opportunity__c from priorizationApprovalProcess__c where Opportunity__c in :oppList and status__c = 'in process'];
            Set<id> prioAppProcIds = new Set<id>();
            for (priorizationApprovalProcess__c prioAppProc : activePrioAprovalProcessList) {
                prioAppProcIds.add(prioAppProc.Opportunity__c);
            }
            for (Opportunity opp : oppList) {
                if (!prioAppProcIds.contains(opp.id)) {
                    hasNoActiveApprovalProcess.add(opp);
                }
            }
        }
        return hasNoActiveApprovalProcess;
    }

    private void erstellePriorizationApprovalProcess(List<Opportunity> oppList) {
        if (!oppList.isEmpty() && oppList != null) {
            List <priorizationApprovalProcess__c> approvalProsessList = new List<priorizationApprovalProcess__c>();
            for (Opportunity opp : oppList) {
                priorizationApprovalProcess__c prioApprovalProcess = new priorizationApprovalProcess__c();
                approvalProsessList.add(prioApprovalProcess);
            }
            insert approvalProsessList;
        }
    }
}