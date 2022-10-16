terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "average"

    workspaces {
      prefix = "identity-"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.33"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}
