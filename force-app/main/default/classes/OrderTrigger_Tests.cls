@isTest
public with sharing class OrderTrigger_Tests {
    @isTest
    public static void checkNormalRun () {
        TestDataFactory.createdProduct(1, 1, 1, 1);
        List<Order> verifyStatus = [SELECT Id, Status FROM Order LIMIT 1];
        List<Order> newStatus = new List<Order>();
        
        for (Order v : verifyStatus) {
            String oldStatus =  String.valueOf(v.Status);
            System.assertEquals('Draft',oldStatus);
        }
         Test.startTest();
        
         for(Order o : verifyStatus) {
            o.Status = 'Activated';
            newStatus.add(o);
        }
        update newStatus;
        Test.stopTest();
            
                for (Order w : newStatus) {
                String checkedStatus = String.valueOf(w.Status);
                System.assertEquals('Activated',checkedStatus);
            }
    }
    
    @isTest
    public static void verifyErrorMessage() {
        TestDataFactory.createdProduct(1, 1, 0, 0);
        List<Order> orderList = [SELECT Id FROM Order LIMIT 1];
        Test.startTest();
        for(Order ol : orderList) {
            ol.Status = 'Activated';
        }
        try {
            update orderList;
        }
        catch (Exception e) {
            System.assert(e.getMessage().contains('Veuillez créer des produits avant de valider'));
        }
        Test.stopTest();
    }
    @isTest 
    public static void uncheckIfNoOrder() {
        TestDataFactory.createdProduct(1, 1, 0, 1);
        Account accCheck = [SELECT Id, Actif__c FROM Account WHERE Actif__c = true LIMIT 1];’
        List<Order> orderToDelete = [SELECT Id FROM Order WHERE AccountId =: accCheck.Id];
        Test.startTest();
        delete orderToDelete;
        Test.stopTest();
        List<Order> noOrder = [SELECT Id FROM Order WHERE AccountId =: accCheck.Id];
        Account updatedAcc = [SELECT Id, Actif__c FROM Account LIMIT 1];
        System.assertEquals(0, noOrder.size());
        System.assertEquals(false, updatedAcc.Actif__c);
    }
    @isTest
    public static void checkIfOrderCreation() {
        TestDataFactory.createdProduct(1, 1, 0, 1);
        Account accTest = [SELECT Id, Actif__c FROM Account LIMIT 1];
        List<Order> orderDeleting = [SELECT Id FROM Order WHERE AccountId =: accTest.Id];
        Date dating = System.today();
        Contract myContract = new Contract(Name='Test Contract', StartDate=dating, Status='Draft', AccountId = accTest.Id);
        Order orderTest = new Order(AccountId = accTest.Id, EffectiveDate = dating, Status = 'Draft', ContractId = myContract.Id);
        Test.startTest();
        delete orderDeleting;
        Account checkingAcc = [SELECT Id, Actif__c FROM Account LIMIT 1];
        insert orderTest;
        orderTest.Description = 'Test';
        update orderTest;
        Account newAcc = [SELECT Id, Actif__c FROM Account LIMIT 1];
        Order newOrd =  [SELECT Id FROM Order WHERE AccountId =: newAcc.Id];
        delete newOrd;
        Account lastAcc = [SELECT Id, Actif__c FROM Account LIMIT 1];
        Test.stopTest();
        Account updatedAcc = [SELECT Id, Actif__c FROM Account WHERE Id =: accTest.Id LIMIT 1];
        System.assertEquals(true, accTest.Actif__c);
        System.assertEquals(false, checkingAcc.Actif__c);
        System.assertEquals(true, newAcc.Actif__c);
        System.assertEquals(false, updatedAcc.Actif__c);
    }
    @isTest
    public static void checkBasebox(){
        TestDataFactory.createdProduct(1, 0, 0, 0);
        Test.startTest();
        Account myAccount = [SELECT Id, Actif__c FROM Account LIMIT 1];
        Test.stopTest();
       System.assertEquals(true, myAccount.Actif__c);
    }
}