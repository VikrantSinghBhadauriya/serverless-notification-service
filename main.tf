resource "aws_s3_bucket" "POC_Spring" {
  bucket = "poc-spring-test-bucket"

  tags = {
    Name        = "POC_Spring"
    Environment = "Dev"
  }
}


