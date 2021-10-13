trigger ContactTrigger on Contact (after insert, before delete) {
   if (Trigger.isInsert) { 
     for(Contact item : Trigger.New){
        Case cs = new Case();
        cs.ContactId = item.Id;
        cs.AccountId = item.AccountId != null ? item.AccountId : null;
        cs.Status = 'Working';
        cs.Origin = 'New Contact';
        
        if (cs.AccountId != null){
            List<Account> acc = new List<Account>([SELECT Id, OwnerId FROM Account WHERE Id = :cs.AccountId]);
            cs.OwnerId = acc[0].OwnerId;
        }
        
        if(item.Contact_Level__c == 'Primari'){
            cs.Priority = 'High';
        }else if (item.Contact_Level__c == 'Secondary'){
            cs.Priority = 'Medium';
        }else {
            cs.Priority = 'Low';
        }
        insert cs;
       }

	}
	else if (Trigger.isDelete) {
		Set<Id> ConIDs = Trigger.oldMap.keyset();
				delete [SELECT Id FROM Case WHERE ContactId IN:ConIDs];
	}
}