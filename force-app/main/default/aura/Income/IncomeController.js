({
	saveClick: function(component, event, helper) {
        var myPageRef = component.get("v.pageReference");

        var income = component.get("v.income");
        if(income == null){
             var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
               "title": "ERROR!",
                 type : 'error',
                "message": "Incorrect input!"
                });                        	
              resultsToast.fire();
        }
        else if(income < 0.01 || income > 100000){
            var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
               "title": "ERROR!",
                 type : 'error',
                "message": "The value must be between 0.01 and 100,000 !"
                });                        	
              resultsToast.fire();
    	}
        else{
            var action = component.get("c.updateMonthlyExp");

      			action.setParams({
        			income: income,
        			month: myPageRef.state.c__month,
        			year: myPageRef.state.c__year,
        			login: myPageRef.state.c__login
      				});
            
            action.setCallback(this, function (response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    var result = response.getReturnValue();
                    var navService = component.find("navService");
        			var pageReference = {
            			type: 'standard__component',
            			attributes: {
                		componentName: 'c__Page',
            			},
            				state: {
               					"c__login" : myPageRef.state.c__login,
                				"c__Office" : myPageRef.state.c__Office
           	 				}
        			};
        				event.preventDefault();	
                    	var resultsToast = $A.get("e.force:showToast");
                		resultsToast.setParams({
                    		"title": "SUCCESS!",
                    		type : 'success',
                    		"message": " Balance has been successfully replenished! "
                				});                        	
                			resultsToast.fire();
                    
          				navService.navigate(pageReference);
                }
                
            });
            

        component.set('v.income', null); 
        $A.enqueueAction(action);
        }

    },
    
    
    Cancel: function(component, event, helper) {
        var myPageRef = component.get("v.pageReference");
        var navService = component.find("navService");
        var pageReference = {
            type: 'standard__component',
            attributes: {
                componentName: 'c__city1',
            },
            state: {
                "c__login" : myPageRef.state.c__login,
                "c__Office" : myPageRef.state.c__Office
            }
        };
        event.preventDefault();
        navService.navigate(pageReference);
        component.set('v.income', null);
    }
})