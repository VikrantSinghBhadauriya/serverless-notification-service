resource "aws_iam_role" "poc_iam_for_lambda" {
  name = "poc_iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

managed_policy_arns=["arn:aws:iam::aws:policy/AWSLambdaExecute"]
}