trigger orderTrigger on Order (before update) {

 if (Trigger.isBefore && Trigger.isUpdate) {
        OrderService.updateStatusOrder(Trigger.new);
    }
    
}