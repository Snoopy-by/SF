({
	doInit : function(component, event, helper) {
        
        var monthNames = ["January", "February", "March", "April", "May", "June",
                		  "July", "August", "September", "October", "November", "December"
            			 ];
        
        var now = new Date();
    	var nowYear = now.getFullYear();
    	var nowMonth = now.getMonth();
        
        component.set("v.months", monthNames[nowMonth]);
        component.set("v.selectedMonth", monthNames[nowMonth]);
        nowMonth = nowMonth + 1;
    	component.set("v.nameYear", nowYear);
    	component.set("v.nameMonth", nowMonth);
        
    var listYear = new Array();
    listYear.push(nowYear - 3);
    listYear.push(nowYear - 2);
    listYear.push(nowYear - 1);
    listYear.push(nowYear);
    component.set("v.listYears", listYear);

    var yearButtons = component.find("yearBtnGroup");
    for(var i in yearButtons){
        if(i == 3){
          yearButtons[i].set("v.variant", "brand");
        }
    }
        var myPageRef = component.get("v.pageReference");
        if (myPageRef.state.c__admin == true){component.set('v.ifAdmin',myPageRef.state.c__admin);}
        component.set('v.Office', myPageRef.state.c__Office);
        component.set('v.login', myPageRef.state.c__login);
        helper.helperGetNavigationInfo(component);
        helper.helperGetBalance(component);
        helper.initMonthes(component);
    },
    
    onAccordionClick: function (component, event, helper) {
    component.set("v.columns", [
      {
        label: "DESCRIPTION",
        fieldName: "mysc__Description__c",
        type: "text",
        initialWidth: 500,
        editable: true,
        cellAttributes: { alignment: "left" }
      },
      {
        label: "AMOUNT",
        fieldName: "mysc__Amount__c",
        type: "currency",
        editable: true,
        typeAttributes: {
          currencyCode: "USD"
        },
        initialWidth: 160,
        cellAttributes: { alignment: "left" }
      },
      {
        label: "ACTION",
        type: "button",
        initialWidth: 160,
        typeAttributes: {
          name: "DeleteAction",
          title: "Click to delete card",
          label: "Delete",
          variant: "base"
        },
        cellAttributes: { alignment: "left" }
      }
    ]);

    var action = component.get("c.getExpensesWithDate");
    var activeSec = component.get("v.activeSections");
    var nameEmail = component.get("v.login");
    var dat = new Date(activeSec);
    action.setParams({
      selectDate: dat,
      emailCMP: nameEmail
    });

    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var obj = response.getReturnValue();
        var accordionTotal = 0;
        for (var i = 0; i < obj.length; i++) {
          accordionTotal = accordionTotal + obj[i].mysc__Amount__c;
        }
        component.set("v.totalAccordion", accordionTotal);
        component.set("v.expensesInfo", response.getReturnValue());
      } else {
        console.log("Failed with state: " + state);
      }
    });

    $A.enqueueAction(action);
  },

  onMonthClick: function (component, event, helper) {
    var action = component.get("c.getExpensesWithMonth");
    var selected = event.getParam("name");
    if (selected != null) {
      component.set("v.selectedMonth", selected);
    } else {
      var currentMonth = component.get("v.months");
      selected = currentMonth;
    }
    var monthDate = 0;

    if (selected == "December") {
      monthDate = 12;
    }
    if (selected == "November") {
      monthDate = 11;
    }
    if (selected == "October") {
      monthDate = 10;
    }
    if (selected == "September") {
      monthDate = 9;
    }
    if (selected == "August") {
      monthDate = 8;
    }
    if (selected == "July") {
      monthDate = 7;
    }
    if (selected == "June") {
      monthDate = 6;
    }
    if (selected == "May") {
      monthDate = 5;
    }
    if (selected == "April") {
      monthDate = 4;
    }
    if (selected == "March") {
      monthDate = 3;
    }
    if (selected == "February") {
      monthDate = 2;
    }
    if (selected == "January") {
      monthDate = 1;
    }

    var year = component.get("v.nameYear");
    var nameEmail = component.get("v.login");
    var allInfo = new Array();
    allInfo.push(monthDate);
    allInfo.push(year);

    action.setParams({
      info: allInfo,
      email: nameEmail
    });

    action.setCallback(this, function (response) {
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
    onYearClick: function (component, event, helper) {

    var yearButtons = component.find("yearBtnGroup");
    for(var i in yearButtons){
        yearButtons[i].set("v.variant", "neutral");
    }

    var selectedButtonLabel = event.getSource().get("v.label");
    var btn = event.getSource();
    btn.set("v.variant", "brand");
    component.set("v.nameYear", selectedButtonLabel);

    helper.helperGetNavigationInfo(component);
    helper.helperYearClickAccordion(component);
        
  },
    newExpenseClick: function (component, event, helper) {
        
        	var nameEmail = component.get("v.login");
        	var Office = component.get("v.Office");
          	var navService = component.find("navService");
          	var pageReference = {
             	type: 'standard__component',
                attributes: {
                  componentName: 'c__NewCard',
                            },
                            state: {    
                            "c__login" : nameEmail, 
                            "c__Office" : Office
                            }
                        };
                        event.preventDefault();
                        navService.navigate(pageReference);

  	},
    
  onRowClick: function (component, event, helper) {
    var action = component.get("c.deleteExpenseCard");
    var row = event.getParam("row");
    var infoAction = event.getParam("action");

    if (infoAction.name == "DeleteAction") {
      action.setParams({
        cardForDel: row
      });

      $A.enqueueAction(action);

      helper.helperGetBalance(component);
      helper.helperGetNavigationInfo(component);
      helper.helperYearClickAccordion(component);

      var action1 = component.get("c.onAccordionClick");
      $A.enqueueAction(action1);
    }
  },

  handleSaveEdition: function (component, event, helper) {
    var draftValues = event.getParam("draftValues");
    var action = component.get("c.changeExpenseCard");

    action.setParams({
      cardForCng: draftValues
    });

    $A.enqueueAction(action);

    helper.helperGetBalance(component);
    helper.helperGetNavigationInfo(component);

    var action1 = component.get("c.onAccordionClick");
    $A.enqueueAction(action1);
  },
    
    incomeClick: function (component, event, helper) {

        	var nameEmail = component.get("v.login");
        	var Office = component.get("v.Office");
        	var monthCmp = component.get("v.selectedMonth");
    		var yearCmp = component.get("v.nameYear");
          	var navService = component.find("navService");
          	var pageReference = {
             	type: 'standard__component',
                attributes: {
                  componentName: 'c__Income',
                            },
                            state: {    
                            "c__login" : nameEmail, 
                            "c__Office" : Office,
                            "c__year" : yearCmp,
                            "c__month" : monthCmp
                            }
                        };
                        event.preventDefault();
                        navService.navigate(pageReference);

  	},
    clickBackAdminPage: function (component, event, helper){
        	var myPageRef = component.get("v.pageReference");
        	component.set('v.login', myPageRef.state.c__login);
        	component.set('v.Office', myPageRef.state.c__Office);
        	var nameEmail = component.get("v.login");
        	var Office = component.get("v.Office");
        	
    		
          	var navService = component.find("navService");
          	var pageReference = {
             	type: 'standard__component',
                attributes: {
                  componentName: 'c__Admin',
                            },
                            state: {    
                            "c__login" : nameEmail, 
                            "c__Office" :undefined
                           
                            
                            }
                        };
                        event.preventDefault();
        				
                        navService.navigate(pageReference);
    },
    reInit : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    }
})