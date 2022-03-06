public class AccountTaskBatch implements Database.Batchable<sObject> { 
     // collect the batches of records or objects to be passed to execute
     public Integer recordsProcessed = 0;
     public Database.QueryLocator start(Database.BatchableContext bc) {
         //On selectionne les comptes qui n'ont pas d'order 
         //Pour cela on selectionne l'id des comptes qui ne se trouve pas dans la l'account ID des order
         return Database.getQueryLocator('SELECT Id FROM Account WHERE Id NOT IN (SELECT AccountId FROM Order)');
           
     }
     // process each batch of records
     public void execute(Database.BatchableContext bc, List<Account> accountBatch){
        Set<Id> AccTask = new Set<Id>();
        //Création d'une liste de tâche déjà existante pour les comptes du batch
        List<Task> TaskAlreadyInPlace = [SELECT WhatId FROM Task WHERE What.Type = 'Account' 
                                        AND ReminderDateTime > TODAY AND WhatId IN : accountBatch];
        //Pour chaque compte on vérifie qu'il y a une tâche
        for(Task t : TaskAlreadyInPlace){
            AccTask.add(t.WhatId);
        }
        //Création d'une liste des tâche
        List<Task> CreatedTask = new List<Task>();
        //Création de la variable date
        Date plusFiveDay = System.today().addDays(5);
        for(Account b : accountBatch){
            //Si ma liste de tâche existance ne contient pas l'id du compte itéré grâce a la valeur négative (!) on crée une tâche pour ses comptes
            if(!AccTask.contains(b.Id)) {
                //Création d'une tâche avec les champs demandés
                Task newTask = new Task (Description = 'Call client and reminder in 5 days', 
                Status = 'News', Subject = 'Call', ReminderDateTime = plusFiveDay, WhatId = b.Id, Priority = 'Normal', CallType = 'Outbound');
                CreatedTask.add(newTask);
            }
            recordsProcessed++;
        }
        insert CreatedTask;
     }
     // execute any post-processing operation
     public void finish(Database.BatchableContext bc){
         System.debug(recordsProcessed + ' records processed.');
         AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
             JobItemsProcessed,
             TotalJobItems, CreatedBy.Email
             FROM AsyncApexJob
             WHERE Id = :bc.getJobId()];
     }
 }