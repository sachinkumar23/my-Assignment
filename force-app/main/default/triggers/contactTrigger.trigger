trigger contactTrigger on Contact (before update) {
    new ContactTriggerHandler().run();
}