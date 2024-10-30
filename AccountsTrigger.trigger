trigger AccountsTrigger on Account (before update, after update) {
    Map<Id, Account> oldMap = Trigger.oldMap;
    List<Account> newList = Trigger.new;

    List<Account> listToUpdate = new List<Account>();
    List<Id> listIds = new List<Id>();
    for(Account acc : Trigger.New){
        if(acc.MissionStatus__c == 'canceled' && acc.MissionStatus__c != oldMap.get(acc.Id).MissionStatus__c){
            listToUpdate.add(acc);
            listIds.add(acc.Id);
        }
    }
    if(!listIds.isEmpty()){
        if(Trigger.isBefore)
            Accounts.updateMissionDate(listToUpdate);
        if(Trigger.isAfter)
            Accounts.updateRelatedContacts(listIds);
        listIds.clear();
        listToUpdate.clear();
    }
}
