output "bucket_name" {
  description = "Bucketname"
  value = aws_s3_bucket.bucket_name
}

output "aws_s3_bucket_accelerate_configuration" {
  description = "Endpoint to acces bucket"
  value = aws_s3_bucket_accelerate_configuration.bucket_transfer_acceleration
}