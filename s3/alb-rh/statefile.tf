terraform {
  required_version = "~> 0.11"

  # Modify the configuration accordingly
  backend "s3" {
      bucket = "lianger-dev-store"
      key = "alb-rh7.tfstate"
      encrypt = true
      region  = "us-east-1"
      dynamodb_table = "lianger-dev-store-state-lock-dynamo"
    }
  }


