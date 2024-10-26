public with sharing class OrderService {

    public static void updateStatusOrder(List<Order> orders) {
        
        // Stocker tous les OrderID des ordres activés
        Set<Id> orderIds = new Set<Id>();

        // Filtrer les ordres par statut 'Activated'
        for (Order ord : orders) {
            if (ord.Status == 'Activated') {
                orderIds.add(ord.Id);
            }
        }

        // Si aucun Order n'est activé, on arrête le traitement
        if (orderIds.isEmpty()) {
            return; // Rien à faire si aucun ordre n'est activé
        }

        // Requête pour récupérer les OrderItems associés aux Orders activés
        List<OrderItem> orderItems = [
            SELECT OrderId 
            FROM OrderItem 
            WHERE OrderId IN :orderIds
        ];

        // Initialiser une Map pour stocker les OrderItems par OrderId
        Map<Id, List<OrderItem>> orderItemsMap = new Map<Id, List<OrderItem>>();

        // Parcourir les OrderItems et les organiser par OrderId
        for (OrderItem item : orderItems) {
            if (!orderItemsMap.containsKey(item.OrderId)) {
                orderItemsMap.put(item.OrderId, new List<OrderItem>());
            }
            orderItemsMap.get(item.OrderId).add(item);
        }

        // Vérifier chaque Order activé et bloquer ceux sans produits associés
        // DOUBLE VERIFICATION
        for (Order ord : orders) {
            if (ord.Status == 'Activated' && 
                (orderItemsMap.get(ord.Id) == null || orderItemsMap.get(ord.Id).isEmpty())) {
                ord.addError('L\'utilisateur ne peut pas passer le statut de l\'ordre en « Actif » sauf si l\'ordre a des produits associés.');
            }
        }
    }

    
  public static void afterDeleteOrder(List<Order> orders) {

    // Stocker nos Ids de comptes
    Set<Id> accountIds = new Set<Id>();

    // Vérification des données
    for (Order ord : orders) {
        // Ajoute les IDs de comptes associés aux orders s'ils existent
        if (ord.AccountId != null) {
            accountIds.add(ord.AccountId);
        }
    }

    // Si aucun ID de compte n'est trouvé, on quitte la méthode
    if (accountIds.isEmpty()) {
        return;
    }

    // Requête pour récupérer les Accounts associés aux orders supprimés
    List<Account> accountsToUpdate = [
        SELECT Id, (SELECT Id FROM Orders) 
        FROM Account 
        WHERE Id IN :accountIds
    ];

    // Nouvelle liste pour stocker les comptes à mettre à jour
    List<Account> accountsToUpdateList = new List<Account>();

    // Parcourir les comptes et vérifier s'ils n'ont plus d'orders associés
    for (Account acc : accountsToUpdate) {
        // Si le compte n'a plus d'orders associés, mettre à jour le champ IsActive__c
        if (acc.Orders.isEmpty()) {
            acc.IsActive__c = false; // Passer le champ IsActive__c à false si aucun ordre n'est trouvé
            accountsToUpdateList.add(acc); // Ajouter le compte à la liste pour mise à jour
        }
    }

    // Mise à jour des comptes si nécessaire 
    if (!accountsToUpdateList.isEmpty()) {
        update accountsToUpdateList; // BDD
    }
}

}
