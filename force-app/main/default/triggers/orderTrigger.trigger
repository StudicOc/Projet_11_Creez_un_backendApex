trigger orderTrigger on SOBJECT (before insert) {

 if (Trigger.isBefore && Trigger.isUpdate) {
        OrderService.updateStatusOrder(Trigger.new);
    }
    
}