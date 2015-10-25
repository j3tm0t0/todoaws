// Generated by CoffeeScript 1.10.0
var AWS, docClient;

AWS = require('aws-sdk');

docClient = new AWS.DynamoDB.DocumentClient();

exports.handler = function(event, context) {
  var param;
  if (event.todoId) {
    param = {
      TableName: 'todos',
      Key: {
        todoId: event.todoId
      }
    };
  } else {
    return context.fail("todoId is not specified");
  }
  docClient.get(param, function(err, data) {
    if (err) {
      return context.fail(err);
    } else if (data.Item) {
      return context.succeed(data.Item);
    } else {
      return context.fail("item not found");
    }
  });
};
