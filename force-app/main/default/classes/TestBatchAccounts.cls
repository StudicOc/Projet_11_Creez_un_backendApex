
@isTest
private class TestBatchAccounts {

    @isTest
    static void myUnitTest() {
       
       // 1 -Create DATA - Account

       Account testAccount = TestDataFactory.createAccount('Account 1');
       // 2- Appeler le Batch - Instance 

       Test.startTest();
       UpdateAccounts batchInstanceAccounts = new UpdateAccounts();
       Database.executeBatch(batchInstanceAccounts); 
       Test.stopTest();

       //3- Vérification - Requete SOQL des Tâches associés

       List<Task> tasks = [ SELECT Id, WhatId, Status, Subject 
                             FROM Task
                             WHERE WhatId = :testAccount.Id];

       System.assertEquals(tasks.size(),1,'Tasks');

    }
}