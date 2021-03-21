variable "github_repository" {
  type        = string
  description = "Name of the GitHub repository in which to create secrets"
}

variable "github_username" {
  type        = string
  description = "Owner of the GitHub repository in which to create secrets"
}

variable "password" {
  type        = string
  description = "Password for the root database user"
}
