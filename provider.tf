terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.64.0"
    }
  }
  backend "s3" {
    bucket = "vikshith-tf-state" 
    key    = "003/terraform.tfstate"
    region = "ap-south-1"
  }
}

variable "access_key" {}
variable "secret_key" {}

provider "aws" {
  alias      = "ap-south-1"
  region     = "ap-south-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

