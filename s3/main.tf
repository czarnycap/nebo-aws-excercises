variable "region" {}
# Define AWS provider

provider "aws" {
  region = var.region
}

resource "aws_kms_key" "nebo-key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 7
}

resource "aws_s3_bucket" "nebo-bucket-1" {
  bucket = "nebo-bucket-1"

}

resource "aws_s3_bucket_server_side_encryption_configuration" "nebo-encryption-configuration" {
  bucket = aws_s3_bucket.nebo-bucket-1.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.nebo-key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
