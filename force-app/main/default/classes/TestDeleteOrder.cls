
@isTest
private class TestDeleteOrder {

    @isTest
    static void updateFieldAccountAfterDeleteOrders() {

        // Création des données de test
        Account testAccount = TestDataFactory.createAccount('Account 1');
        Product2 testProduct = TestDataFactory.createProduct2('Produit 1');
        PricebookEntry testPriceBookEntry = TestDataFactory.createPricebookEntry(testProduct.Id);
        Order testOrder1 = TestDataFactory.createOrder(testAccount.Id);
        Order testOrder2 = TestDataFactory.createOrder(testAccount.Id);
        OrderItem testOrderItem1 = TestDataFactory.createOrderItem(testOrder1.Id, testPriceBookEntry.Id, 10, 150);
        OrderItem testOrderItem2 = TestDataFactory.createOrderItem(testOrder2.Id, testPriceBookEntry.Id, 10, 150);


        // Status par défaut
        testAccount.IsActive__c = true; 
        List<Order> ordersToDelete = new List<Order>{testOrder1, testOrder2};

        Test.startTest();
        delete ordersToDelete;
        Test.stopTest();

        // Vérification du field IsActive__c 
        Account updatedAccount = [SELECT Id, IsActive__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(false, updatedAccount.IsActive__c, 'Le champ IsActive__c doit être false après la suppression des commandes.');
    }


     @isTest
        static void testAfterDeleteOrderNoAccount() {
        // Créer une liste d'ordres sans AccountId
        List<Order> orders = new List<Order>{
            new Order(Name = 'Test Order 1', Status = 'Draft'), // Pas de AccountId
            new Order(Name = 'Test Order 2', Status = 'Draft')  // Pas de AccountId
        };

        Test.startTest();
        // Appel de la méthode
        OrderService.afterDeleteOrder(orders);
        Test.stopTest();
}
}


     
