
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

resource "aws_iam_policy" "dms-lambda-policy" {
  name        = "${var.project_name}-policy-dms-lambda-access"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "dms:StartReplicationTask",
                "dms:DescribeReplicationTasks"
            ],
            "Resource": "${var.replication_task_arn}"
        },
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:us-east-1:*:*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:us-east-1:*:log-group:/aws/lambda/${var.project_name}-lambda-dms:*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "iam_lambda_dms_access_role" {
  name = "${var.project_name}-iam_lambda_dms_access_role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            }
        }
    ]
}
EOF

  inline_policy {
    name = aws_iam_policy.dms-lambda-policy.name

    policy = aws_iam_policy.dms-lambda-policy.policy
  }

}

