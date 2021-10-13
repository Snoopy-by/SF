public with sharing class ContactViewController {
  
    public String SearchContacts {get;set;}
    public String SelectedContactId {get;set;}
    public Integer noOfRecords{get;set;}
    public Integer size{get;set;}  
  
        public List<Contact> Names  { get{
           return (List<Contact>)setCon.getRecords();
        } set; }
    
        public ApexPages.StandardSetController setCon {
             get{
                if(setCon == null){
					size = 10;
					String SearchContactsCreteria = '%'+(SearchContacts == null ? '' : SearchContacts)+'%';
					List<Contact> ContactList = [SELECT Id, Name, Email, Contact_Level__c, Account.Name, Owner.Name, CreatedBy.Name, CreatedDate 
                                         FROM Contact WHERE Name LIKE :SearchContactsCreteria LIMIT 10000];
     				setCon = new ApexPages.StandardSetController(ContactList);
					setCon.setPageSize(size);
					noOfRecords = setCon.getResultSize();
					}
					return setCon;
				}set;
		}

		public void SearchContact() {
			setCon = null;
			setCon.setPageNumber(1);
		}
    
    	public void deleterecord(){
        
			if (SelectedContactId == null) {return;}
 
			Contact tobeDeleted = null;
			for(Contact a : Names)
				if (a.Id == SelectedContactId) {
					tobeDeleted = a;
					break;
				}
        
			if (tobeDeleted != null) {
				delete tobeDeleted;
			} 
            
            	List<Contact> ContactList = [SELECT Id, Name, Email, Contact_Level__c, Account.Name, Owner.Name, CreatedBy.Name, CreatedDate 
                                         FROM Contact];
            	setCon = new ApexPages.StandardSetController(ContactList);
					setCon.setPageSize(size);
					noOfRecords = setCon.getResultSize();   	
		    } 
    
            public void sortName(){
            	List<Contact> ContactList = [SELECT Id, Name, Email, Contact_Level__c, Account.Name, Owner.Name, CreatedBy.Name, CreatedDate 
                                         FROM Contact ORDER BY Name ASC];
            	setCon = new ApexPages.StandardSetController(ContactList);
					setCon.setPageSize(size);
					noOfRecords = setCon.getResultSize(); 
    		}
    
    		public void sortEmail(){
            	List<Contact> ContactList = [SELECT Id, Name, Email, Contact_Level__c, Account.Name, Owner.Name, CreatedBy.Name, CreatedDate 
                                         FROM Contact ORDER BY Email ASC];
            	setCon = new ApexPages.StandardSetController(ContactList);
					setCon.setPageSize(size);
					noOfRecords = setCon.getResultSize(); 
    		}
    
    		public void sortCL(){
            	List<Contact> ContactList = [SELECT Id, Name, Email, Contact_Level__c, Account.Name, Owner.Name, CreatedBy.Name, CreatedDate 
                                         FROM Contact ORDER BY Contact_Level__c ASC];
            	setCon = new ApexPages.StandardSetController(ContactList);
					setCon.setPageSize(size);
					noOfRecords = setCon.getResultSize(); 
    		}
    
    		public void sortAN(){
            	List<Contact> ContactList = [SELECT Id, Name, Email, Contact_Level__c, Account.Name, Owner.Name, CreatedBy.Name, CreatedDate 
                                         FROM Contact ORDER BY Account.Name ASC];
            	setCon = new ApexPages.StandardSetController(ContactList);
					setCon.setPageSize(size);
					noOfRecords = setCon.getResultSize(); 
    		}
       		
    		public void sortON(){
            	List<Contact> ContactList = [SELECT Id, Name, Email, Contact_Level__c, Account.Name, Owner.Name, CreatedBy.Name, CreatedDate 
                                         FROM Contact ORDER BY Owner.Name ASC];
            	setCon = new ApexPages.StandardSetController(ContactList);
					setCon.setPageSize(size);
					noOfRecords = setCon.getResultSize(); 
    		}
    
           	public void sortCN(){
            	List<Contact> ContactList = [SELECT Id, Name, Email, Contact_Level__c, Account.Name, Owner.Name, CreatedBy.Name, CreatedDate 
                                         FROM Contact ORDER BY CreatedBy.Name ASC];
            	setCon = new ApexPages.StandardSetController(ContactList);
					setCon.setPageSize(size);
					noOfRecords = setCon.getResultSize(); 
    		}
    
       		public void sortCD(){
            	List<Contact> ContactList = [SELECT Id, Name, Email, Contact_Level__c, Account.Name, Owner.Name, CreatedBy.Name, CreatedDate 
                                         FROM Contact ORDER BY CreatedDate ASC];
            	setCon = new ApexPages.StandardSetController(ContactList);
					setCon.setPageSize(size);
					noOfRecords = setCon.getResultSize(); 
					// проверка proverka
					//Hello VS Code for Salesforce
    		}
    
}