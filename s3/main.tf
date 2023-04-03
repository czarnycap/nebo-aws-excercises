resource "aws_s3_bucket" "nebo_bucket" {
  bucket = "nebo-bucket-1"

  object_lock_configuration {
    object_lock_enabled = "Enabled"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  replication_configuration {
    role = "arn:aws:iam::123456789012:role/replication-role"

    rules {
      id          = "example-rule"
      status      = "Enabled"
      priority    = 1
      prefix      = "example-prefix/"
      destination {
        bucket        = "arn:aws:s3:::replication-bucket"
        storage_class = "STANDARD"
      }
    }
  }
}

