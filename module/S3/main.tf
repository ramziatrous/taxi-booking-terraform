resource "aws_s3_bucket" "website" {
  bucket        = var.bucket_name
  force_destroy = true
  acl           = "private"
  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name = var.bucket_name
  }

}




resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
