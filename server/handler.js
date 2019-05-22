'use strict';
const uuid = require('uuid');
const AWS = require('aws-sdk');
const dynamoDb = new AWS.DynamoDB.DocumentClient();

module.exports.getTasks = (event, content, callback) => {
  const params = {
    TableName: 'elmTasks',
  };

  return dynamoDb.scan(params, (error, data) => {
    if (error) {
      callback(error);
    }
    callback(error, {Items: data.Items});
  });
};

module.exports.postTask = (event, content, callback) => {
  const item = {
    Id: uuid.v1(),
    Content: event.body.content,
    Status: 10,
    Timestamp: Number(Math.floor(Date.now() / 1000))
  };


  const params = {
    TableName: "elmTasks",
    Item: item
  };

  return dynamoDb.put(params, (error, data) => {
    if (error) {
      callback(error);
    }
    callback(error, params.Item);
  });
};

module.exports.patchTask = (event, content, callback) => {
  const params = {
    TableName: "elmTasks",
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


  return dynamoDb.update(params, (error, data) => {
    if (error) {
      callback(error);
    }
    callback(error, data);
  });
};
