import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('ezm-user-table')

def lambda_handler(event, context):

    print(event)

    method = event.get('httpMethod', '')

    # Browser GET request
    if method == 'GET':

        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Lambda API is working'
            })
        }

    # POST request
    if 'body' not in event:

        return {
            'statusCode': 400,
            'body': json.dumps({
                'error': 'Missing request body'
            })
        }

    body = json.loads(event['body'])

    table.put_item(
        Item={
            'userId': body['userId'],
            'name': body['name'],
            'email': body['email']
        }
    )

    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': 'User added successfully'
        })
    }