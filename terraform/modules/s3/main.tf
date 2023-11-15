resource "aws_s3_bucket" "buckets-project" {
 
  count  = length(var.bucket_names)
  bucket = "${var.project_name}-s3-${var.bucket_names[count.index]}-data"
  force_destroy = true

}

resource "aws_s3_object" "bucket-emr-config" {
  bucket = "${var.project_name}-s3-${var.bucket_names[3]}-data"
  key    = "config/"

  depends_on = [aws_s3_bucket.buckets-project]

}

resource "aws_s3_object" "bucket-emr-logs" {
  bucket = "${var.project_name}-s3-${var.bucket_names[3]}-data"
  key    = "logs/"

  depends_on = [aws_s3_bucket.buckets-project]

}

resource "aws_s3_object" "bucket-emr-config-file" {
  for_each = fileset("../python/data_processing_emr/config/", "**")
  bucket = "${var.project_name}-s3-${var.bucket_names[3]}-data"
  key    = "config/${each.value}"

  source = "../python/data_processing_emr/config/${each.value}"
  etag   = filemd5("../python/data_processing_emr/config/${each.value}")

  depends_on = [aws_s3_object.bucket-emr-config]

}

resource "aws_s3_object" "bucket-emr-config-file-bucket-names" {
  bucket = "${var.project_name}-s3-${var.bucket_names[3]}-data"
  key    = "config/bucket_names.txt"

  content = <<EOF
s3a://${var.project_name}-s3-${var.bucket_names[0]}-data
s3a://${var.project_name}-s3-${var.bucket_names[1]}-data
s3a://${var.project_name}-s3-${var.bucket_names[2]}-data
s3a://${var.project_name}-s3-${var.bucket_names[3]}-data
    EOF

  depends_on = [aws_s3_object.bucket-emr-config]

}

resource "aws_s3_object" "bucket-emr-python-file" {
  bucket = "${var.project_name}-s3-${var.bucket_names[3]}-data"
  key    = "main.py"

  source = "../python/data_processing_emr/main.py"
  etag   = filemd5("../python/data_processing_emr/main.py")

  depends_on = [aws_s3_object.bucket-emr-config]

}