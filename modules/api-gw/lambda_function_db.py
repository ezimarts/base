import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Users')

def lambda_handler(event, context):

    body = json.loads(event['body'])

    table.put_item(
        Item={
            "email": body["email"],
            "firstName": body["firstName"],
            "lastName": body["lastName"],
            "phone": body["phone"]
        }
    )

    return {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": "*"
        },
        "body": json.dumps({
            "message": "User registered successfully"
        })
    }