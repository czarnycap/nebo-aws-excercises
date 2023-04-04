variable "s3_bucket_name" {
  description = "The name of the S3 bucket to apply the policy to."
  default = "adam1985bucket"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "ro-user" {
  name = "ro-user"
}

resource "aws_iam_user" "rw-user" {
  name = "rw-user"
}

resource "aws_iam_role" "ro-role" {
  name = "ro-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { AWS = aws_iam_user.ro-user.arn }
        Action    = "sts:AssumeRole"
      }
    ]
  })

  # Policy allowing read-only access to a specified S3 bucket via ARN
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect    = "Allow"
#         Action    = "s3:GetObject"
#         Resource  = "arn:aws:s3:::example-bucket/*"
#       }
#     ]
#   })
}

resource "aws_iam_role" "rw-role" {
  name = "rw-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { AWS = aws_iam_user.rw-user.arn }
        Action    = "sts:AssumeRole"
      }
    ]
  })

  # Policy allowing read-write access to a specified S3 bucket via ARN
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect    = "Allow"
#         Action    = "s3:GetObject"
#         Resource  = "arn:aws:s3:::example-bucket/*"
#       },
#       {
#         Effect    = "Allow"
#         Action    = "s3:PutObject"
#         Resource  = "arn:aws:s3:::example-bucket/*"
#       }
#     ]
#   })
}

# attach policy to the role
resource "aws_iam_role_policy_attachment" "ro-role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.ro-role.name
}

# attach policy to the role
resource "aws_iam_role_policy_attachment" "rw-role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.rw-role.name
}

# resource "aws_iam_user_policy_attachment" "ro-user_attachment" {
#   policy_arn = aws_iam_role_policy_attachment.ro-role_attachment.policy_arn
#   user       = aws_iam_user.ro-user.name
# }

# resource "aws_iam_user_policy_attachment" "rw-user_attachment" {
#   policy_arn = aws_iam_role_policy_attachment.rw-role_attachment.policy_arn
#   user       = aws_iam_user.rw-user.name
# }




resource "aws_s3_bucket_policy" "rw_bucket_policy" {
  bucket = var.s3_bucket_name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}/*",
          "arn:aws:s3:::${var.s3_bucket_name}"
        ]
      }
    ]
  })
}

