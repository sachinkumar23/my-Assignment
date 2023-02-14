public inherited sharing class ContactTriggerHandler extends TriggerHandler {
public override void beforeUpdate(){
    UpdateContactPhone.updateContactPhoneDetails((Map<Id, Contact>) Trigger.newMap, (Map<Id, Contact>) Trigger.oldMap);
} 
}