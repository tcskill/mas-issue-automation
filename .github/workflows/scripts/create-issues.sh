#!/usr/bin/env bash

resp=$(curl -H "Accept: application/vnd.github+json" \
-H "Authorization: Bearer ${{ secrets.NOTIFICATION_CHECKER }} " \
https://api.github.com/notifications)


for row in $(echo "${resp}" | jq -r '.[] | @base64'); do
    type=$(echo ${row} | base64 --decode | jq -r '.subject.type' )
    repo=$(echo ${row} | base64 --decode | jq -r '.repository.full_name' )

    if [[ $type == "Release" ]] && [[ $repo == "ibm-mas/ansible-devops" ]]; then

        title=$(echo ${row} | base64 --decode | jq -r '.subject.title' )
        threadid=$(echo ${row} | base64 --decode | jq -r '.id' )

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

        curl -X "POST" "https://api.github.com/repos/tcskill/mas-issue-automation/issues" \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${{ secrets.NOTIFICATION_CHECKER }}" \
        -d "$(_issue_data)"

        curl -X PATCH \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${{ secrets.NOTIFICATION_CHECKER }}" \
        https://api.github.com/notifications/threads/${threadid}

    fi
    
done


