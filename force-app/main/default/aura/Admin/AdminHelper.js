({
	helperGetBalance: function(component) {
        var action = component.get("c.getAdminBalance");

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var obj = response.getReturnValue();
                for (var i=0; i<obj.length; i++){
                    if (obj[i] != 0){
                        obj[i] = obj[i].toFixed(1);
                    }
                }
                component.set("v.balances", obj);
            } else {
                console.log("Failed with state: " + state);
            }
        });
        
        $A.enqueueAction(action);
    },

    helperGetOffices: function(component) {
        var action = component.get("c.getAdminOffices");

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.offices", response.getReturnValue());
            } else {
                console.log("Failed with state: " + state);
            }
        });
        
        $A.enqueueAction(action);
    },

    initYears: function(component){
        var now = new Date();
        var nowYear = now.getFullYear();
        component.set("v.year", nowYear);

        var listYear = new Array();
        listYear.push(nowYear - 3);
        listYear.push(nowYear - 2);
        listYear.push(nowYear - 1);
        listYear.push(nowYear);
        component.set("v.listYears", listYear);
    },

    initMonth: function(component){
        var arrayOfMonth = [
            "January",
            "February",
            "March",
            "April",
            "May",
            "June",
            "July",
            "August",
            "September",
            "October",
            "November",
            "December"
        ];
        component.set("v.months", arrayOfMonth);
    },

    initExpensesList: function(component){

        var action = component.get("c.getAdminExpenses");
        var year = component.get("v.year");
        var listOfExpenses = [];

        action.setParams({
            yearFromCmp: year
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var obj = response.getReturnValue();
                for(var i=0; i<obj.length; i++){
                    var list = obj[i]; 
                    for (var j=0; j<list.length; j++){
                        if (list[j] != 0){
                            list[j] = list[j].toFixed(2);
                        }

                    }
                    listOfExpenses.push({value: obj[i]});
                }
                component.set("v.expensesList", listOfExpenses);
            } else {
                console.log("Failed with state: " + state);
            }
        });
        
        $A.enqueueAction(action);
    },

    initTotalFields: function(component){
        var action = component.get("c.getAdminExpenses");
        var year = component.get("v.year");
        var totalAmount = [];
        var monthlyAvg = [];
        var listOfSumm = [0,0,0,0,0,0,0,0,0,0,0,0];
        var totalSumm = 0;

        action.setParams({
            yearFromCmp: year
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var obj = response.getReturnValue();
                for(var i=0; i<obj.length; i++){
                    var count = 0;
                    var summAmount = 0;
                    var list = obj[i];
                    for(var j=0; j<list.length; j++){
                        if(list[j] != 0){
                   
                            count++;
                        }
                        summAmount = summAmount + list[j];
                        listOfSumm[j] = listOfSumm[j] + list[j];
                        listOfSumm[j] = Math.floor(listOfSumm[j] * 100) / 100;
             
                    }
                    if(count == 0){
                        monthlyAvg.push(0);
                    }
                    else{
                        var avg = summAmount/count;
                        avg = Math.floor(avg * 100) / 100;
                        monthlyAvg.push(avg.toFixed(2));
                    }
                    totalAmount.push(summAmount.toFixed(1));
                }
                for(var k=0; k<listOfSumm.length; k++){
                    totalSumm = totalSumm + listOfSumm[k];
                    if (listOfSumm[k] != 0){listOfSumm[k] = listOfSumm[k].toFixed(2);}
                }

                component.set("v.totalSum", totalSumm.toFixed(1));
                component.set("v.sum", listOfSumm);
                component.set("v.monthlyAvg", monthlyAvg);
                component.set("v.totalAmounts", totalAmount);
            } else {
                console.log("Failed with state: " + state);
            }
        });
        
        $A.enqueueAction(action);
    }
})