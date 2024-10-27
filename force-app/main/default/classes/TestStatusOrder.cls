@isTest
private class TestStatusOrder {

    @isTest
    static void orderWithoutOrdItem() {
        // Création des données de test
        Account accountClient = TestDataFactory.createAccount('Account 1');
        Order orderWithoutProduct = TestDataFactory.createOrder(accountClient.Id);
        
    
        orderWithoutProduct.Status = 'Activated';
    
        List<Order> orders = new List<Order>{orderWithoutProduct};

        Test.startTest();
        // Appel de la méthode updateStatusOrder
        OrderService.updateStatusOrder(orders);
        Test.stopTest();

        // Vérification que l'erreur est ajoutée directement sur la page ORDER
        System.assert(orderWithoutProduct.getErrors().size() > 0, 'Une erreur devrait être associée à l\'ordre car aucun produit n\'est lié.');
        System.assert(orderWithoutProduct.getErrors()[0].getMessage().contains('L\'utilisateur ne peut pas passer le statut de l\'ordre en « Actif » sauf si l\'ordre a des produits associés.'), 
                      'Le message d\'erreur devrait indiquer que l\'utilisateur ne peut pas passer le statut.');
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
        // Appel de la méthode updateStatusOrder
        OrderService.updateStatusOrder(orders);
        Test.stopTest();

        // Vérification du statut de l'ordre
        Order updatedOrder = [SELECT Status FROM Order WHERE Id = :testOrder.Id];
        System.assertEquals('Draft', updatedOrder.Status, 'Le statut de l\'order doit être "Activated".');

        // Vérification des articles de commande associés
        List<OrderItem> orderItems = [SELECT Id, Quantity, UnitPrice FROM OrderItem WHERE OrderId = :testOrder.Id];
        System.assertEquals(1, orderItems.size(), 'Il doit y avoir un article de commande associé.');
        System.assertEquals(10, orderItems[0].Quantity, 'La quantité de l\'article de commande doit être 10.');
        System.assertEquals(150, orderItems[0].UnitPrice, 'Le prix unitaire de l\'article de commande doit être 150.');
    }

}
