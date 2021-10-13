@isTest 
global class WeatherControllerTest implements HttpCalloutMock{
    
    global HTTPResponse respond(HTTPRequest request) {
        
        HttpResponse res = new HttpResponse();
        res.setBody('{"test":"test"}');
        res.setStatusCode(200);
        return res; 
    }   
    
    @isTest static void testCallout() {
   
    Test.setMock(HttpCalloutMock.class, new WeatherControllerTest());
        Object test1 = WeatherController.currentWeather('Boston_MA');
        System.debug(test1);
        System.assertNotEquals(test1, null);  
    }
}