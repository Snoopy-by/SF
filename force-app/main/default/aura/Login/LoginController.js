({
	getInfo : function(component, event, helper) {
        var action = component.get("c.getLogin");
        var login = component.get("v.login");
        var password = component.get("v.password");
        

        action.setCallback(this, function (response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var object = response.getReturnValue();
               	var isCorrect = false;
                for(var i=0; i<object.length; i++){
                    if(object[i].Email == login && object[i].mysc__Password__c == password){
                        isCorrect = true;
                           if (object[i].mysc__Admin__c == true){
                            	var navService = component.find("navService");
                        		var pageReference = {
                            		type: 'standard__component',
                            			attributes: {
                                			componentName: 'c__Admin',
                            			},
                            			state: {
                               	 			"c__login" : object[i].Email
                            			}
                        			};
                        			event.preventDefault();
                        			navService.navigate(pageReference);
                           }else{
                               
                        	var navService = component.find("navService");
                        	var pageReference = {
                            type: 'standard__component',
                            	attributes: {
                                	componentName: 'c__Page',
                            	},
                            	state: {
                                	"c__Office": object[i].mysc__Office__c,
                                	"c__login" : object[i].Email
                            	}		
                        	};
                        	event.preventDefault();
                        	navService.navigate(pageReference);
                           }
                    } 
                }
                if (isCorrect == false){
                        var resultsToast = $A.get("e.force:showToast");
                		resultsToast.setParams({
                    		"title": "ERROR!",
                    		type : 'error',
                    		"message": "Check your login and password !"
                				});                        	
                			resultsToast.fire();
                    }
                    
            }

        });
        $A.enqueueAction(action);                 
    }
})