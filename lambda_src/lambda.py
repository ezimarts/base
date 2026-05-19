import json
import boto3
import os

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["TABLE_NAME"])

def lambda_handler(event, context):
    body = json.loads(event.get("body", "{}"))

    user_id = body.get("user_id")
    name = body.get("name")

    table.put_item(
        Item={
            "user_id": user_id,
            "name": name
        }
    )

    return {
        "statusCode": 200,
        "body": json.dumps("Item inserted successfully")
    }