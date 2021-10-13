global class ScheduleLog implements Schedulable, Database.AllowsCallouts {
    
    global void execute(SchedulableContext ctx) {
        
        List<String> optionList = new List<String>();
        Schema.DescribeFieldResult fieldRes = Exchange_Rate__c.Base_Currency__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldRes.getPicklistValues();      
        for(Schema.PicklistEntry en: entries){
            optionList.add(en.getLabel());
        }
        
        Date fnDate = Date.today();
        Date stDate;
        List<Exchange_Rate__c> exR = [SELECT Id, Date__c FROM Exchange_Rate__c 
                                      WHERE Date__c <: fnDate ORDER BY Date__c DESC LIMIT 1];
        
        if(exR.size() == 0){
            stDate = fnDate;
        }
        else{
            stDate = exR[0].Date__c;
        }
        
        getLogs(stDate, fnDate, optionList);
        
    }
    
    @Future(callout=true)
    public static void getLogs(Date mydateS, Date mydateF, List<String> optionList){
        
        List<Log__c> forIns = new List<Log__c>();
        Integer count = mydateS.daysBetween(mydateF);
        
        if(mydateS == mydateF){
            count = 1;
        }
        
        Date todays = Date.today();
        
        for(Integer i=0; i<optionList.size(); i++){
            Date curDT = mydateS;
            List<Exchange_Rate__c> selectEx = [SELECT Id, Name, Base_Currency__c, Date__c, CAD__c, USD__c, EUR__c, GBP__c 
                                               FROM Exchange_Rate__c
                                               WHERE Date__c =:todays AND Name =:optionList[i]];
            
            for(Integer j=0; j<count; j++){
                curDT = curDT.addDays(1);
                if(mydateS == mydateF){
                    curDT = curDT.addDays(-1);
                }
                
                if(curDT == todays && selectEx.size() != 0){
                    System.debug('This log insert already!');
                }
                else{
                    
                    API__mdt apiString = ExchangeRateController.getApiConfiguration();
                    String settingUrl = apiString.API_URL__c;
                    
                    
                    String s = String.valueOf(curDT);
                    String endpoint = settingUrl + s + '?base=' + optionList[i];
                    
                    Http httpProtocol = new Http();
                    HttpRequest request = new HttpRequest();
                    request.setEndPoint(endpoint);
                    request.setMethod('GET');
                    HttpResponse response = httpProtocol.send(request);
                    
                    Map<String,Object> data = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
                    String exBase = String.valueOf(data.get('base'));
                    String exDate = String.valueOf(data.get('date'));
                    
                    String realDate = String.valueOf(curDT);
                    
                    Date mydate;
                    if(exDate == realDate){
                        mydate = Date.valueOf(exDate);
                    }
                    else{
                        mydate = curDT;
                    }
                    
                    Log__c allInfoLog = new Log__c();
                    allInfoLog.Status_Code__c = response.getStatus();
                    allInfoLog.Response_Body__c = response.getBody();
                    String logDate = String.valueOf(mydate);
                    String nameLog = exBase + ' ' + logDate;
                    allInfoLog.Name = nameLog;
                    
                    forIns.add(allInfoLog);
                    
                }
            }
        }
        
        insert forIns;
    }
    
}