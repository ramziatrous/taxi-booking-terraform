output "website_url" {
  value = "http://${aws_s3_bucket.website.website_endpoint}"
}