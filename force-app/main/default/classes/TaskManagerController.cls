public with sharing class TaskManagerController {

    @AuraEnabled(cacheable=true)
        public static List<Task> GetUsersTasks(ID userID)
        {   
            List<Task> taskList = new List<Task>();
            return taskList = [SELECT id, OwnerId, Subject, ActivityDate, Status FROM Task WHERE OwnerId =:userID];
        }

    @AuraEnabled
    public static void CompleteTask (ID taskId)
    {
        Task taskToUpdate;
        taskToUpdate = [SELECT ID, Status FROM Task WHERE ID=:taskId];
        taskToUpdate.Status = 'Completed';
        update taskToUpdate;
    }
        
}