({
	getCurrentWeather : function(component, helper, city) {
		var action = component.get('c.currentWeather');
		action.setParams({"city": city});
		action.setCallback(this, function(response) {
			var state = response.getState();

			if (state === "SUCCESS") {
				var result = response.getReturnValue();
				console.log(result);
				if(result != null){
					result = JSON.parse(result);
					if(result.cod == 200){
						component.set('v.weather', result);
					}
				}
			}else if (state === "INCOMPLETE") {
			}else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
							helper.message(component, 'Error!', 'error', errors[0].message);
					}
				} else {
					helper.message(component, 'Error!', 'error', 'Unknown Error');
				}
			}
		});
		$A.enqueueAction(action);
	},
	message: function(component, title, severity, message){
		component.set('v.message', message);
		component.set('v.title', title);
		component.set('v.severity', severity);
		var ele = component.find('message');
		$A.util.removeClass(ele, 'slds-hide');
		$A.util.addClass(ele, 'slds-show');
	}
})