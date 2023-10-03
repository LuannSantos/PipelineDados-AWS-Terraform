resource "aws_s3_bucket" "buckets-project" {
 
  count  = length(var.bucket_names)
  bucket = "${var.project_name}-s3-${var.bucket_names[count.index]}-data"
  force_destroy = true

}

