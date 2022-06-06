resource "aws_sqs_queue" "poc_SQS_queue" {
  name                      = "poc-sqs-queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.poc_deadletter_queue.arn
    maxReceiveCount     = 2
  })
  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.poc_deadletter_queue.arn]
  })
  tags = {
    Type = "Spring_POC"
  }
}

resource "aws_sqs_queue" "poc_deadletter_queue" {
  name                      = "poc-dead-letter-queue-queue"
  delay_seconds             = 5
  max_message_size          = 262144
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  tags = {
    Type = "Spring_POC"
  }
}


resource "aws_lambda_event_source_mapping" "poc_sqs_event_mapping" {
  event_source_arn = aws_sqs_queue.poc_SQS_queue.arn
  enabled          = true
  function_name    = aws_lambda_function.lambda_func_2.function_name
  batch_size       = 1
}

