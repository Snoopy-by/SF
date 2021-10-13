@isTest 
private class ExpenseControllerTest {
    
    @isTest static void test() {
        Contact con = new Contact(LastName='Test',
        FirstName='Test', Email='mail@mail.com', Password__c='1234',
        Office__c='Office 1', Admin__c=false);
        insert con;
        List<Contact> listOfCon = [SELECT Id, Email, Password__c, Office__c, Admin__c FROM Contact];

        Date startDate = Date.newInstance(2020, 3, 1);
        Date currDate1 = Date.newInstance(2020, 3, 16);

        Monthly_Expense__c newME = new Monthly_Expense__c();
        newME.Balance__c = 100;
        newME.Keeper__c = listOfCon[0].Id;
        newME.MonthDate__c = startDate;
        insert newME;

        Expense_Card__c newCard1 = new Expense_Card__c();
        newCard1.Amount__c = 30;
        newCard1.CardDate__c = currDate1;
        newCard1.CardKeeper__c = listOfCon[0].Id;
        newCard1.Description__c = 'testing card';
        insert newCard1;

     

        List<Contact> allCon = ExpenseController.getLogin();
        System.assertEquals(1, allCon.size());

        List<ExpenseController> navInfo = ExpenseController.getNavigation(2020, listOfCon[0].Email);
        System.assertEquals(30, navInfo[2].amount);

        List<Expense_Card__c> getByDate = ExpenseController.getExpensesWithDate(currDate1, listOfCon[0].Email);
        System.assertEquals(30, getByDate[0].Amount__c);

        List<Integer> intList = new List<Integer>{3,2020};
        List<Expense_Card__c> getByMonth = ExpenseController.getExpensesWithMonth(intList, listOfCon[0].Email);
        System.assertEquals(1, getByMonth.size());

        Double balance = ExpenseController.getBalance(listOfCon[0].Email);
        System.assertEquals(70, balance);

        ExpenseController.updateMonthlyExp(10,'March','2020',listOfCon[0].Email);
        Double balanceInc = ExpenseController.getBalance(listOfCon[0].Email);
        System.assertEquals(80, balanceInc);

        Expense_Card__c newCard = new Expense_Card__c();
        newCard.Amount__c = 10;
        newCard.CardDate__c = currDate1;
        newCard.CardKeeper__c = listOfCon[0].Id;
        newCard.Description__c = 'test change and delete';
        insert newCard;
        List<Expense_Card__c> listForCng = new List<Expense_Card__c>();
        listForCng.add(newCard);
        ExpenseController.changeExpenseCard(listForCng);
        ExpenseController.deleteExpenseCard(newCard);
        Double balanceAfterDel = ExpenseController.getBalance(listOfCon[0].Email);
        System.assertEquals(80, balanceInc);

        String fakeDate = '2020-3-10';
        Double newAmount = Double.valueOf(10);
        ExpenseController.addNewExpense(listOfCon[0].Email, newAmount, fakeDate, 'new add');
        List<Double> adminBal = ExpenseController.getAdminBalance();
        System.assertEquals(70.0, adminBal[0]);

        List<String> offices = ExpenseController.getAdminOffices();
        System.assertEquals(3, offices.size());

        List<List<Double>> expenses = ExpenseController.getAdminExpenses(2020);
        System.debug(expenses);
        System.assertEquals(1, expenses.size());

        List<String> logInfo = ExpenseController.getLoginInfoForAdmin('Office 1');
        System.assertEquals('mail@mail.com', logInfo[0]);

        Contact admin = new Contact(LastName='Admin',
        FirstName='Boss', Email='boss@mail.com', Password__c='1337',
        Admin__c=true);
        insert admin;
       

        ExpenseController.updateMonthlyExp(10,'April','2020',listOfCon[0].Email);
        Double balanceIncWithNewME = ExpenseController.getBalance(listOfCon[0].Email);
        System.assertEquals(80, balanceIncWithNewME);

    }

}