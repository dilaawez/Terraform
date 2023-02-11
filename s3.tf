resource "aws_s3_bucket" "terraform_backend" {
  bucket = "tf-backend-dev-2023"


  tags = {
    "Name"        = "tf backend for dev account"
    "Environment" = "dev"
  }

  lifecycle {
    prevent_destroy = true
  }

}

resource "aws_s3_bucket_acl" "terraform-backend-acl" {
  bucket = aws_s3_bucket.terraform_backend.id
  acl    = "private"


}