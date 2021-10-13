@isTest
private class ExchangeRateControllerTest {

        @isTest static void test1(){
        
        Test.startTest();
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('test');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        Test.setMock(HttpCalloutMock.class, mock); 
        
        Test.stopTest();
        
        String inputName = 'EUR';
        Date inputDate = Date.newInstance(2020, 8, 19);
        String stDate = String.valueOf(inputDate);
        Exchange_Rate__c testEx = ExchangeRateController.getExchangeByDate(inputName, stDate);
        List<Exchange_Rate__c> afterEx = [SELECT Id FROM Exchange_Rate__c];
        Boolean empt = true;
        if(afterEx.size() != 0 ){
            empt = false;
        }
        System.assertEquals(false, empt);
        
        Map<String,List<String>> testPL = ExchangeRateController.getPickList();
        System.assertEquals(false, testPL.isEmpty());
    }
    
     @isTest static void test3(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExchangeRateControllerAllMock());
        List<Exchange_Rate__c> testPeriod = ExchangeRateController.getExchangeByPeriod('USD', '2020-01-06', '2020-01-16');
        
        System.assert(testPeriod!=null);
       
        Test.stopTest();
    } 
        @isTest static void test4(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExchangeRateControllerAllMock());
        ExchangeRateController.initLogs('USD', '2020-01-06', '2020-01-16');
        Test.stopTest();
    }
        
    @isTest static void test5(){
        
        Test.startTest();
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('test');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.stopTest();
        
        String inputName = 'EUR';
        String fDate = '2020-08-19';
        Date nowDate = Date.today();
        String tdDate = String.valueOf(nowDate);
        
        ExchangeRateController.initLogs(inputName, fDate, tdDate);
        List<Log__c> listLog = [SELECT Id FROM Log__c];
        System.assertEquals(0, listLog.size());
    }
    
    @isTest static void test6(){
        
        Test.startTest();
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('test');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.stopTest();
        
        String inputName = 'EUR';
        String fDate = '2020-08-19';
        Date nowDate = Date.today();
        String tdDate = String.valueOf(nowDate);
        
        ExchangeRateController.initLogs(inputName, tdDate, fDate);
        List<Log__c> listLog = [SELECT Id FROM Log__c];
        System.assertEquals(0, listLog.size());
    }
    
    @isTest static void test(){
        
        Test.startTest();
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('test');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.stopTest();
        
        String inputName = 'EUR';
        String inputDate = '2020-08-19';
        
        ExchangeRateController.initLogs(inputName, inputDate, inputDate);
        List<Log__c> listLog = [SELECT Id FROM Log__c];
        System.assertEquals(0, listLog.size());
    }
    
    @isTest static void test7(){
        
        Date inputDate = Date.newInstance(2020, 8, 19);
        String stDate = String.valueOf(inputDate);
        
        Test.startTest();
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('test');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.stopTest();
        
        String inputName = 'EUR';
        String fDate = NULL;
        Date nowDate = Date.today();
        String tdDate = String.valueOf(nowDate);
        
        ExchangeRateController.initLogs(inputName, tdDate, stDate);
        List<Log__c> listLog = [SELECT Id FROM Log__c];
        System.assertEquals(0, listLog.size());
    }
    
    @isTest static void test8(){
        
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
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('test');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.stopTest();
        
        String inputName = 'EUR';
        String inputDate = '2020-08-19';
        
        List<Exchange_Rate__c> testPeriod = ExchangeRateController.getExchangeByPeriod(inputName, inputDate, inputDate);
        List<Exchange_Rate__c> afterEx = [SELECT Id FROM Exchange_Rate__c];
        Boolean empt = true;
        if(afterEx.size() != 0 ){
            empt = false;
        }
        System.assertEquals(true, empt);
        
    }
    
    @isTest static void test9(){
        
        Date nowDate = Date.today();
        String tdDate = String.valueOf(nowDate);
        String logRealName = 'EUR ' + tdDate;
        
        Log__c logFakeEUR = new Log__c(Status_Code__c='OK',
                                       Response_Body__c='Body',
                                       Name='EUR 2020-03-09');
        
        insert logFakeEUR;
        
        Log__c logRealEUR = new Log__c(Status_Code__c='OK',
                                       Response_Body__c='Body',
                                       Name=logRealName);
        insert logRealEUR;
        
        Test.startTest();
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('test');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.stopTest();
        
        String inputName = 'EUR';
        String inputDate = '2020-08-19';
        
        List<Exchange_Rate__c> testPeriod = ExchangeRateController.getExchangeByPeriod(inputName, inputDate, tdDate);
        List<Exchange_Rate__c> afterEx = [SELECT Id FROM Exchange_Rate__c];
        Boolean empt = false;
        if(afterEx.size() != 0 ){
            empt = true;
        }
        System.assertEquals(false, empt);
        
    }
    
    @isTest static void test0(){
        
        Date nowDate = Date.today();
        String tdDate = String.valueOf(nowDate);
        String logRealName = 'EUR ' + tdDate;
        
        Log__c logFakeEUR = new Log__c(Status_Code__c='OK',
                                       Response_Body__c='Body',
                                       Name='EUR 2020-03-09');
        
        insert logFakeEUR;
        
        Log__c logRealEUR = new Log__c(Status_Code__c='OK',
                                       Response_Body__c='Body',
                                       Name=logRealName);
        insert logRealEUR;
        
        Test.startTest();
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('test');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.stopTest();
        
        String inputName = 'EUR';
        String inputDate = '2020-08-19';
        
        List<Exchange_Rate__c> testPeriod = ExchangeRateController.getExchangeByPeriod(inputName, tdDate, inputDate);
        List<Exchange_Rate__c> afterEx = [SELECT Id FROM Exchange_Rate__c];
        Boolean empt = true;
        if(afterEx.size() != 0 ){
            empt = false;
        }
        System.assertEquals(true, empt);
        
    }
}