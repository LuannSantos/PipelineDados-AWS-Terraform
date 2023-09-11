resource "aws_s3_bucket" "buckets-project" {
 
  count  = length(var.bucket_names)
  bucket = "terraform-project-9093-s3-${var.bucket_names[count.index]}-data"
  force_destroy = true

}