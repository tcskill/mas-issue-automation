# Repository Watcher

This github workflow "watches" a repository for releases.  If a new release from the repo is found in the notifications, then an issue is opened.  The Script is a bash script that can be used on it's own as well outside of github workflows.

Requires: 
- an access token is required that has access to read notifications and access to create an issue.
- the account the access token belongs to, must subscribe to notifications from the repository it is watching

