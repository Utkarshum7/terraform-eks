terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.9.0"
    }
  }


backend "s3"{

bucket = "bock-tf-test-bucket-20250826"
key= "terraform.tfstate"
region= "us-east-2"
dynamodb_table = "bock-tf-test-table"
}
}