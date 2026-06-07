import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, PutCommand } from "@aws-sdk/lib-dynamodb";
import { randomUUID } from "crypto";

const client = new DynamoDBClient({});
const ddb = DynamoDBDocumentClient.from(client);

export const handler = async (event) => {
    try {
        const body = JSON.parse(event.body || "{}");

        if (!body.name || !body.email) {
            return {
                statusCode: 400,
                body: JSON.stringify({ message: "Name and email are required" })
            };
        }

        const user = {
            user_id: randomUUID(),
            name: body.name,
            email: body.email,
            created_at: new Date().toISOString()
        };

        await ddb.send(new PutCommand({
            TableName: "Users",
            Item: user
        }));

        return {
            statusCode: 200,
            body: JSON.stringify({
                message: "User created successfully",
                user
            })
        };

    } catch (error) {
        return {
            statusCode: 500,
            body: JSON.stringify({
                message: "Internal server error",
                error: error.message
            })
        };
    }
};