public with sharing class WeatherController {
	private static String apiURL = 'http://api.openweathermap.org/data/2.5/';
	private static String apiKey = '7980c1422b2ead4fa6b2f868d9543899';
	private static String pathCurrentWeather = 'weather?appid='+apiKey+'&units=metric&q=';   
     
  	private static String getCalloutResponseContents(String url) {
		String result = null;
        	Http h = new Http();   
    		HttpRequest req = new HttpRequest();
    		req.setEndpoint(url);
    		req.setMethod('GET');


    		HttpResponse res = h.send(req);
				if(res.getStatusCode() == 200){
					result = res.getBody();
				}
    			return result;
  	}

	@AuraEnabled
	public static Object currentWeather(String city) {
       
       if(city == null){
        	List<mysc__Default_city__c> listdc = [SELECT mysc__Name__c FROM mysc__Default_city__c];        
        		if (listdc.size()>0){
            		String dc = String.valueOf(listdc[0].mysc__Name__c);
            		city = dc;         
        		}else
                	 {
                      
           				User us = [SELECT Id, City FROM User WHERE Id =: userInfo.getUserId()];
           				city = us.City;
        			 }
       }
        
		String weatherUrl = apiURL + pathCurrentWeather + city;
		System.debug('weatherUrl::' + weatherUrl);

		String result = getCalloutResponseContents(weatherUrl);
		System.debug('result::' + result);

		return (result == null)?null:getCalloutResponseContents(weatherUrl);
	}    
    
}