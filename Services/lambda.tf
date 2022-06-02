data "archive_file" "zip_lambda_1" {
  for_each    = var.lambda_funtions
  type        = "zip"
  source_dir  = "${path.module}/function/${each.value}"
  output_path = "${path.module}/function/${each.value}/${each.value}.zip"
}

resource "aws_lambda_function" "lambda_func" {
  for_each      = var.lambda_funtions
  filename      = "${path.module}/function/${each.value}/${each.value}.zip"
  function_name = each.value
  role          = aws_iam_role.poc_iam_for_lambda.arn
  source_code_hash = filebase64sha256("${path.module}/function/${each.value}/${each.value}.zip")
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
    tags ={
    type= "Spring"
  }
}


resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  bucket = aws_s3_bucket.POC_Spring.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_func["lambda1"].arn
    events              = ["s3:ObjectCreated:*"]
    
  }
}

resource "aws_lambda_permission" "test" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_func["lambda1"].function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${aws_s3_bucket.POC_Spring.id}"
}
