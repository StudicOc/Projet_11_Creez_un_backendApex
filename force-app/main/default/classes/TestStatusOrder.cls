@isTest
private class TestStatusOrder {

    @isTest
    static void orderWithoutOrdItem() {
        // Création des données de test
        Account accountClient = TestDataFactory.createAccount('Account 1');
        Order orderWithoutProduct = TestDataFactory.createOrder(accountClient.Id);
        
        // Mettre à jour le statut de l'ordre pour qu'il soit 'Activated'
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
}
