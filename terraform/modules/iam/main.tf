
resource "aws_iam_policy" "s3-policy" {
  name        = "${var.project_name}-policy-s3-access"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:PutObjectTagging"
            ],
            "Resource": [
                "arn:aws:s3:::${var.bucket_name}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${var.bucket_name}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role" "iam_s3_access_role" {
  name = "${var.project_name}-iam_s3_access_role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DMSAssume",
            "Action": "sts:AssumeRole",
            "Effect": "Allow",
            "Principal": {
                "Service": "dms.amazonaws.com"
            }
        }
    ]
}
EOF

  inline_policy {
    name = aws_iam_policy.s3-policy.name

    policy = aws_iam_policy.s3-policy.policy
  }

}

