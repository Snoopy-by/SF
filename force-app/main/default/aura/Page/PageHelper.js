({
	helperGetNavigationInfo: function(component){
        var action = component.get("c.getNavigation");
        var yearDate = component.get("v.nameYear");
        var emailName = component.get("v.login");

        action.setParams({
            year: yearDate,
            email: emailName
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var obj = response.getReturnValue();
                var totalAmount = 0;
                var totalIncome = 0;
                for(var i=0; i<obj.length; i++){
                    totalAmount += obj[i].amount;
                    totalIncome += obj[i].income;
                    if (obj[i].amount == 0){
                        obj[i].amount = null;
                    }else {          
                        obj[i].amount = obj[i].amount.toFixed(2);
                    }
                    if (obj[i].income == 0){
                        obj[i].income = null;
                    }else {
                        obj[i].income = obj[i].income.toFixed(2);
                    }                 		                    
                }
                component.set("v.totalAmount", totalAmount.toFixed(1));
                component.set("v.totalIncome", totalIncome.toFixed(1));
                component.set("v.navInfo", obj);
            } else {
                console.log("Failed with state: " + state);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    helperGetBalance: function(component) {
        var action = component.get("c.getBalance");
        var email = component.get("v.login");

        action.setParams({
            nameEmail: email
        });
   
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Balance", response.getReturnValue().toFixed(1));
            } else {
                console.log("Failed with state: " + state);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    helperYearClickAccordion: function(component) {
        var action = component.get("c.getExpensesWithMonth");
        var selected = component.get("v.selectedMonth");
        var monthDate = 0;

        if(selected == 'December'){monthDate = 12;}
        if(selected == 'November'){monthDate = 11;}
        if(selected == 'October'){monthDate = 10;}
        if(selected == 'September'){monthDate = 9;}
        if(selected == 'August'){monthDate = 8;}
        if(selected == 'July'){monthDate = 7;}
        if(selected == 'June'){monthDate = 6;}
        if(selected == 'May'){monthDate = 5;}
        if(selected == 'April'){monthDate = 4;}
        if(selected == 'March'){monthDate = 3;}
        if(selected == 'February'){monthDate = 2;}
        if(selected == 'January'){monthDate = 1;}
        
        var year = component.get("v.nameYear");
        var nameEmail = component.get("v.login");
        var allInfo = new Array();
        allInfo.push(monthDate);
        allInfo.push(year);

        action.setParams({
            info: allInfo,
            email: nameEmail
        });
      
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var obj = response.getReturnValue();
                var listOfDate = new Set();
                for (var i = 0; i < obj.length; i++) {
                    listOfDate.add(obj[i].mysc__CardDate__c);
                }
                var currLD = Array.from(listOfDate);
                component.set("v.curMonthDateList", currLD);
            } else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    
   initMonthes: function(component){
        var action = component.get("c.getExpensesWithMonth");
      
        var monthDate = component.get("v.nameMonth");
        var yearDate = component.get("v.nameYear");
        var nameEmail = component.get("v.login");
        var allInfo = new Array();
        allInfo.push(monthDate);
        allInfo.push(yearDate);

        action.setParams({
            info: allInfo,
            email: nameEmail
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var obj = response.getReturnValue();
                var listOfDate = new Set();
                for (var i = 0; i < obj.length; i++) {
                    listOfDate.add(obj[i].mysc__CardDate__c);
                }
                var currLD = Array.from(listOfDate);
                component.set("v.curMonthDateList", currLD);
            } else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    }

})