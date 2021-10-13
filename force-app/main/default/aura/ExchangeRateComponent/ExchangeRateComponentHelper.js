({
	message: function(component, title, severity, message){
		component.set('v.message', message);
		component.set('v.title', title);
		component.set('v.severity', severity);
		var ele = component.find('message');
		$A.util.removeClass(ele, 'slds-hide');
		$A.util.addClass(ele, 'slds-show');
	}
})