resource "aws_s3_bucket" "test_terraform_state" {
  bucket = "nishant-terraform-state-bucket-testenv" 
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

resource "aws_dynamodb_table" "test_terraform_locks" {
  name         = "nishant-terraform-state-bucket-locks-test"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"  
  attribute {
    name = "LockID"
    type = "S"
  }
}
