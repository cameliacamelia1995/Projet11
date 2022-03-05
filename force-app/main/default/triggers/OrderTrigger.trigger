trigger OrderTrigger on Order (before update, after update, after delete) {
    OrderTriggerHandler orderProduct = new OrderTriggerHandler(); 
//Cette classe contint les triggers qui sont déclenché lors d'un événement dans l'objet order
//Chaque If va appeler sa méthode
    if (Trigger.isBefore && Trigger.isUpdate) {
        orderProduct.stopIfNoProduct(Trigger.oldMap, Trigger.newMap);
    }

    if (Trigger.isAfter && Trigger.isUpdate)  {
        orderProduct.OrderUncheck(Trigger.new);
    }
    if(Trigger.isAfter && Trigger.isDelete) {
        orderProduct.OrderUncheck(Trigger.new);
    }
}