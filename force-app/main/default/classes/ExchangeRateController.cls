public with sharing class ExchangeRateController {
    
    @AuraEnabled
    public static Map<String,List<String>> getPickList(){
        
        List<Exchange_Rate__c> oldListExchangeRate = new List<Exchange_Rate__c>();
        List<Log__c> oldListLog = new List<Log__c>();
        oldListExchangeRate = [SELECT Id FROM Exchange_Rate__c];
        oldListLog = [SELECT Id FROM Log__c];
        delete oldListExchangeRate;
        delete oldListLog;
        
        List<String> optionList = new List<String>();
        Schema.DescribeFieldResult fieldRes = Exchange_Rate__c.Base_Currency__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldRes.getPicklistValues();
        
        String defInList = String.valueOf(fieldRes.getDefaultValue());
        
        for(Schema.PicklistEntry en: entries){
            optionList.add(en.getLabel());
        }
        
        Map<String,List<String>> res = new Map<String,List<String>>();
        res.put(defInList, optionList);
    
        return res;
    }
    
    
    public static API__mdt getApiConfiguration(){
        List <API__mdt> apiConfiguration = [SELECT API_URL__c FROM API__mdt];
        return apiConfiguration[0]; 
    }
    
    @AuraEnabled
    public static Exchange_Rate__c getExchangeByDate(String inputNameCur, String inpDate){
        
        Exchange_Rate__c res = new Exchange_Rate__c();
        Date currD = Date.valueOf(inpDate);
        List<Exchange_Rate__c> selectEx = [SELECT Id, Name, Base_Currency__c, Date__c, CAD__c, USD__c, EUR__c, GBP__c FROM Exchange_Rate__c
                                           WHERE Date__c =:currD AND Name =:inputNameCur];
        if(selectEx.size() == 0){
            res = helperExchageByDate(inputNameCur, inpDate);
        }
        else{
            res = selectEx[0];
        }
     
        return res;
    }
    
    public static Exchange_Rate__c helperExchageByDate(String inputNameCur, String inpDate){
        
        API__mdt apiString = getApiConfiguration();
        String settingUrl = apiString.API_URL__c;
        
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = settingUrl + 'latest?base=' + inputNameCur;
        
        
        if(inpDate != NULL){
            endpoint = settingUrl + inpDate + '?base=' + inputNameCur;
        }
        
        request.setEndPoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = httpProtocol.send(request);
        
        Map<String,Object> data = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
        String exBase = String.valueOf(data.get('base'));
        String exDate = String.valueOf(data.get('date'));
        
        Date mydate;
        if(exDate == inpDate){
            mydate = Date.valueOf(exDate);
        }
        else{
            mydate = Date.valueOf(inpDate);
        }
        
        
        Map<String,Object> exRates = (Map<String,Object>)data.get('rates');
 
        Log__c allInfoLog = new Log__c();
        allInfoLog.Status_Code__c = response.getStatus();
        allInfoLog.Response_Body__c = response.getBody();
        String logDate = String.valueOf(mydate);
        String nameLog = exBase + ' ' + logDate;
        allInfoLog.Name = nameLog;
        insert allInfoLog;
        
        Exchange_Rate__c allInfo = new Exchange_Rate__c();
        allInfo.Name = exBase;
        allInfo.Date__c = mydate;
        allInfo.Base_Currency__c = exBase;
        
        SObjectType objType = Schema.getGlobalDescribe().get('mysc__Exchange_Rate__c');
        Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();
        for(String key: exRates.keyset()){
            for(String field: fieldMap.keyset()){
                if(key == fieldMap.get(field).getDescribe().getLabel()){
                    String fieldName = fieldMap.get(field).getDescribe().getName();
                    allInfo.put(fieldName, exRates.get(key));
                    System.debug(allInfo);
                    
                }
            }
        }
        if(inputNameCur == 'EUR'){
            allInfo.EUR__c = 1;
        }
        
        List<Log__c> forLogField = [SELECT Id, Name FROM Log__c WHERE Name =:nameLog];
        allInfo.Log__c = forLogField[0].Id;
        
        insert allInfo;
        return allInfo;
    }
    
    
    public static Map<String, DescribeFieldREsult> getMapFieldTypeCurrency(){
        Map<String, DescribeFieldREsult> fieldsTypeCurrency = new Map<String, DescribeFieldREsult>();
        SObjectType exchangeRateObject = Schema.getGlobalDescribe().get('mysc__Exchange_Rate__c');
        Map<String, SObjectField> allFields = exchangeRateObject.getDescribe().fields.getMap();
        Set<String> newStringFields = allFields.keySet();
        	for(String str : newStringFields){
            	SObjectField oneField = allFields.get(str);
            	DescribeFieldREsult fieldsValue = oneField.getDescribe();
            		if (fieldsValue.getType() == Schema.DisplayType.CURRENCY){
                		fieldsTypeCurrency.put(fieldsValue.Name, fieldsValue);
            		} 
        	} 
        return fieldsTypeCurrency;
    }
    
    
    @AuraEnabled
    public static String getExchangeRatePeriod(String inputNameCur, Date mydateS, Date mydateF){
	    API__mdt apiString = getApiConfiguration();
        String settingUrl = apiString.API_URL__c;
        String s = String.valueOf(mydateS);
         String f = String.valueOf(mydateF);
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(settingUrl + 'history?start_at=' + s + '&end_at=' + f + '&base=' + inputNameCur);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        return response.getBody();
    }
     
    
    @AuraEnabled
    public static List<Exchange_Rate__c> getExchangeByPeriod(String inputNameCur, String startDate, String endDate){
        
        List<Exchange_Rate__c> result = new List<Exchange_Rate__c>();
        List<Exchange_Rate__c> forINS = new List<Exchange_Rate__c>();

            Date mydateS = Date.valueOf(startDate);
            Date mydateF = Date.valueOf(endDate);            
            Integer count = mydateS.daysBetween(mydateF);
            
            String currentDate = '';
            String ratePeriod = getExchangeRatePeriod(inputNameCur, mydateS, mydateF);
            Map<String, Object> newMap = (Map<String, Object>) JSON.deserializeUntyped(ratePeriod);
            Map<String, Object> rates = (Map<String,Object>) newMap.get('rates');
            
            List<Exchange_Rate__c> selectER = [SELECT Id, Name, Base_Currency__c, Date__c, CAD__c, USD__c, EUR__c, GBP__c 
                                               FROM Exchange_Rate__c
                                               WHERE Date__c >=:mydateS
                                               AND Date__c <=:mydateF
                                               AND Name =:inputNameCur];

            List<Log__c> listLogs = [SELECT Id, Name FROM Log__c];
        
            Map<String, DescribeFieldREsult> fieldsCurrency = getMapFieldTypeCurrency();
            
            
            for(Integer i=0; i< count+1; i++){
                currentDate = String.valueOf(Date.valueOf((mydateS.addDays(i))));
                Exchange_Rate__c res = new Exchange_Rate__c();
                
                Boolean sel = false;
                for(Exchange_Rate__c e: selectER){
                    if(e.Date__c == mydateS.addDays(i)){
                    sel = true;
                        res = e;
                    } 
                    
                }            
                if(sel == false){ 
                	if(String.valueOf(rates.get(currentDate)) != null){
                    	Map<String, Object> dateDay = (Map<String, Object>) rates.get(currentDate);
                    		
        				res.Name = inputNameCur;
        				res.Date__c = mydateS.addDays(i);
        				res.Base_Currency__c = inputNameCur;
                        String nameLog = inputNameCur + ' ' + currentDate;
                        for(Log__c a : listLogs){
                            if (a.Name == nameLog){
                                res.Log__c = a.Id;
                            }                                  
                        }
                        
            			for(String key: fieldsCurrency.keySet()){
                            if(fieldsCurrency.get(key).label != inputNameCur){
                    			res.put(fieldsCurrency.get(key).Name, Decimal.valueOf(String.valueOf(dateDay.get(fieldsCurrency.get(key).label))));                         			
            				}
                            else {res.put(fieldsCurrency.get(key).Name, 1);}
                        }
                        forINS.add(res);
                	}
                } 
                if(res.Date__c != null){result.add(res);}
              }
               
        if(forINS.size() != 0 && forINS != null){
            insert forINS;
        }
       
        return result;
    }    

    
    @AuraEnabled
    public static void initLogs(String inputNameCur, String startDate, String endDate){
        
        List<Log__c> logsINS = new List<Log__c>();
                   
            Date mydateS = Date.valueOf(startDate);
            Date mydateF = Date.valueOf(endDate);
            
            Integer count = mydateS.daysBetween(mydateF);
            String currentDate = '';
            
            List<Exchange_Rate__c> selectER = [SELECT Id, Name, Base_Currency__c, Date__c, CAD__c, USD__c, EUR__c, GBP__c 
                                               FROM Exchange_Rate__c
                                               WHERE Date__c >=:mydateS
                                               AND Date__c <=:mydateF
                                               AND Name =:inputNameCur];
            
            String ratePeriod = getExchangeRatePeriod(inputNameCur, mydateS, mydateF);
            Map<String, Object> newMap = (Map<String, Object>) JSON.deserializeUntyped(ratePeriod);           
                Map<String, Object> rates = (Map<String,Object>) newMap.get('rates');
            

            for(Integer i=0; i< count+1; i++){
                currentDate = String.valueOf(Date.valueOf((mydateS.addDays(i))));
                
               Boolean sel = false;
                for(Exchange_Rate__c e: selectER){
                
                    if(e.Date__c == mydateS.addDays(i)){               
                    sel = true;
                    }            
                }

                if(sel == false){
                
                
                if(String.valueOf(rates.get(currentDate)) != null){
                    Map<String, Object> dateDay = (Map<String, Object>) rates.get(currentDate);
                    List <String> logkey = new List <String>();
                 
                    
					for(String key : dateDay.keyset()){
					Logkey.add('"' + key + '":' + dateDay.get(key));
					}

                        Log__c allInfoLog = new Log__c();
        				allInfoLog.Status_Code__c = 'OK';
        				allInfoLog.Response_Body__c = String.valueOf(Logkey);
        				String logDate = currentDate;
        				String nameLog = inputNameCur + ' ' + currentDate;
        				allInfoLog.Name = nameLog;
        				logsINS.add(allInfoLog);
                }
           
            }
          
        }

        if(logsINS.size()!=0 && logsINS!=NULL){
            insert logsINS;
        } 
	}
}