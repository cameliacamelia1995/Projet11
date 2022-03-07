@IsTest
public with sharing class SchedulerAccTask_Test {
    @IsTest
    public static void checkScheduler() {
        Test.startTest();
        SchedulerAccTask accTask = new SchedulerAccTask();
        //calcule pour faire le schedule
        String sch = '0 1 *  1 * ? *';
        System.schedule('TestBatch',sch, accTask);
        Test.stopTest();
    }
}
