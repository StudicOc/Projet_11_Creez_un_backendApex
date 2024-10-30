global class AccountTaskScheduler implements Schedulable {
    
    // Méthode execute pour le scheduler, qui s'exécute lors de chaque exécution planifiée
    global void execute(SchedulableContext sc) {
        // Code du batch à exécuter
        UpdateAccounts batchInstanceAccounts = new UpdateAccounts();
        Database.executeBatch(batchInstanceAccounts); 

        System.debug('La tâche programmée s\'exécute !');
    }
    
    // Méthode statique pour planifier notre job chaque mois
    public static void scheduleMonthlyJob() {
        // Expression cron pour le premier lundi de chaque mois
        String cronExp = '0 0 0 ? * 2#1'; // Exécute à minuit le premier lundi de chaque mois
        String jobName = 'MonthlyScheduledJob';

        // Planifier le job en utilisant la même classe
        System.schedule(jobName, cronExp, new AccountTaskScheduler());
    }
}
