#!/bin/bash
# simple deploy script for sloppy.io platform for travis-ci
#@author marc@sloppy.io

apiuri="https://api.sloppy.io/v1"
headers="Authorization:Bearer $SLOPPY_APITOKEN"

status=$(curl -s -XGET -H "Content-Type: application/json" -H "$headers" $apiuri/apps/$SLOPPY_PROJECT | jq -r .status)
jq --arg TRAVIS_COMMIT "$TRAVIS_COMMIT" ".services[].apps[].image=\"sloppy/oh-hai:$TRAVIS_COMMIT\"" $SLOPPY_FILE > deploy.json

echo "Deploy the following json:"
cat deploy.json

if [ "$status" != "error" ]; then
 echo "Change project $SLOPPY_PROJECT"
 ./sloppy change -var domain:$DOMAIN $SLOPPY_PROJECT deploy.json
 exit 0
else
 echo "Start project $SLOPPY_PROJECT"
 ./sloppy start -var domain:$DOMAIN $SLOPPY_FILE deploy.json
 exit 0
fi

exit 1

