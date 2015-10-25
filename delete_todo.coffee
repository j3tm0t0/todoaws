AWS = require 'aws-sdk'
docClient = new AWS.DynamoDB.DocumentClient()

exports.handler = (event, context) ->
  
  if event.todoId
    param =
      TableName: 'todos'
      Key:
        todoId: event.todoId
      ReturnValues: "ALL_OLD"
  else
    return context.fail "todoId is not specified"
  
  docClient.delete param, (err,data)->
    console.log err,data
    if err
      context.fail err
    else if data.Attributes
      context.succeed ""
    else
      context.fail "item not found"
  return
