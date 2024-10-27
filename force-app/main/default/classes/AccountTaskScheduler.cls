global class AccountTaskScheduler implements Schedulable {
    
    // Méthode execute pour le scheduler
    global void execute(SchedulableContext sc) {
        scheduleMonthlyJob(); // Planifier le job mensuel

        UpdateAccounts batchInstanceAccounts = new UpdateAccounts();
        Database.executeBatch(batchInstanceAccounts); 

        System.debug('La tâche programmée s\'exécute !');
    }
    
    // Méthode statique pour planifier notre job
    public static void scheduleMonthlyJob() {
        // Expression cron 
        String cronExp = '0 0 0 ? * 2#1'; // Premier lundi de chaque mois
        String jobName = 'MonthlyScheduledJob';

        // Planifier notre job
        ScheduleTasksAccounts job = new ScheduleTasksAccounts();
        System.schedule(jobName, cronExp, job);
    }
}