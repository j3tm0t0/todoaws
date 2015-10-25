AWS = require 'aws-sdk'
docClient = new AWS.DynamoDB.DocumentClient()

exports.handler = (event, context) ->
    
  if event.todoId
    return context.fail "todoId cannot not be specified"
  else
    uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c)->
      r = Math.random()*16|0
      v = if c is 'x' then r else (r&0x3|0x8)
      v.toString(16)
    
    item = event
    item.todoId = uuid
    item.createdAt = Math.floor(new Date/1000)
    item.finishedAt = 0
    param =
      TableName: 'todos'
      Item: item
  
  docClient.put param, (err,data)->
    if err
      context.fail err
    else
      context.succeed item
  return
