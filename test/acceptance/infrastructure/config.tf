terraform {
  required_version = "~> 0.12.20"
}

provider "aws" {
  version = "~> 2.47"
}

provider "http" {
  version = "~> 1.1"
}

provider "null" {
  version = "~> 2.1"
}
