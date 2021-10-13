public with sharing class ExpenseController {

    
    @AuraEnabled public String monthName = '';
    @AuraEnabled public Double amount = 0;
    @AuraEnabled public Double income = 0;


    ExpenseController (String name, Double amoun, Double incom){
        
        this.monthName = name;
        this.amount = amoun;
        this.income = incom;
       
    }
    
    @AuraEnabled
    public static List <Contact> getLogin (){
       List <Contact> infoLogs = [SELECT Email, Password__c, Admin__c, Office__c FROM Contact];
       return infoLogs;
    }
    
    @AuraEnabled
    public static List<ExpenseController> getNavigation(Integer year, String email){

        Contact currUser = [SELECT Id, Email FROM Contact WHERE Email =: email LIMIT 1];
        List<ExpenseController> result = new List<ExpenseController>();
        List<String> nameOfMonth = new List<String>{'January','February','March','April','May','June',
            'July','August','September','October','November','December'};       
        Date finishDate;
        Date startDate;

        for(Integer i=1; i<13; i++){
            Double amounts = 0;
            Double incomes = 0;
            startDate = Date.newInstance(year, i, 1);
            finishDate = startDate.addMonths(1);
            finishDate = finishDate.addDays(-1);

            List<Expense_Card__c> allInfo = [
                SELECT Id, Amount__c,
                CardDate__c, CardKeeper__c FROM Expense_Card__c WHERE CardDate__c
                >=:startDate AND CardDate__c
                <=:finishDate AND CardKeeper__c =: currUser.Id ORDER BY CardDate__c ASC
            ];
            for(Integer j=0; j<allInfo.size(); j++){
                amounts = amounts + allInfo[j].Amount__c;
            }

            List<Monthly_Expense__c> balanseInfo = [SELECT Id, Balance__c, MonthDate__c, Keeper__c 
                                                         FROM Monthly_Expense__c
                                              WHERE MonthDate__c
                                              >=:startDate AND MonthDate__c
                                              <=:finishDate AND Keeper__c =: currUser.Id];
          
          
            if(balanseInfo.size() == 0){
                incomes = 0;
            }
            else{
                incomes = balanseInfo[0].Balance__c;
            }
            
            ExpenseController item = new ExpenseController(nameOfMonth[i-1],amounts,incomes);
            result.add(item);
        }
    
      
        return result;
    }

    @AuraEnabled
    public static List<Expense_Card__c> getExpensesWithDate(Date selectDate, String emailCMP) {

        Contact currUser = [SELECT Id, Email FROM Contact WHERE Email =: emailCMP LIMIT 1];

        List<Expense_Card__c> allInfo = [
            SELECT Id, Description__c, Amount__c,
            CardDate__c, CardKeeper__c FROM Expense_Card__c WHERE CardDate__c =:selectDate AND CardKeeper__c =: currUser.Id
        ];
        
        return allInfo;
    }
    
    @AuraEnabled
    public static List<Expense_Card__c> getExpensesWithMonth(List<Integer> info, String email) {

        Contact currUser = [SELECT Id, Email FROM Contact WHERE Email =: email LIMIT 1];

        Date startDate = Date.newInstance(info[1], info[0], 1);
        Date finishDate = startDate.addMonths(1);
        finishDate = finishDate.addDays(-1);
        
        List<Expense_Card__c> allInfo = [
            SELECT Id, Description__c, Amount__c,
            CardDate__c, CardKeeper__c FROM Expense_Card__c WHERE CardDate__c
            >=:startDate AND CardDate__c
            <=:finishDate AND CardKeeper__c =: currUser.Id ORDER BY CardDate__c ASC
        ];
        
        return allInfo;
    }
    
    @AuraEnabled
    public static Double getBalance(String nameEmail) {
        Double balance = 0;

        Contact currUser = [SELECT Id, Email FROM Contact WHERE Email =: nameEmail LIMIT 1];

        List<Monthly_Expense__c> allMonthExp = [SELECT Id, Reminder__c, Keeper__c FROM Monthly_Expense__c WHERE Keeper__c =: currUser.Id];
        for(Integer i=0; i<allMonthExp.size(); i++){
            balance = balance + allMonthExp[i].Reminder__c;
        }

        return balance;
    }
    @AuraEnabled
    public static Expense_Card__c addNewExpense(String emailCMP, Double amountCMP, String dateCMP, String decsCMP) {

        Expense_Card__c newCard = new Expense_Card__c();

        String delimetr = '-';
        String[] str = dateCMP.split(delimetr);
        Integer year = Integer.valueOf(str[0]);
        Integer month = Integer.valueOf(str[1]);
        Integer day = Integer.valueOf(str[2]);
        Date currDate = Date.newInstance(year, month, day);

        Contact currUser = [SELECT Id, Email FROM Contact WHERE Email =: emailCMP LIMIT 1];

        newCard.Amount__c = amountCMP;
        newCard.CardDate__c = currDate;
        newCard.CardKeeper__c = currUser.Id;
        newCard.Description__c = decsCMP;
        

        insert newCard;
        return newCard;
    }
        @AuraEnabled
    public static void updateMonthlyExp(Double income, String month, String year, String login) {
   

        Integer currMonth = 0;
        if(month == 'December'){currMonth = 12;}
        if(month == 'November'){currMonth = 11;}
        if(month == 'October'){currMonth = 10;}
        if(month == 'September'){currMonth = 9;}
        if(month == 'August'){currMonth = 8;}
        if(month == 'July'){currMonth = 7;}
        if(month == 'June'){currMonth = 6;}
        if(month == 'May'){currMonth = 5;}
        if(month == 'April'){currMonth = 4;}
        if(month == 'March'){currMonth = 3;}
        if(month == 'February'){currMonth = 2;}
        if(month == 'January'){currMonth = 1;}

        Integer currYear = Integer.valueOf(year);
        Date startDate = Date.newInstance(currYear, currMonth, 1);
        Date finishDate = startDate.addMonths(1);
        finishDate = finishDate.addDays(-1);
      

        Contact currUser = [SELECT Id, Email FROM Contact WHERE Email =: login LIMIT 1];

        List<Monthly_Expense__c> balanseInfo = [SELECT Id, Balance__c, MonthDate__c, Keeper__c FROM Monthly_Expense__c
                                              WHERE MonthDate__c
                                              >=:startDate AND MonthDate__c
                                              <=:finishDate AND Keeper__c =: currUser.Id];
    

        if(balanseInfo.size() == 0){
            Monthly_Expense__c newME = new Monthly_Expense__c();
            newME.Balance__c = income;
            newME.Keeper__c = currUser.Id;
            newME.MonthDate__c = startDate;
            

            insert newME;
        }
        else{
            if(balanseInfo[0].Balance__c == null){balanseInfo[0].Balance__c = 0;}
            balanseInfo[0].Balance__c = balanseInfo[0].Balance__c + income;
            
            update balanseInfo;
        }
    }

    @AuraEnabled
    public static void deleteExpenseCard(Expense_Card__c cardForDel) {
        delete cardForDel;
    }
    
    @AuraEnabled
    public static void changeExpenseCard(List<Expense_Card__c> cardForCng) {
        update cardForCng;
    }
    
    @AuraEnabled
    public static List<Double> getAdminBalance() {
        List<Double> balances = new List<Double>();
        Boolean isntAdmin = false;

        List<Contact> listUsers = [SELECT Id, Office__c, Admin__c, Email FROM Contact
        WHERE Admin__c =: isntAdmin AND Office__c != null ORDER BY Office__c ASC];

        for(Integer i=0; i<listUsers.size(); i++){
            Double forAdd = getBalance(listUsers[i].Email);
            balances.add(forAdd);
        }

        return balances;
    }

    @AuraEnabled
    public static List<String> getAdminOffices() {
        List<String> offices = new List<String>();

        Schema.DescribeFieldResult fieldRes = Contact.Office__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldRes.getPicklistValues();
        
        for(Schema.PicklistEntry en: entries){
            offices.add(en.getLabel());
        }

        return offices;
    }

    @AuraEnabled
    public static List<List<Double>> getAdminExpenses(Integer yearFromCmp) {
        List<List<Double>> expenses = new List<List<Double>>();
      
        List<Contact> listUsers = [SELECT Id, Office__c, Admin__c, Email FROM Contact
        WHERE Admin__c =: false AND Office__c != null ORDER BY Office__c ASC];

        for(Integer i=0; i<listUsers.size(); i++){
            List<ExpenseController> forInfo = getNavigation(yearFromCmp, listUsers[i].Email);
            List<Double> listOfAmounts = new List<Double>();
            for(Integer j=0; j<forInfo.size(); j++){
                listOfAmounts.add(forInfo[j].amount);
                
            }
            expenses.add(listOfAmounts);
        }

        return expenses;
    }
    
    @AuraEnabled
    public static List<String> getLoginInfoForAdmin(String officeCMP) {
        List<String> logInfo = new List<String>();

        Contact currUser = [SELECT Id, Email, Password__c, Office__c  FROM Contact WHERE Office__c =: officeCMP LIMIT 1];
        logInfo.add(currUser.Email);
        logInfo.add(currUser.Password__c);
        return logInfo;
    }

}