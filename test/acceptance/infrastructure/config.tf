terraform {
  required_version = "~> 0.14.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.33"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 2.1"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }
  }
}
