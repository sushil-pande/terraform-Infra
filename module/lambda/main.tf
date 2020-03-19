resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

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
}
resource "aws_lambda_function" "lambda" {
  function_name = "LambdaExample"

  s3_bucket = "trepp-bucket-for-lambda-test"
  s3_key    = "v1.0.0/lambda.zip"

  handler = "lambda.lambda_handler"
  runtime = "python3.8"
  role = "${aws_iam_role.iam_for_lambda.arn}"
}