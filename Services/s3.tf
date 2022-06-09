resource "aws_s3_bucket" "POC_Spring" {
  bucket = var.bucket_name
  tags = {
    Name = "POC_Spring"
    type = "Spring"
  }
}

resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  bucket = aws_s3_bucket.POC_Spring.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_func_1.arn
    events              = ["s3:ObjectCreated:Put", "s3:ObjectCreated:Post"]
    filter_prefix       = "source/"
  }
}

