data "archive_file" "zip_lambda" {
  for_each    = var.lambda_funtions
  type        = "zip"
  source_dir  = "${path.module}/function/${each.value}"
  output_path = "${path.module}/function/myzip/${each.value}.zip"
}

resource "aws_lambda_function" "lambda_func_1" {
  filename         = "${path.module}/function/myzip/lambda_func_1.zip"
  function_name    = var.function_1
  role             = aws_iam_role.poc_iam_for_lambda_1.arn
  source_code_hash = data.archive_file.zip_lambda["lambda_func_1"].output_base64sha256
  handler          = "lambda_func_1.lambda_handler"
  runtime          = "python3.8"

  environment {
    variables = {
      queueName = var.queue_name
      queueURL  = aws_sqs_queue.poc_SQS_queue.url
    }
  }
}

resource "aws_lambda_function" "lambda_func_2" {
  filename         = "${path.module}/function/myzip/lambda_func_2.zip"
  function_name    = var.function_2
  role             = aws_iam_role.poc_iam_for_lambda_2.arn
  source_code_hash = data.archive_file.zip_lambda["lambda_func_2"].output_base64sha256
  handler          = "lambda_func_2.lambda_handler"
  runtime          = "python3.8"
  environment {
    variables = {
      queueURL        = aws_sqs_queue.poc_SQS_queue.url
      bucketName      = aws_s3_bucket.POC_Spring.id
      processedPrefix = var.processed_prefix
      region          = var.aws_region
    }
  }
}

resource "aws_lambda_permission" "test" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_func_1.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${aws_s3_bucket.POC_Spring.id}"
}

resource "aws_cloudwatch_log_group" "lambda_1" {
  name              = "/aws/lambda/${var.function_1}"
  retention_in_days = 90
}

resource "aws_cloudwatch_log_group" "lambda_2" {
  name              = "/aws/lambda/${var.function_2}"
  retention_in_days = 90
}
