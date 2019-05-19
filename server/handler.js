'use strict';
const doc = require('dynamodb-doc');
const dynamo = new doc.DynamoDB();
const uuid = require('uuid');

module.exports.getTodos = async (event) => {
  return await dynamo.scan({ TableName: "elmTodo" }).promise();
};

module.exports.postTodo = async (event) => {
  console.log('Received event:', JSON.stringify(event, null, 2));
  const item = {
    Id: uuid.v1(),
    // Content: event.content,
    Content: event.body.content,
    Status: 10,
    Timestamp: Number(Math.floor(Date.now() / 1000))
  };

  const payload = {
    TableName: "elmTodo",
    Item: item
  };

  return await dynamo.putItem(payload).promise()
      .then((successMessage) => {
        return JSON.stringify(payload.Item)
    });
};

