@isTest
private class TestStatusOrder {

    @isTest
    static void orderWithoutOrdItem() {

        Account accountClient = TestDataFactory.createAccount('Account 1');
        Order orderWithoutProduct = TestDataFactory.createOrder(accountClient.Id);
        
        orderWithoutProduct.Status = 'Activated';
        List<Order> orders = new List<Order>{orderWithoutProduct};

        Test.startTest();
        try {
            update orders;
        } catch (Exception e) {
               System.assert(e.getMessage().contains('L\'utilisateur ne peut pas passer le statut de l\'ordre en « Actif » sauf si l\'ordre a des produits associés.'), 
                'Le message d\'erreur devrait indiquer que l\'utilisateur ne peut pas passer le statut.');
        }
        Test.stopTest();
    }


  @isTest
    static void orderWithArticle() {
        // Création des données de test
        Account testAccount = TestDataFactory.createAccount('Account 1');
        Product2 testProduct = TestDataFactory.createProduct2('Produit 1');
        PricebookEntry testPriceBookEntry = TestDataFactory.createPricebookEntry(testProduct.Id);
        Order testOrder = TestDataFactory.createOrder(testAccount.Id);
        OrderItem testOrderItem1 = TestDataFactory.createOrderItem(testOrder.Id, testPriceBookEntry.Id, 10, 150);
        
        // Mettre à jour le statut de l'ordre
        testOrder.Status = 'Activated';  
        List<Order> orders = new List<Order>{testOrder};
        
        Test.startTest();
        update orders;
        Test.stopTest();

        // Vérification du statut de l'ordre
        Order updatedOrder = [SELECT Status FROM Order WHERE Id = :testOrder.Id];
        System.assertEquals('Activated', updatedOrder.Status, 'Le statut de l\'order doit être "Activated".');
    }

 


    @isTest 
    static void noOrderId (){
        Account testAccount = TestDataFactory.createAccount('Account 1');
        Order testOrder = TestDataFactory.createOrder2(testAccount.Id, 'Draft'); // Use 'Draft' status


        List<Order> orders = [SELECT Id, Status FROM Order WHERE Id = :testOrder.Id];

   
        Test.startTest();
        OrderService.updateStatusOrder(orders);
        Test.stopTest();

        System.assertEquals('Draft', orders[0].Status, 'Order status should remain "Draft" since no order is "Activated".');
    }
}
