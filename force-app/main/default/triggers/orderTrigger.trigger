trigger OrderTrigger on Order (before update, after delete) {

  
    if (Trigger.isBefore && Trigger.isUpdate) {
        OrderService.updateStatusOrder(Trigger.new);
    }

  
    if (Trigger.isAfter && Trigger.isDelete) {
        OrderService.afterDeleteOrder(Trigger.old); 
    }
}