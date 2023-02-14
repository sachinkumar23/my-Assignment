@isTest
public class ContactTriggerHandlerTest {
    public static List<Contact> makeData(Integer noOfAcc, Integer noOfConPerAcc){
        List<Account> accountList = new List<Account>();
        for(Integer i=0; i<noOfAcc; i++){
            accountList.add(new Account(Name = 'Test Account '+i, Phone = '12345'));
        }
        insert accountList;
        List<Contact> contactList = new List<Contact>();
        for(Integer j=0; j<noOfAcc; j++){
            Account acc = accountList[j];
            for(Integer k=0; k<noOfConPerAcc; k++){
                contactList.add(new Contact(LastName = 'Test Contact '+k, Preferred_Communication_Method__c = 'Email', Phone = '1234567890', AccountId = acc.Id));
            }
        }
        insert contactList;
        return contactList;
    }
    @isTest
    public static void updateContactPhonePosotiveTest(){
        //Load Test Data
        List<Contact> accWithConList = makeData(2, 1);
        List<Contact> conListToUpdate = new List<Contact>();
        for(Contact con : accWithConList){
            con.Preferred_Communication_Method__c = 'Phone';
            conListToUpdate.add(con);
        }

        //Perform Test
        Test.startTest();
        update conListToUpdate;
        Test.stopTest();

        //Validate Results
        List<Contact> resultConList = [SELECT Id, Phone FROM Contact];
        System.assertEquals('12345', resultConList[0].Phone);
} 
    @isTest
    public static void updateContactPhoneEmptyValueTest(){
        //Load Test Data
        Map<Id, Contact> emptyMap = new Map<Id, Contact>();//Create an Empty Map

        //Perform Test
        Test.startTest();
        UpdateContactPhone.updateContactPhoneDetails(emptyMap, emptyMap);
        Test.stopTest();

        //Validate Results
        List<Contact> resultConList = [SELECT Id, Phone FROM Contact];
        System.assert(resultConList.isEmpty());
} 
    @isTest
    public static void updateContactPhoneNegativeTest(){
        //Load Test Data
        List<Contact> accWithConList = makeData(2, 1);
        List<Contact> conListToUpdate = new List<Contact>();
        for(Contact con : accWithConList){
        conListToUpdate.add(con);
        }

        //Perform Test
        Test.startTest();
        update conListToUpdate;
        Test.stopTest();

        //Validate Results
        List<Contact> resultConList = [SELECT Id, Phone FROM Contact];
        System.assertEquals('1234567890', resultConList[0].Phone);
} 
@isTest
public static void updateContactPhoneBulkTest(){
    //Load Test Data
    List<Contact> accWithConList = makeData(300, 10);
    List<Contact> conListToUpdate = new List<Contact>();
    for(Contact con : accWithConList){
        con.Preferred_Communication_Method__c = 'Phone';
        conListToUpdate.add(con);
    }
    //Perform Test
    Test.startTest();
    update conListToUpdate;
    Test.stopTest();
    //Validate Results
    List<Contact> resultConList = [SELECT Id, Phone FROM Contact];
    System.assertEquals('12345', resultConList[100].Phone);
} 
}