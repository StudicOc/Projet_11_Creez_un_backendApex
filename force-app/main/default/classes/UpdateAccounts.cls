global class UpdateAccounts implements Database.Batchable<SObject> {
    
    global Database.QueryLocator start(Database.BatchableContext info) {
        //Récupérer les accounts sans commandes associées
        return Database.getQueryLocator([
            SELECT Id, OwnerId
            FROM Account 
            WHERE Id NOT IN (SELECT AccountId FROM Order) 
        ]);
    }

    global void execute(Database.BatchableContext info, List<Account> scope) {
        List<Task> tasksToCreate = new List<Task>();

        for (Account acc : scope) {
            // Vérification d'une task existante
            List<Task> associatedTasks = [
                SELECT Id 
                FROM Task 
                WHERE WhatId = :acc.Id AND Subject = 'Call'
            ];

            if (associatedTasks.isEmpty()) {
                Task newTask = new Task(
                    Subject = 'Call',
                    Status = 'Not Started',
                    Priority = 'Normal',
                    IsReminderSet = true,
                    WhatId = acc.Id, 
                    OwnerId = acc.OwnerId, 
                    // Date d'échéance qui s'affichera sur le field "Due Date"
                    ActivityDate = Date.today() + 5 // Rappel dans 5 jours
                );
                tasksToCreate.add(newTask);
            }
        }

        if (!tasksToCreate.isEmpty()) {
            insert tasksToCreate;
        }
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('Batch terminé avec succès');
    }
}
