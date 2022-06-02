resource "aws_sqs_queue" "poc_SQS_queue" {
  name                      = "poc-sqs-queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
#   redrive_policy            = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.terraform_queue_deadletter.arn}\",\"maxReceiveCount\":4}"

  tags= {
    Type = "Spring"
  }
}

resource "aws_lambda_event_source_mapping" "poc_sqs_event_mapping" {
  event_source_arn = aws_sqs_queue.poc_SQS_queue.arn
  enabled          = true
  function_name    = aws_lambda_function.lambda_func["lambda2"].function_name
  batch_size       = 1
}