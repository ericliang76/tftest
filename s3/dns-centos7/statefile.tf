terraform {
  required_version = "~> 0.11"

  # Modify the configuration accordingly
  backend "s3" {
      bucket = "lianger-tf-store"
      key = "dns-ub.tfstate"
      encrypt = true
      region  = "us-east-1"
      dynamodb_table = "lianger-tf-store-state-lock-dynamo"
    }
  }


