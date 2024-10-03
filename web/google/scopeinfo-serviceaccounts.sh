#!/bin/bash
#https://cloud.google.com/sdk/docs/scripting-gcloud
USAGE="usage:$0  -p project"

while getopts p: flag; do
  case "${flag}" in
  p) project=${OPTARG} ;;
  *) echo "${USAGE}" ;;
  esac
done
if [ -z "${project}" ]; then
  echo "${USAGE}"
  exit 1
fi
for scopesInfo in $(
    gcloud compute instances list --filter=name:"${project}" \
        --format="csv[no-heading](name,id,serviceAccounts[].email.list(),
                      serviceAccounts[].scopes[].map().list(separator=;))")
do
      IFS=',' read -r -a scopesInfoArray<<< "$scopesInfo"
      NAME="${scopesInfoArray[0]}"
      ID="${scopesInfoArray[1]}"
      EMAIL="${scopesInfoArray[2]}"
      SCOPES_LIST="${scopesInfoArray[3]}"

      echo "NAME: $NAME, ID: $ID, EMAIL: $EMAIL"
      echo ""
      IFS=';' read -r -a scopeListArray<<< "$SCOPES_LIST"
      for SCOPE in  "${scopeListArray[@]}"
      do
        echo "  SCOPE: $SCOPE"
      done
done
