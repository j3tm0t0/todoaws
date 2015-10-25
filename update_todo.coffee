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
      item = data.Item
      for key, value of event
        item[key] = value
      
      param =
        TableName: 'todos'
        Item: item
      docClient.put param, (err,data)->
        if err
          context.fail err
        else
          context.succeed item
      return
    else
      context.fail "item not found"
  return
