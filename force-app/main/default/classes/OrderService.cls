public with sharing class OrderService {

    public UpdateStatusOrder() {
        
       // Stocker tous les OrderID
        Set<Id> orderIds = new Set<Id>();

        for (Order ord : orders) {
       //Filtrage de la recherche par STATUS
            if (ord.Status == 'Activated') {
                orderIds.add(ord.Id);
            }
        }
        // Requête pour récupérer les orders et leurs produits associés (OrderItem)
        // Initialisation de la MAP pour stocker la list d'OrderItem
        Map<Id, List<OrderItem>> orderItemsMap = new Map<Id, List<OrderItem>>();
            List<OrderItem> orderItems = [SELECT OrderId FROM OrderItem WHERE OrderId IN :orderIds];

      // Condition de vérification
       if (!orderIds.isEmpty()) {
            List<OrderItem> orderItems = [SELECT OrderId FROM OrderItem WHERE OrderId IN :orderIds];
            // Grouper les OrderItems par OrderId
            for (OrderItem item : orderItems) {
                if (!orderItemsMap.containsKey(item.OrderId)) {
                    orderItemsMap.put(item.OrderId, new List<OrderItem>());
                }
                orderItemsMap.get(item.OrderId).add(item);
            }
        }

        // Vérifier les orders et bloquer ceux sans produits associés
        for (Order ord : orders) {
            if (ord.Status == 'Activated' && (orderItemsMap.get(ord.Id) == null || orderItemsMap.get(ord.Id).isEmpty())) {
                ord.addError('L\'utilisateur ne peut pas passer le statut de l\'order en « Actif » sauf si l\'order en question a des produits associés.');
            }
    }
}

}