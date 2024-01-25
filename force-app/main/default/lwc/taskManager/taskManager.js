import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { NavigationMixin } from 'lightning/navigation';
import GetUsersTasks from '@salesforce/apex/TaskManagerController.GetUsersTasks';
import CompleteTask from '@salesforce/apex/TaskManagerController.CompleteTask';
import Id from "@salesforce/user/Id";



export default class TaskManager extends NavigationMixin(LightningElement)
{

    userId = Id;
    tasks;
    error;
    wiredTasksResult;

    columns = [
        { label: 'Subject', fieldName: 'Subject', type: 'text', sortable: true },
        { label: 'Due Date', fieldName: 'ActivityDate', type: 'date', sortable: true },
        { label: 'Status', fieldName: 'Status', type: 'text', sortable: false },
        {
            type: 'button',
            typeAttributes:
            {
                iconName: 'utility:approval',
                label: 'Complete',
                name: 'completeRecord',
                title: 'completeTitle',
                disabled: { fieldName: 'isCompleted' },
                value: 'test'
            }
        }
    ];

//Retrieves the Contacts
    @wire(GetUsersTasks, { userID: '$userId' })
    wiredContacts(result) {
        this.wiredTasksResult = result;
        if (result.data) {
            console.log('DATA: ' + JSON.stringify(result.data));
            this.records = result.data;
            this.tasks = this.records.map(row => ({
                ...row,
                isCompleted: row.Status === 'Completed'
            }));
            this.error = undefined;

        } else if (result.error) {
            this.error = result.error;
            this.tasks = undefined;

        }
    }

    renderedCallback() {
        refreshApex(this.wiredTasksResult);
    }

//Will retrieve the Task ID using the row that the button was clicked on and sets the Status to 'Complete. The data is then refreshed so the button becomes disabled.
    handleRowAction(event) {
        const recId = event.detail.row.Id;

        CompleteTask({ taskId: recId })
            .then(data => {

                console.log('Task UPDATED');
                const event = new ShowToastEvent({
                    title: 'Task Complete',
                    message:
                        'Task has been completed successfully.',
                    variant: 'success',
                });
                this.dispatchEvent(event);
                refreshApex(this.wiredTasksResult);
            })
            .catch(error => {
                console.log('ERROR WHEN UPDATING TASK');
                console.log(error);
                console.log(JSON.stringify(error));
                const event = new ShowToastEvent({
                    title: 'Task Error',
                    message:
                        'Task has not been completed successfully.',
                    variant: 'error',
                });
                this.dispatchEvent(event);
            })

    }


//Takes User to the Create new Task page
    handleNavigateToNewTask() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Task',
                actionName: 'new'
            }
        });
    }

}