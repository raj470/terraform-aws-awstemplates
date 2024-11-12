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


resource "aws_lambda_permission" "s3_invoke" {
  statement_id = "AWSLambdaInvokeFromS3"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_lambda_trigger.arn
  principal = "s3.amazonaws.com"
  source_arn = aws_s3_bucket.s3_deploy.arn
}

resource "aws_s3_bucket_notification" "bucket_notifications" {
  bucket = aws_s3_bucket.s3_deploy.id
  lambda_function {
    events = ["s3:ObjectCreated:*"]
    lambda_function_arn = aws_lambda_function.s3_lambda_trigger.arn
  }
  depends_on = [ aws_lambda_permission.s3_invoke ]
}

# resource "aws_lambda_event_source_mapping" "s3_bucket_mapping" {
#   event_source_arn = data.aws_s3_bucket.existing_bucket.arn
#   function_name = aws_lambda_function.s3_lambda_trigger.function_name
# }

resource "aws_s3_bucket" "s3_deploy" {
  # (resource arguments)
  bucket = "testqwertzasd-btk"
}

# data "aws_s3_bucket" "existing_bucket" {
#   bucket = "bucket123cross"
# }

output "function_name" {
  value = aws_lambda_function.s3_lambda_trigger.arn
 
}

output "existing_bucket" {
  value = aws_s3_bucket.s3_deploy.arn
}