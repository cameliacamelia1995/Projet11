@IsTest
public class AccTaskBatch_Test {
    @IsTest
    public static void verifyTaskBatch() {
        TestDataFactory.createdProduct(1, 0, 0, 0);
        List<Task>  emptyList = [SELECT WhatId FROM Task];
        Test.startTest();
        AccountTaskBatch atb = new AccountTaskBatch();
        Id batchId = Database.executeBatch(atb);
        Test.stopTest();
        List<Task> fullList = [SELECT WhatId FROM Task];
        Task newTask = [SELECT WhatId, Description FROM Task LIMIT 1];
        System.assertEquals(0, emptyList.size());
        System.assertEquals(1, fullList.size());
        System.assertEquals('Call client and reminder in 5 days',newTask.Description);
    }
    @IsTest
    public static void checkIfAccHasTask() {
        TestDataFactory.createdProduct(1, 1, 1, 1);
        List<Task> oneTask = [SELECT WhatId FROM Task];
        Test.startTest();
        AccountTaskBatch atb = new AccountTaskBatch();
        Id batchId = Database.executeBatch(atb);
        Test.stopTest();
        List<Task> StillOneTask = [SELECT WhatId FROM Task];
        System.assertEquals(oneTask.size(), StillOneTask.size());
    }
}