({
	doInit: function(component, event, helper) {
        var myPageRef = component.get("v.pageReference");
        component.set('v.login', myPageRef.state.c__login);
        component.set('v.Office', myPageRef.state.c__Office);
        var defDate = new Date();
        var month = defDate.getMonth();
        var year = defDate.getFullYear();
        var day = defDate.getDate();
        var curMonth = month + 1;
        var st = year + '-' + curMonth + '-' + day;
        component.set("v.defDate", st);
    },

    
    Cancel: function(component, event, helper) {
        var email = component.get("v.login");
        var navService = component.find("navService");
        var pageReference = {
            type: 'standard__component',
            attributes: {
                componentName: 'c__Page',
            },
            state: {
                "c__login" : email
                
            }
        };
        event.preventDefault();
        navService.navigate(pageReference);
    },

    newExpense: function(component, event, helper) {
        var email = component.get("v.login");
        var Office = component.get("v.Office");
        var amount = component.get("v.amount");
        var date = component.get("v.date");
        var descript = component.get("v.description");

        if(amount == null || descript == null){
            var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
               "title": "ERROR!",
                 type : 'error',
                "message": "Incorrect input!"
                });                        	
              resultsToast.fire();
        }else if(amount < 0.01 || amount > 100000){
           		var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
               	"title": "ERROR!",
                 type : 'error',
                "message": "The value must be between 0.01 and 100,000 !"
                });                        	
              resultsToast.fire();
    	}
        else{
            var action = component.get("c.addNewExpense");

            action.setParams({
                emailCMP: email,
                amountCMP: amount,
                dateCMP: date,
                decsCMP: descript
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
               					"c__login" : email,
                				"c__Office" : Office
           	 				}
        			};
        				event.preventDefault();
                    	var resultsToast = $A.get("e.force:showToast");
                		resultsToast.setParams({
                    		"title": "SUCCESS!",
                    		type : 'success',
                    		"message": " New expense card created! "
                				});                        	
                			resultsToast.fire();
        				navService.navigate(pageReference);
                }
                
            });

            
        $A.enqueueAction(action);
        }
    }
})