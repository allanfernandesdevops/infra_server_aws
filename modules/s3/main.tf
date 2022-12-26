resource "aws_s3_bucket" "deploy" {
  bucket = "tec-lab-artifacts-deploy"

  tags = {
    Name = "sistema-lab"
    CC = "devops"
    Environment = "lab"
    Project = "sistema"
  }
}

resource "aws_s3_bucket_acl" "bucket-acl" {
  bucket = aws_s3_bucket.deploy.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.deploy.id
  block_public_acls   = true
  block_public_policy = true
}