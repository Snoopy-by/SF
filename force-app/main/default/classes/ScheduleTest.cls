@isTest
private class ScheduleTest {
    
     
    @isTest static void test(){
        
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        Date newDate = Date.newInstance(2020, 3, 9);
        String nameLog = 'EUR 2020-08-19';
        
        Date nowDate = Date.today();
        String tdDate = String.valueOf(nowDate);
        String logRealName = 'EUR ' + tdDate;
        
        Log__c logFakeEUR = new Log__c(Status_Code__c='OK',
                                       Response_Body__c='Body',
                                       Name='EUR 2020-08-19');
        
        insert logFakeEUR;
        
        Log__c logRealEUR = new Log__c(Status_Code__c='OK',
                                       Response_Body__c='Body',
                                       Name=logRealName);
        insert logRealEUR;
        
        Test.startTest();
        
        String jobIdR = System.schedule('ScheduleRates',
                                        CRON_EXP,
                                        new ScheduleExchangeRate());
        
        String jobIdL = System.schedule('ScheduleLogs',
                                        CRON_EXP, 
                                        new ScheduleLog());
        
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('test');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        Test.setMock(HttpCalloutMock.class, mock); 
        
        Test.stopTest();
        
    }

}