resource "aws_appsync_graphql_api" "api" {
  authentication_type = "API_KEY"
  name = var.name

  schema = <<EOF
type Comment {
    id: ID
	articleId: ID!
	name: String!
	content: String!
    timestamp: String!
}

enum ModelAttributeTypes {
	binary
	binarySet
	bool
	list
	map
	number
	numberSet
	string
	stringSet
	_null
}

input ModelSizeInput {
	ne: Int
	eq: Int
	le: Int
	lt: Int
	ge: Int
	gt: Int
	between: [Int]
}

input ModelIDInput {
	ne: ID
	eq: ID
	le: ID
	lt: ID
	ge: ID
	gt: ID
	contains: ID
	notContains: ID
	between: [ID]
	beginsWith: ID
	attributeExists: Boolean
	attributeType: ModelAttributeTypes
	size: ModelSizeInput
}

input ModelStringInput {
	ne: String
	eq: String
	le: String
	lt: String
	ge: String
	gt: String
	contains: String
	notContains: String
	between: [String]
	beginsWith: String
	attributeExists: Boolean
	attributeType: ModelAttributeTypes
	size: ModelSizeInput
}

input ModelCommentFilterInput {
	articleId: ModelIDInput!
	name: ModelStringInput
	and: [ModelCommentFilterInput]
	or: [ModelCommentFilterInput]
	not: ModelCommentFilterInput
}

type ModelCommentConnection {
	items: [Comment]
	nextToken: String
}

type Mutation {
	putComment(articleId: ID!, name: String!, content: String!): Comment
}

type Query {
	singleComment(id: ID!): Comment
	listComments(filter: ModelCommentFilterInput, limit: Int, nextToken: String): ModelCommentConnection
}

schema {
	query: Query
	mutation: Mutation
}
EOF
}


resource "aws_appsync_api_key" "key" {
  api_id = aws_appsync_graphql_api.api.id
}


resource "aws_dynamodb_table" "table" {
  name = var.name
  billing_mode = "PROVISIONED"
  read_capacity = 1
  write_capacity = 1
  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }
  attribute {
    name = "articleId"
    type = "S"
  }
  attribute {
    name = "timestamp"
    type = "S"
  }


  global_secondary_index {
    name = "ArticleCommentsIndex"
    hash_key = "articleId"
    range_key = "timestamp"
    write_capacity = 1
    read_capacity = 1
    projection_type = "INCLUDE"
    non_key_attributes = [
      "content",
      "name"]
  }
}


resource "aws_appsync_datasource" "table" {
  api_id = aws_appsync_graphql_api.api.id
  name = var.name
  service_role_arn = aws_iam_role.role.arn
  type = "AMAZON_DYNAMODB"

  dynamodb_config {
    table_name = aws_dynamodb_table.table.name
  }
}


resource "aws_appsync_resolver" "singleComment" {
  api_id = aws_appsync_graphql_api.api.id
  field = "singleComment"
  type = "Query"
  data_source = aws_appsync_datasource.table.name

  request_template = <<EOF
{
  "version": "2017-02-28",
  "operation": "GetItem",
  "key" : {
    "id" : $util.dynamodb.toDynamoDBJson($ctx.args.id)
   }
}
EOF

  response_template = "$utils.toJson($ctx.result)"
}

resource "aws_appsync_resolver" "putComment" {
  api_id = aws_appsync_graphql_api.api.id
  field = "putComment"
  type = "Mutation"
  data_source = aws_appsync_datasource.table.name

  request_template = <<EOF
{
    "version" : "2017-02-28",
    "operation" : "PutItem",
    "key" : {
        "id" : $util.dynamodb.toDynamoDBJson($util.autoId()),
        "timestamp": $util.dynamodb.toDynamoDBJson($util.time.nowISO8601())
    },
    "attributeValues" : $util.dynamodb.toMapValuesJson($ctx.args)
}
EOF

  response_template = "$utils.toJson($ctx.result)"
}


resource "aws_appsync_resolver" "listComments" {
  api_id = aws_appsync_graphql_api.api.id
  field = "listComments"
  type = "Query"
  data_source = aws_appsync_datasource.table.name

  request_template = <<EOF
#set( $limit = $util.defaultIfNull($context.args.limit, 10) )
#set( $ListRequest = {
  "version": "2017-02-28",
  "limit": $limit
} )
#if( $context.args.nextToken )
  #set( $ListRequest.nextToken = $context.args.nextToken )
#end
#if( $context.args.filter )
  #set( $ListRequest.filter = $util.parseJson("$util.transform.toDynamoDBFilterExpression($ctx.args.filter)") )
#end
#if( !$util.isNull($modelQueryExpression)
                        && !$util.isNullOrEmpty($modelQueryExpression.expression) )
  $util.qr($ListRequest.put("operation", "Query"))
  $util.qr($ListRequest.put("query", $modelQueryExpression))
  #if( !$util.isNull($ctx.args.sortDirection) && $ctx.args.sortDirection == "DESC" )
    #set( $ListRequest.scanIndexForward = false )
  #else
    #set( $ListRequest.scanIndexForward = true )
  #end
#else
  $util.qr($ListRequest.put("operation", "Scan"))
#end
$util.toJson($ListRequest)
EOF

  response_template = "$utils.toJson($ctx.result)"
}

