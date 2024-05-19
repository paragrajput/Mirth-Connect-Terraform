resource "aws_s3_bucket" "s3_bucket" {
  bucket = format("%s%s%s", var.bucket_name, "-", random_string.random.result)
  tags = {
    Name        = var.bucket_name
    Environment = var.bucket_env
  }
}