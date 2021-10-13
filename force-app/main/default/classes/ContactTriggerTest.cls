@isTest
private class ContactTriggerTest {
    
    @isTest static void testSecondary (){
    
        ContactViewController controller = new ContactViewController();
        
        Account ac = new Account(
            Name = 'test'         
        );
        insert ac;
 
        Contact newContact = new Contact(
            FirstName = 'Gleb',
            LastName = 'Nov',
            Contact_Level__c = 'Secondary',
            AccountId = ac.Id
        );
        insert newContact;
   
        Case cs = new Case();    	
        insert cs;
      
		controller.SelectedContactId = newContact.Id;
        controller.deleterecord();
 	}
    
        @isTest static void testPrimary (){
    
        ContactViewController controller = new ContactViewController();
        
        	Contact newContact = new Contact(
            	FirstName = 'Gleb',
            	LastName = 'Nov',
            	Contact_Level__c = 'Primari'
        	);
        	insert newContact;
        }

    @isTest static void testTertiary (){
    
        ContactViewController controller = new ContactViewController();
        
        Contact newContact = new Contact(
            FirstName = 'Gleb',
            LastName = 'Nov',
            Contact_Level__c = 'Tertiary'
        );
        insert newContact;     
    }     
}