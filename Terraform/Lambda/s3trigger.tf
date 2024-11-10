provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["/Users/rajeshwarreddysirigada/.aws/credentials"]
}

resource "aws_lambda_function" "s3_lambda_trigger" {
  function_name = "s3_time_catz"
  role          = "arn:aws:iam::058264186519:role/lambdaexecutionrole"
  architectures = ["x86_64"]
  runtime       = "python3.12"
  handler       = "s3_code.lambda_handler"
  filename      = "${path.module}/python_code/s3_code.zip"
  timeout       = 10
}

data "archive_file" "zip_code" {
  type        = "zip"
  source_dir  = "${path.module}/python_code/"
  output_path = "${path.module}/python_code/s3_code.zip"
}