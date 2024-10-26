@isTest
private class TestStatusOrder {

    @isTest
    static void displayMessageErrorToOrder() {
  
        Account firstAccount = TestDataFactory.createAccount('Account 1');
        Order testOrder = TestDataFactory.createOrder(firstAccount.Id);
        testOrder.Status = 'Activated'; 

        Test.startTest(); 
        OrderService.updateStatusOrder(new List<Order>{testOrder}); 
        Test.stopTest();

        // Vérification de son état après la mise à jour
        List<Order> updatedOrders = [SELECT Id, Status FROM Order WHERE Id = :testOrder.Id];

        // Vérifier que l'ordre a toujours le statut 'Draft' 
        System.assertEquals('Draft', updatedOrders[0].Status, 'L\'utilisateur ne peut pas passer le statut de l\'ordre en « Actif » sauf si l\'ordre a des produits associés.');

    }
}
