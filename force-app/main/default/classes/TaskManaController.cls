public with sharing class TaskManaController {
    public TaskManaController() {
        

    }



    @AuraEnabled
        public static List<Task> getUserTasks(ID userID)
        {   
            List<Task> taskList = new List<Task>();
            return taskList = [SELECT id, OwnerId, Subject, ActivityDate, Status FROM Task WHERE OwnerId =:userID];
        }


        @AuraEnabled
        public static void createTask(ID userID, String subject, Date dueDate, String priority)
        {
            Task newTask;

            newTask.Priority = priority;
            newTask.ActivityDate = dueDate;
            newTask.Subject = subject;
            newTask.OwnerId = userID;

            insert newTask;
        }

        @AuraEnabled
        public static void completeTask (ID taskId)
        {
            Task taskToUpdate;
            taskToUpdate = [SELECT ID, Status FROM Task WHERE ID=:taskId];
            taskToUpdate.Status = 'Completed';
            update taskToUpdate;
        }
}