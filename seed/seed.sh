#!/usr/bin/env bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

set -euo pipefail

echo "Finding the DynamoDB table name ..."
DDB_TABLE_NAME=$(C:/Users/MikaelJohansson/source/repos/AWS/hello-app-runner-nodejs/copilot-windows svc show --json | jq -r '.variables[] | select(.name == "ITEMS_NAME") | .value')
echo "DynamoDB table name: ${DDB_TABLE_NAME}"
DATA=$(sed "s/TABLE_NAME/${DDB_TABLE_NAME}/g" < C:/Users/MikaelJohansson/source/repos/AWS/hello-app-runner-nodejs/seed/data.json)

echo "Seeding initial data to the DynamoDB table ..."
RESULT=$(aws dynamodb batch-write-item --request-items "${DATA}")
UNPROCESSED_ITEM=$(echo "${RESULT}" | jq -r '. | select(.UnprocessedItems | length > 0)')
if [[ -z "${UNPROCESSED_ITEM}" ]]; then
  echo "Done!"
else
  echo "The following items were not processed."
  echo "${RESULT}"
fi
