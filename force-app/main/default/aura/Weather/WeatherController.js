({
	getCurrentWeather : function(component, event, helper) {
		var city = component.find('city').get('v.value');
		helper.getCurrentWeather(component, helper,city);
	}
 
})