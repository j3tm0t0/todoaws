AWS = require 'aws-sdk'
docClient = new AWS.DynamoDB.DocumentClient()

exports.handler = (event, context) ->
  
  if event.todoId
    param =
      TableName: 'todos'
      Key:
        todoId: event.todoId
  else
    return context.fail "todoId is not specified"
  
  docClient.get param, (err,data)->
    if err
      context.fail err
    else if data.Item
      context.succeed data.Item
    else
      context.fail "item not found"
      
  return
