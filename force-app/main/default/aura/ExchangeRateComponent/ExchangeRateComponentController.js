({
    doInit: function (component, event, helper) {
        var action = component.get("c.getPickList");
    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               
                var obj = response.getReturnValue();
                var listDef = Object.keys(obj);
                var def = listDef[0];
                var listVal = Object.values(obj);
                var picklist = listVal[0];
                var indexD = 0;
                
                for(var i=0; i<picklist.length; i++){
                    if(picklist[i] == def){
                        indexD = i;
                    }
                }
                
                var newPL = [];
                newPL.push(def);
                
                var delElem = picklist.splice(indexD,1);
                
                for(var i=0; i<picklist.length; i++){
                    newPL.push(picklist[i]);
                }
                var st = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
                
                
                component.set("v.defCur", def);
                component.set("v.listOfCur", newPL);
                component.set("v.inputDate", st);
                component.set("v.maxDate", st);
                
                var action1 = component.get("c.getChangeCurrDate");
                $A.enqueueAction(action1);
            }
            else {
                helper.message(component, 'Error!', 'error', 'Unknown Error');

            }
        });
        $A.enqueueAction(action);
        
    },
    
    onChange: function(component, event, helper) {
        
        var tabID = component.get("v.selTabId");
        if(tabID == 'dateId'){
            var action = component.get("c.getChangeCurrDate");
            $A.enqueueAction(action);
        }
        else{
            var action1 = component.get("c.getChangeCurrPeriod");
            $A.enqueueAction(action1);
        }        
    },
    
    getChangeCurrDate: function (component, event, helper) {
        var inpDate = component.get("v.inputDate");
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
       
        if (inpDate > today){
            helper.message(component, 'Error!', 'error', 'You entered an invalid date!');
        }else { 
        
        var action = component.get("c.getExchangeByDate");      
        var PL = component.get("v.listOfCur");
        var table = [];
        var d = 'Date';
        table.push({
            label: d, fieldName: 'mysc__Date__c', type: 'Date', cellAttributes: { alignment: 'left' }
        });
        for(var i=0; i<PL.length;i++){
            table.push({
                label: PL[i], fieldName: 'mysc__' + PL[i] + '__c', type: 'number', cellAttributes: { alignment: 'left' }
            });
        }
   
        component.set('v.columnsPL', table);
        
        var inpDate = component.get("v.inputDate");
        var inputCur = component.get("v.defCur");
        action.setParams({
            inputNameCur: inputCur,
            inpDate: inpDate
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               helper.message(component, 'Confirmation', 'confirm', 'Completed!');
               component.set("v.curInfoTable", response.getReturnValue());
            }
            else {
               helper.message(component, 'Error!', 'error', 'Unknown Error');
            }
            
        });
        
        $A.enqueueAction(action);
        }
       },
    
    getChangeCurrPeriod: function (component, event, helper){
        
        var inputCur = component.get("v.defCur");
        var sDate = component.get("v.startDate");
        var fDate = component.get("v.endDate");
        var timeDiffrence = Date.parse(fDate) - Date.parse(sDate);
        var differDays = Math.ceil(timeDiffrence / (24 * 1000 * 3600));
        var toDay = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        if(sDate == null || fDate == null){
		helper.message(component, 'Information', 'info', 'You did not choose a period!');
        } else if (sDate >= fDate || fDate > toDay){
			helper.message(component, 'Warning', 'warning', 'You entered an invalid date! Value start date must be less than value end date');
        } else if (differDays > 366){
            helper.message(component, 'Error!', 'error', 'Choose a shorter time period!');
        }else {
            	component.set("v.spinner", true);
        		var action = component.get("c.getExchangeByPeriod");        
        		var PL = component.get("v.listOfCur");
        		var table = [];
        			var d = 'Date';
        	table.push({
            	label: d, fieldName: 'mysc__Date__c', type: 'Date', cellAttributes: { alignment: 'left' }
        		});
        for(var i=0; i<PL.length;i++){
            table.push({
                label: PL[i], fieldName: 'mysc__' + PL[i]+'__c', type: 'number', cellAttributes: { alignment: 'left' }
            });
        }
    
        component.set('v.columnsPL', table);
        
      
        action.setParams({
            inputNameCur: inputCur,
            startDate: sDate,
            endDate: fDate
        });
        
        var actionL = component.get("c.initLogs");
        actionL.setParams({
            inputNameCur: inputCur,
            startDate: sDate,
            endDate: fDate
        });
        $A.enqueueAction(actionL);
                
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.message(component, 'Confirmation', 'confirm', 'Completed!');
                component.set("v.curInfoTable", response.getReturnValue());
            }
            else {
                component.set("v.curInfoTable", response.getReturnValue());
              	helper.message(component, 'Error!', 'error', 'Choose a shorter time period!');
            }
            component.set("v.spinner", false);

        });
            $A.enqueueAction(action);
        }
        
    }
    
})