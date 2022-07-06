resource "aws_lambda_function" "this" {
  filename         = "src/index.zip"
  function_name    = "http-crud-tutorial-function"
  role             = aws_iam_role.this.arn
  runtime          = "nodejs16.x"
  handler          = "index.handler"
  source_code_hash = filebase64sha256("src/index.zip")
  tags             = local.tags
}

resource "aws_iam_policy" "this" {
  name = "AWSLambdaMicroserviceExecutionRole-84baa1e3-168a-4be6-8c13-bf7baef0f362"
  path = "/"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Scan",
          "dynamodb:UpdateItem"
        ],
        "Resource" : "arn:aws:dynamodb:${var.region}:${var.account}:table/*"
      },
      {
        "Effect" : "Allow",
        "Action" : "logs:CreateLogGroup",
        "Resource" : "arn:aws:logs:${var.region}:${var.account}:*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "arn:aws:logs:${var.region}:${var.account}:log-group:/aws/lambda/http-crud-tutorial-function:*"
        ]
      }
    ]
  })

  tags = local.tags
}


resource "aws_iam_role" "this" {
  name = "http-crud-tutorial-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "attach_policy_to_iam_role_mi_lambda" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

data "archive_file" "this" {
  type        = "zip"
  source_file = "src/index.js"
  output_path = "src/index.zip"
}

resource "aws_lambda_permission" "this" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}