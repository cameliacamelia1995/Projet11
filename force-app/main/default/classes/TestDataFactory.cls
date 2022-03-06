public class TestDataFactory {
    
    public static void createdProduct (Integer numberOfAccount, Integer numberOfOrders, 
    Integer numberOfTask, Integer itemQuantity) {
        // Je crée un produit, un catalogue, une entrée de catalogue et une entrée de test.
        // Je place les paramètres des produits avec les champs obligatoire
        // Cela simule l'environnement de base qui se trouve dans SF
        Product2 productForTest = new Product2 (Name = 'Iphone 12', ProductCode = 'A2403', Family = 'Smartphone', IsActive = true);
        insert productForTest; 
        PricebookEntry standardEntry = new PricebookEntry(Pricebook2Id = Test.getStandardPriceBookId(), Product2Id = productForTest.id, UnitPrice = 100, UseStandardPrice = false, IsActive = true);
        insert standardEntry;
        Pricebook2 standardPriceBook = new Pricebook2(Name = 'Standard Price Book', IsActive = true);
        insert standardPriceBook; 
        PricebookEntry testPriceBookEntry = new PricebookEntry(Pricebook2Id = standardPriceBook.Id, Product2Id = productForTest.id, UnitPrice = 100, UseStandardPrice = false, IsActive = true);
        insert testPriceBookEntry;
        
        Date plusFiveDay = System.today().addDays(8);
        List<Account> createdAccount = new List<Account>(); 
        List<Order> createdOrder = new List<Order>();
        List<OrderItem> createdOrderItems = new List<OrderItem>();
        List<Task> CreatedTasks = new List<Task>();
        
        for (Integer i = 0; i < numberOfAccount; i++) {
            Account accts = new Account(Name = 'Testing Account' + i); 
            createdAccount.add(accts);
        }
        insert createdAccount; 

        for (Integer a = 0; a < createdAccount.size(); a++) {
            Account testAccts = createdAccount[a];
            for(Integer o = 0; o < numberOfOrders; o++) {
                Order testOrder = new Order(AccountId = testAccts.id, EffectiveDate = Date.today(), Pricebook2Id = testPriceBookEntry.Pricebook2Id, Status = 'Draft');
                createdOrder.add(testOrder);
            }
        }
        insert createdOrder;

        for(Integer t = 0; t < createdAccount.size(); t++) {
            Account acctsTest = createdAccount[t];
            for(Integer ta = 0; ta < numberOfTask; ta++){
                CreatedTasks.add(new Task (Description = 'Call client and reminder in 5 days', Status = 'News', Subject = 'Call', ReminderDateTime = plusFiveDay, WhatId = acctsTest.Id, Priority = 'Normal', CallType = 'Outbound'));
            }
        }
        insert CreatedTasks;
      
        for (Integer s = 0; s < createdOrder.size(); s++) {
            Order orderTest = createdOrder[s];
            for(Integer c = 0; c < itemQuantity; c++) {
            createdOrderItems.add(new OrderItem(OrderID = orderTest.id, Product2Id = productForTest.id, PriceBookEntryId = testPriceBookEntry.id, UnitPrice = testPriceBookEntry.UnitPrice, Quantity = 1));
            }   
        }
        insert createdOrderItems; 
        update createdOrder;
        update createdAccount;
    }
}
