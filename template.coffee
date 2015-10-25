Parameters={}
Mappings={}
Conditions={}
Resources={}
Outputs={}

fs=require 'fs'
fs.readdir 'dist', (err, files)->
  throw err if err
  code={}
  for file in files
    code[file]=fs.readFileSync 'dist/'+file, 'utf8'
    funcname = file.replace(/\.js$/,'').replace(/_(.)/g,(s)->
      s.charAt(1).toUpperCase()
      )
    Resources[funcname]=
      Type: "AWS::Lambda::Function"
      Properties:
        Handler: "index.handler"
        Role: "Fn::GetAtt":  ["LambdaExecutionRole", "Arn"]
        Code:
          ZipFile: code[file]
        Runtime: "nodejs"
        Timeout: "60"

  Resources.DynamoDB = 
    Type: "AWS::DynamoDB::Table"
    Properties:
      AttributeDefinitions: [
        {
          AttributeName: "todoId"
          AttributeType: "S" 
        }
      ]
      KeySchema: [
        {
          AttributeName : "todoId"
          KeyType : "HASH"
        }
      ]
      ProvisionedThroughput:
        ReadCapacityUnits: "1"
        WriteCapacityUnits: "1"
      TableName: "todos"

  Resources.LambdaExecutionRole =
    Type:  "AWS::IAM::Role"
    Properties:
      AssumeRolePolicyDocument:
        Version:  "2012-10-17"
        Statement:  [
          Effect:  "Allow"
          Principal: "Service": ["lambda.amazonaws.com"]
          Action:  ["sts:AssumeRole"]
        ]
      Path:  "/"
      Policies:[
        PolicyName:  "LambdaBasicExecutionPlusDynamoDB"
        PolicyDocument:
          Version:  "2012-10-17"
          Statement:  [{
            Effect:  "Allow"
            Action:  ["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"]
            Resource:  "arn:aws:logs:*:*:*"
          },
          {
            Effect:  "Allow"
            Action:  ["dynamodb:PutItem","dynamodb:GetItem","dynamodb:Scan","dynamodb:DeleteItem"]
            Resource: { "Fn::Join" : [ ":", [ "arn:aws:dynamodb",{ "Ref" : "AWS::Region" }, {"Ref" : "AWS::AccountId"}, "table/todos" ] ] }
          }]
      ]
  
  Template =
    AWSTemplateFormatVersion : "2010-09-09"

  Template.Description=Description if Description?
  Template.Parameters=Parameters if Object.keys(Parameters).length > 0
  Template.Mappings=Mappings if Object.keys(Mappings).length > 0
  Template.Conditions=Conditions if Object.keys(Conditions).length > 0
  Template.Resources=Resources if Object.keys(Resources).length > 0
  Template.Outputs=Outputs if Object.keys(Outputs).length > 0  
  console.log JSON.stringify Template,null,"  "
