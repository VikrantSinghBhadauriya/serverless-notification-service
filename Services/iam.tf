data "aws_iam_policy_document" "lambda_assume_role_policy" {

  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}



resource "aws_iam_role" "poc_iam_for_lambda_1" {
  name                = "poc_iam_for_lambda_1"
  assume_role_policy  = data.aws_iam_policy_document.lambda_assume_role_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AWSLambdaExecute", "arn:aws:iam::aws:policy/AmazonS3FullAccess"]
}


resource "aws_iam_role" "poc_iam_for_lambda_2" {
  name                = "poc_iam_for_lambda_2"
  assume_role_policy  = data.aws_iam_policy_document.lambda_assume_role_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AWSLambdaExecute", "arn:aws:iam::aws:policy/AmazonSQSFullAccess", "arn:aws:iam::aws:policy/AmazonS3FullAccess"]
}