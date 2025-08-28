resource "aws_s3_bucket" "remote_s3" {
  bucket = "bock-tf-test-bucket-20250826"

  tags = {
    Name        = "bock-tf-test-bucket"
    Environment = terraform.workspace
  }
}