public with sharing class Accounts {
    //Inner Class to create the json body
    public class contactInfos{
        public String id;
        public Boolean is_active;

        contactInfos(String id, Boolean is_active){
            this.id = id;
            this.is_active = is_active;
        }
    }

    public static void updateMissionDate(List<Account> listAcc){
        for(Account a : listAcc){
            a.MissionCanceledDate__c = Date.today();
        }
    }

    @future(callout=true)
    public static void updateRelatedContacts(List<Id> listIds) {
        //Retrieve all contacts relations from the updated Accounts
        List<AccountContactRelation> listAcr = [SELECT Id, AccountMissionStatus__c, ContactId FROM AccountContactRelation WHERE AccountId IN :listIds];

        //Retrieve all contact Ids that are related to the updated Accounts
        List<Id> listContactIds = new List<Id>();
        for(AccountContactRelation acr : listAcr){
            listContactIds.add(acr.ContactId);
        }  
        //Retrieve all relations of the contacts
        listAcr = [SELECT Id, AccountMissionStatus__c, ContactId FROM AccountContactRelation WHERE ContactId IN :listContactIds];      
        
        //Loop through each contact relation
        List<Id> listNoUpdate = new List<Id>();
        for(AccountContactRelation acr : listAcr){
            if(acr.AccountMissionStatus__c == 'active'){
                listNoUpdate.add(acr.ContactId); //If one of the contact's Account is active, exclude it from the contacts to be updated
            }
        }        

        // Retrieve all contacts to be updated
        // Update them and create the json body for the api call
        List<contactInfos> bodyContacts = new List<contactInfos>();
        List<Contact> listContacts = [SELECT Id, IsActive__c FROM Contact WHERE Id IN :listContactIds AND Id NOT IN :listNoUpdate];
        for(Contact c : listContacts){
            c.IsActive__c = false;
            bodyContacts.add(new contactInfos(c.Id, c.IsActive__c));
        }
        if(!bodyContacts.isEmpty()){
            String body = JSON.serialize(bodyContacts);
            UpdateContactAPI.sendContacts(body);
            update listContacts;
        }
    }
}