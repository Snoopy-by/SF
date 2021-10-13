({
	doInit: function(component, event, helper) {
        helper.helperGetOffices(component);
        helper.helperGetBalance(component);
        helper.initYears(component);
        helper.initMonth(component);
        helper.initExpensesList(component);
        helper.initTotalFields(component);
    },

    changeYear: function(component, event, helper){
        var year = event.getParam("value");
        component.set("v.year", year);

        helper.initExpensesList(component);
        helper.initTotalFields(component);
    },

    toExpensesPage: function(component, event, helper){
        var office = event.getSource().get("v.value");
        var action = component.get("c.getLoginInfoForAdmin");

        action.setParams({
            officeCMP: office
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var obj = response.getReturnValue();
                  var navService = component.find("navService");
                        var pageReference = {
                            type: 'standard__component',
                            attributes: {
                                componentName: 'c__Page',
                            },
                            state: {
                                "c__Office": office,
                                "c__login" : obj[0],
                                "c__admin" : true
      
                            }
                        };
                        event.preventDefault();
                        navService.navigate(pageReference);
                		
            } else {
                console.log("Failed with state: " + state);
            }
        });

        $A.enqueueAction(action);       
    }

})