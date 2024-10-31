/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-31-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class TestSchedulerJob {

    // Expression cron attendue pour le premier lundi de chaque mois
    private static final String EXPECTED_CRON_EXP = '0 0 0 ? * 2#1';

    @isTest
    static void testSchedulerExecution() {
      
        // 1 - Création de données - Exemple avec Account
        Account testAccount = TestDataFactory.createAccount('Account 1');

        // 2 - Planifier le job en appelant la méthode de la classe à tester
        AccountTaskScheduler.scheduleMonthlyJob();

        // 3 - Récupérer l'identifiant du job programmé
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger 
                          WHERE CronExpression = :EXPECTED_CRON_EXP
                          LIMIT 1];

        // 4 - Vérifier que l'expression cron est correcte
        System.assertEquals(EXPECTED_CRON_EXP, ct.CronExpression, 
                            'L\'expression cron doit correspondre à celle du premier lundi de chaque mois.');

        // 5 - Vérifier que le job n'a pas encore été exécuté
        System.assertEquals(0, ct.TimesTriggered, 
                            'Le job ne doit pas encore avoir été exécuté.');
    }
}
