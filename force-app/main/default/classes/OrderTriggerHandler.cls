// Cette classe contient la logique du code de l'objet Order
public class OrderTriggerHandler {
    //Cette méthode est appelé avant la MAJ de l'object Order
    public void stopIfNoProduct(List<Id,Order> orderOld, List<Id,Order> orderNew) {
       //Création d'une liste vide de l'id de l'objet order
        Set<Id> idOrder = new Set<Id>();
        for(Order orderN : orderNew) {
            //On fait correspondre l'ID des anciens et des nouveaux
            Order orderO = (Order)orderOld.get(orderN.Id);
            //Si le statut a changé et si il est sur activated on ajouter l'id des nouveaux order dans le set
            if(orderN.status != orderO.Status && orderN.Status == 'activated') {
                idOrder.add(orderN.Id);
            }
        }
        //Selectionne l'ID de tous les orders a condition que l'ID des order soit dans le set
        List<Order> orderListAndItems = [SELECT Id,(SELECT Id FROM OrderItems)
                                        FROM Order WHERE Id IN : idOrder];
        // On vérifie que le set n'est pas vide
        if(idOrder != null && idOrder.size() > 0) {
            for(Order nOrder : orderListAndItems) {
                //Si il n'ya produit pour chaque nouvel order, on affiche un message d'erreur
                if(nOrder.OrderItems.size()== 0 ||nOrder.OrderItems == null) {
                    //Dans la nouvelle liste d'order on récupère des orders qui ont été filtrés, et s'ils n'ont aucun produit un message d'erreur d'affiche 
                    orderNew.get(nOrder.Id).addError('Veuillez créer des produits avant de valider');
                }
            }
        }
    }
    public void OrderUncheck(){
        

    }
}
