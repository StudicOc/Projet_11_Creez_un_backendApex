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
        for (Order ord : orders) {
            if (ord.Status == 'Activated' && 
                (orderItemsMap.get(ord.Id) == null || orderItemsMap.get(ord.Id).isEmpty())) {
                ord.addError('L\'utilisateur ne peut pas passer le statut de l\'ordre en « Actif » sauf si l\'ordre a des produits associés.');
            }
        }
    }
}
