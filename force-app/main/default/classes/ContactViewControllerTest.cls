@isTest 
private class ContactViewControllerTest {
     
    @isTest static void ContactViewControllerTest1 (){
        
        ContactViewController controller = new ContactViewController();
        
        controller.size = 1;
        controller.noOfRecords = 1;
        controller.SearchContacts = 'test';      
        
         Contact con = new Contact(
            FirstName = 'Gleb',
            LastName = 'Nov',
            Email = 'asd@mail.ru'           
        );
        insert con;
        
		controller.SelectedContactId = con.Id;
        controller.deleterecord();
        controller.deleterecord();
        controller.SearchContact();
        controller.sortName();
        controller.sortEmail();
        controller.sortAN();
        controller.sortCD();
        controller.sortON();
        controller.sortCN();
        controller.sortCL();      
    }

}