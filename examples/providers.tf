data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

variable "aws" {
  type = any
}

terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = var.aws["region"]
}
