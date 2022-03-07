// Cette classe contient la logique du code de l'objet Order
public class OrderTriggerHandler {
    //Cette méthode est appelé avant la MAJ de l'object Order
    public void stopIfNoProduct(Map<Id,Order> orderOld, Map<Id,Order> orderNew) {
       //Création d'une liste vide de l'id de l'objet order
        Set<Id> idOrder = new Set<Id>();
        for(Order orderN : orderNew.values()) {
            //On fait correspondre l'ID des anciens et des nouveaux
            Order orderO = orderOld.get(orderN.Id);
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
                if(nOrder.OrderItems.size() == 0 || nOrder.OrderItems == null) {
                    //Dans la nouvelle liste d'order on récupère des orders qui ont été filtrés, et s'ils n'ont aucun produit un message d'erreur d'affiche 
                    orderNew.get(nOrder.Id).addError('Veuillez créer des produits avant de valider');
                }
            }
        }
    }
    public void OrderUncheck(List<Order> orderNewList){
        //Création de la liste a MAJ
        List<Account> AccUpdate = new List<Account>();
        //Création d'une liste vide de l'id de l'objet account
        Set<Id> idAccount = new Set<Id>();
        for(Order o : orderNewList) {
            if(o.AccountId != null) {
                //On ajoute les id du compte a l'objet order
                idAccount.add(o.AccountId);
            }
        }
         //Création d'une liste vide pour les ID des compte Acc & Orders
         //On selectionne l'ID des comptes et des orders ainsi que le champs actif
        List<Account> AccountAndOrders = [SELECT Id, (SELECT Id, AccountId FROM Orders),
                                            Actif__c FROM Account WHERE Id IN : idAccount];
        
        //On vérifie que le set ID n'est pas vide
        if(idAccount.size() > 0){
            for(Account a : AccountAndOrders) {
                //Si il n'y a aucun orders lié a ce compte
                if(a.orders == null || a.orders.size() == 0) {
                    //On vérifié que le champs actif est sur true
                if(a.Actif__c == true){
                    //Assignation sur false
                    a.Actif__c = false;
                    //On ajoute les comptes dans la liste
                    AccUpdate.add(a);
                    }
                }
                //Si il est existe au moins un order sur le compte et que la cache est décoché on la coche
                else {
                    if(a.Actif__c == false) {
                        a.Actif__c = true;
                        AccUpdate.add(a);
                    }
                }
            }
         }
         if(AccUpdate.size() > 0) {
            update AccUpdate;
         }
    }
}