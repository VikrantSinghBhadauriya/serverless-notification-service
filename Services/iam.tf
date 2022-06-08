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

resource "aws_iam_role_policy" "lambda_1" {
  name = "spring_poc_lambda_1_policy"
  role = aws_iam_role.poc_iam_for_lambda_1.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "SQS"
        Effect = "Allow"
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueUrl",
        ],
        Resource = aws_sqs_queue.poc_SQS_queue.arn
      },
      {
        Sid    = "CloudwatchLogs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "${aws_cloudwatch_log_group.lambda_1.arn}:*"
      },
    ]
  })
}

resource "aws_iam_role_policy" "lambda_func_2" {
  name = "spring_poc_lambda_2_policy"
  role = aws_iam_role.poc_iam_for_lambda_2.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
        ],
        Resource = "${aws_s3_bucket.POC_Spring.arn}/*"
      },
      {
        Sid    = "CloudwatchLogs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "${aws_cloudwatch_log_group.lambda_2.arn}:*"
      },
      {
        Sid    = "SQS"
        Effect = "Allow"
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueUrl",
          "sqs:GetQueueAttributes"
        ],
        Resource = aws_sqs_queue.poc_SQS_queue.arn
      },
    ]
  })
}

resource "aws_iam_role" "poc_iam_for_lambda_1" {
  name               = "poc_iam_for_lambda_1"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_role" "poc_iam_for_lambda_2" {
  name               = "poc_iam_for_lambda_2"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}
