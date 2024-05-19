resource "aws_iam_policy" "s3_bucket_policy" {
  name        = "${var.bucket_name}-bucket-policy"
  description = "Allow "
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "arn:aws:s3:::${var.bucket_name}"
        ]
      }
    ]
  })
}


resource "aws_iam_role" "ec2_role" {
  name = "${var.instance_name}-ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}


resource "aws_iam_role_policy_attachment" "cloud_watch_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}


resource "aws_iam_role_policy_attachment" "s3_bucket_role_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_bucket_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.instance_name}-profile"
  role = aws_iam_role.ec2_role.name
}