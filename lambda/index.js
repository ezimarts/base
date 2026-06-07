const AWS = require("aws-sdk");
const db = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
  try {
    const body = JSON.parse(event.body);

    const { email, name, password } = body;

    if (!email || !name || !password) {
      return {
        statusCode: 400,
        body: JSON.stringify({ message: "Missing fields" })
      };
    }

    await db.put({
      TableName: "ezimarts_users",
      Item: {
        email,
        name,
        password,
        createdAt: new Date().toISOString()
      }
    }).promise();

    return {
      statusCode: 200,
      body: JSON.stringify({ message: "Signup successful" })
    };

  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: err.message })
    };
  }
};