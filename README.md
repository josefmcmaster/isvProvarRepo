How to deploy GitHub sfdx project from Github to Vscode.


1) When first opening VSCode you will be shown the Welcome page, here you can select the 'Clone Git Repository...' link.
2) In the searchbox that appears at the top of the screen enter 'josefmcmaster/ISVProvarRepo' and select the item at the top of the list (the link should be: https://github.com/josefmcmaster/ISVProvarRepo.git)
3) Then you will need to find a folder to clone the git repo into.
4)  Once this has finished you are now setup to sync up your selected Dev sandbox and deploy the changes.

This should be everything that needs looking at without looking at the code. There may be a chance that the Remote Site Settings 'Open_Weather_Map' isn't active when you deploy so ensure that this has been set to active.

In terms of testing the solution there are two tasks that have been completed, the OpenWeather API which can be found on a Location__c record, and the Task Management LWC which can be found on the home page. Both LWC's may need adding to the page if they are not already showing after you have deployed the changes to your org.

OpenWeather Task:
---------------------------------------------------
On the Details tab of a Location record you should be able to see the 'weatherDisplay' LWC which will from the start will not show any data on any of the tabs.
- Create a Location record with the name of the area you are checking the longtitude and latitude for and also add values for the lat and long. Lat can only be between -90 to 90 and Long is -180 to -180. (There are validation rules that enforce this).
- Select the 'Get Weather!' Button and you will see the information linked to this location populate accordingly on the three vertical tabs on the LWC.
- If you go to the Related tab you can see that a new entry has been added which has the name of the Date and Time is was created and other useful information that was shown on the LWC.
- The 'Get Weather!' button will disable after clicking it to prevent Users from mass creating WeatherInfo records.


Task Manager Task:
---------------------------------------------------
This should be located on the Homepage.
- Firstly ensure that there are at least 3 Task records assigned to the User your are testing with.
- Now on the Homepage you should see the Tasks in a Datatable in the 'TaskManager' LWC.
- If you click the 'Complete' button in the end column it will set that Task's Status to 'Complete', refresh the table and will also disable the button so it can no longer be used as it isn't needed.
- If you click on the 'New' button in the top right of the LWC it will make a popup appear where you can create a new Task, once the Task has been created you will be navigated to the new Record's page.







   
