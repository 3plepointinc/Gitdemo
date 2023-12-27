resource "aws_s3_bucket" "mybackend" {
  bucket = "boot-${lower(var.env)}-${random_integer.mybackend.result}"
  tags = {
    Name        = "mybackend"
    Environment = "Dev"
  }
}

resource "aws_kms_key" "my_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 8
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3encrypt" {
  bucket = aws_s3_bucket.mybackend.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.my_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}


resource "random_integer" "mybackend" {
  min = 1
  max = 20
  keepers = {
    Environment = var.env
  }
}
