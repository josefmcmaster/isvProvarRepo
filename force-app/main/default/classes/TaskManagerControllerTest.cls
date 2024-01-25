@isTest
private class TaskManagerControllerTest 
{

    @testSetup static void setup() 
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        List<User> userList = new List<User>();
        User u = new User(Alias = 'standt', Email='isvProvarTest123@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='isvProvarTest123@testorg.com');

         userList.add(u);
            
        User u2 = new User(Alias = 'standt2', Email='isvProvarTest1234@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='isvProvarTest1234@testorg.com');

        userList.add(u2);
        insert userList;

        Task taskRecord = new Task();
        taskRecord.Priority = 'High';
        taskRecord.ActivityDate = Date.today();
        taskRecord.Subject = 'TEST TASK';
        taskRecord.OwnerId = u.Id;
        insert taskRecord;        
    }


    @isTest
    static void GetUsersTaskWhereNoTasksExist() 
    {
        User u = [SELECT ID, Email FROM User WHERE Email =: 'isvProvarTest1234@testorg.com' LIMIT 1];
        List<Task> taskList = new List<Task>();
        System.runAs(u) 
        {
            test.startTest();

            taskList = TaskManagerController.GetUsersTasks(u.Id);
            test.stopTest();
        }   

        Assert.areEqual(0, taskList.size(), 'No tasks should have been returned');

    }

    @isTest
    static void GetUsersTasksTasksExist() 
    {
        User u = [SELECT ID, Email FROM User WHERE Email =: 'isvProvarTest123@testorg.com' LIMIT 1];
        List<Task> taskList = new List<Task>();
        System.runAs(u) 
        {
            test.startTest();

            taskList = TaskManagerController.GetUsersTasks(u.Id);
            test.stopTest();
        }   

        Assert.areEqual(taskList[0].Subject, 'TEST TASK', 'The expected Task has not been returned');
    }

    @isTest
    static void CompleteTaskCorrectly() 
    {
        User u = [SELECT ID, Email FROM User WHERE Email =: 'isvProvarTest123@testorg.com' LIMIT 1];
        Task taskRecord = [SELECT ID, Status FROM Task WHERE Subject =: 'TEST TASK' LIMIT 1];
        List<Task> taskList = new List<Task>();
        test.startTest();
        System.runAs(u) 
        {

            TaskManagerController.CompleteTask(taskRecord.Id);
            
        }   

        test.stopTest();
        
        Task taskRecordResult = [SELECT ID, Status FROM Task WHERE Subject =: 'TEST TASK' LIMIT 1];
        Assert.areEqual(taskRecordResult.Status, 'Completed', 'The task has not been completed');
    }
}