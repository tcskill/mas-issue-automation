# mas-issue-automation
Automation workflow for opening an issue for a repository. 


This checks unread notifications for a release of a repository.
If a release is found for that repo, then an issue is opened in 
a specified repository.  That notification is then marked as read
so it isn't processed again.

Requirement: 
   - an access token is required that has access to read notifications
    and access to create an issue.
 