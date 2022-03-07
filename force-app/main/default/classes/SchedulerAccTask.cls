global class SchedulerAccTask implements Schedulable{
    //Cette classe va déclenché le batch le premier lundi de chaque mois
    global void execute(SchedulableContext Info) {
        AccountTaskBatch atb = new AccountTaskBatch();
        //Respect des limitations d'enregistrement
        Database.executeBatch(atb, 200);
    }
}