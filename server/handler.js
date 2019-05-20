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
        return payload.Item
    });
};

module.exports.patchTodo = async (event) => {
  console.log('Received event:', JSON.stringify(event, null, 2));
  const payload = {
    TableName: "elmTodo",
    Key: {
      Id: event.path.id
    },
    ExpressionAttributeNames: {
      '#s': 'Status',
    },
    ExpressionAttributeValues: {
      ':newStatus': event.body.status,
    },
    UpdateExpression: 'SET #s = :newStatus'
  };

  return await dynamo.updateItem(payload).promise()
};

