AWS = require 'aws-sdk'
docClient = new AWS.DynamoDB.DocumentClient()

exports.handler = (event, context) ->
  param =
    TableName: 'todos'
  
  docClient.scan param, (err,data)->
    if err
      context.fail err
    else
      context.succeed data.Items
  return
