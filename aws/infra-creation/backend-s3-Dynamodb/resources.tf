resource "aws_s3_bucket" "terraform_state" {
   bucket = "codezippy-terraform-dev-statefile"
   lifecycle {
     prevent_destroy = false
   }
   versioning {
     enabled = true
   }
   server_side_encryption_configuration {
     rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
     }
   }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name = "terraform-dev-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
     name = "LockID"
     type = "S"
  }
}
