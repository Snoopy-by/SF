trigger triggerForNewCard on mysc__Expense_Card__c (before insert) {
 Date insDate = Trigger.new[0].mysc__CardDate__c;
    Integer year = insDate.year();
    Integer month = insDate.month();

    Date startDate = Date.newInstance(year, month, 1);
    Date finishDate = startDate.addMonths(1);
    finishDate = finishDate.addDays(-1);

    List<mysc__Monthly_Expense__c> monthlyExpInfo = [SELECT Id, mysc__MonthDate__c, mysc__Keeper__c FROM mysc__Monthly_Expense__c
                                          WHERE mysc__MonthDate__c
                                          >=:startDate AND mysc__MonthDate__c
                                          <=:finishDate AND mysc__Keeper__c =: Trigger.new[0].mysc__CardKeeper__c];

    if(monthlyExpInfo.size() == 0){
        mysc__Monthly_Expense__c newME = new mysc__Monthly_Expense__c();
        newME.mysc__Balance__c = 0;
        newME.mysc__Keeper__c = Trigger.new[0].mysc__CardKeeper__c; 
        newME.mysc__MonthDate__c = startDate;
        

        insert newME;

        List<mysc__Monthly_Expense__c> monthlyExpInfoNew = [SELECT Id, mysc__MonthDate__c, mysc__Keeper__c FROM mysc__Monthly_Expense__c
        WHERE mysc__MonthDate__c
        >=:startDate AND mysc__MonthDate__c
        <=:finishDate AND mysc__Keeper__c =: Trigger.new[0].mysc__CardKeeper__c];

        Trigger.new[0].mysc__MonthlyExpense__c = monthlyExpInfoNew[0].Id;
    }
    else{
        Trigger.new[0].mysc__MonthlyExpense__c = monthlyExpInfo[0].Id;
    }

}