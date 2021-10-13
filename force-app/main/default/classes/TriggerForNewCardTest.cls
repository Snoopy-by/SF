@isTest 
private class TriggerForNewCardTest {
     @isTest static void testNewExpenseCard(){
        Contact con = new Contact(LastName='Test', FirstName='Test', Email='mail@mail.com', Password__c='1234');
        insert con;
        List<Contact> listOfCon = [SELECT Id FROM Contact];

        Date startDate = Date.newInstance(2020, 3, 1);
        Date currDate1 = Date.newInstance(2020, 3, 16);
        Date currDate = Date.newInstance(2020, 4, 16);

        Expense_Card__c newCard = new Expense_Card__c();
        newCard.Amount__c = 25;
        newCard.CardDate__c = currDate;
        newCard.CardKeeper__c = listOfCon[0].Id;
        newCard.Description__c = 'testing card';
        insert newCard;

        Monthly_Expense__c newME = new Monthly_Expense__c();
        newME.Balance__c = 100;
        newME.Keeper__c = listOfCon[0].Id;
        newME.MonthDate__c = startDate;
        insert newME;

        Expense_Card__c newCard1 = new Expense_Card__c();
        newCard1.Amount__c = 30;
        newCard1.CardDate__c = currDate1;
        newCard1.CardKeeper__c = listOfCon[0].Id;
        newCard1.Description__c = 'testing cards';
        insert newCard1;

        List<Expense_Card__c> listOfCards = [SELECT Id FROM Expense_Card__c];
        System.assertEquals(2, listOfCards.size());
    }

}