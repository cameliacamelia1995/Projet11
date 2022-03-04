trigger OrderTrigger on Order (before update, after update) {
    OrderTriggerHandler orderProduct = new OrderTriggerHandler(); 
//Cette classe contint les triggers qui sont déclenché lors d'un événement dans l'objet order
    if (Trigger.isBefore) {
        orderProduct.stopIfNoProduct(Trigger.old, Trigger.new);
    }

    if (Trigger.isAfter) {
        orderProduct.OrderUncheck(Trigger.new);
    }
}