#!/usr/bin/env bash

# get the notifications for the repo
resp=$(curl -H "Accept: application/vnd.github+json" \
-H "Authorization: Bearer ${NOTIFICATION_CHECKER} " \
https://api.github.com/notifications)

# for each notification check if it's a release notification for the repo we care about
for row in $(echo "${resp}" | jq -r '.[] | @base64'); do
    type=$(echo ${row} | base64 --decode | jq -c '.subject.type' )
    repo=$(echo ${row} | base64 --decode | jq -c '.repository.full_name' )

    if [[ $type == "Release" ]] && [[ $repo == "ibm-mas/ansible-devops" ]]; then

        title=$(echo ${row} | base64 --decode | jq -c '.subject.title' )
        threadid=$(echo ${row} | base64 --decode | jq -c '.id' )

# for release notificaitons, build the data for the issue to open
        _issue_data()
        {
            cat << EOF
{
    "title": "New $repo Release: $title",
    "body": "New Release $title created in $repo",
    "labels": [
        "enhancement",
        "new release"
    ]
}
EOF
        }

# create the issue and mark notification as read
        curl -X "POST" "https://api.github.com/repos/tcskill/mas-issue-automation/issues" \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${NOTIFICATION_CHECKER}" \
        -d "$(_issue_data)"

        curl -X PATCH \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${NOTIFICATION_CHECKER}" \
        https://api.github.com/notifications/threads/${threadid}

    fi
    
done
