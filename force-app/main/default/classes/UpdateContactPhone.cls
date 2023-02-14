/**
*@description: To populate the Account's Phone on respective related Contact record if the Preferred Communication Method has been changed
*@author: Sachin Kumar
*@createddate: 2023/02/07
*/
public inherited sharing class UpdateContactPhone {
    /**
    *@description To update Contact's Phone with the related Account's Phone
    *@param Contact new & old values passed by contactTrigger or respective handler class - Trigger.newMap & Trigger.oldMap
    *@return List of updated Contact or emtplyContactList if there is no update
    */
    public static List<Contact> updateContactPhoneDetails(Map<Id, Contact> newContactMap, Map<Id, Contact> oldContactMap){
        List<Contact> emptyContactList = new List<Contact>();
        if(newContactMap == null || newContactMap.isEmpty()){
            return emptyContactList;
        }
        Map<Id, Contact> filteredNewContactMap = filterNewContactMap(newContactMap, oldContactMap);
        if(filteredNewContactMap.isEmpty()){
            return emptyContactList;
        }
        Map<Id, Account> accountMap = getAccountDetails(filteredNewContactMap);
        List<Contact> updatedContactList = new List<Contact>();
        for(Contact contactRecord : filteredNewContactMap.values()){
            contactRecord.Phone = accountMap.get(contactRecord.AccountId).Phone;
            updatedContactList.add(contactRecord);
        }
        return updatedContactList;
    }
    /**
    *@description To create the Account Map for unique AccountIds included in filtered newContactMap
    *@param Contact's new filteredContactMap
    *@return AccountMap for the unique AccountIds included in filtered newContactMap
    */
    public static Map<Id, Account> getAccountDetails(Map<Id, Contact> filteredContactMap){
        Set<Id> accountIds = new Set<Id>();
        for(Contact conRec : filteredContactMap.values()){
            accountIds.add(conRec.AccountId);
        }
        return new Map<Id, Account>([SELECT Id, Phone FROM Account WHERE Id IN : accountIds]);
    }
    /**
    *@description To filter the newContactMap based on the condition
    *@param Contact new & old values passed by contactTrigger or respective handler class - Trigger.newMap & Trigger.oldMap
    *@return filteredNewContactMap - filtered Contact new map
    */
    public static Map<Id, Contact> filterNewContactMap(Map<Id, Contact> newContactMap, Map<Id, Contact> oldContactMap){
        Map<Id, Contact> filteredNewContactMap = new Map<Id, Contact>();
        for(Contact contactRecord : newContactMap.values()){
            if((contactRecord.Preferred_Communication_Method__c != oldContactMap.get(contactRecord.id).Preferred_Communication_Method__c) && String.isNotBlank(contactRecord.AccountId)){
                filteredNewContactMap.put(contactRecord.id, contactRecord);
            }
        }
        return filteredNewContactMap;
    }
}