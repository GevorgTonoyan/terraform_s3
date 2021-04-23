variable "region" {
  type        = string
  description = "default aws region"
  default = "eu-central-1"
}

variable "environment" {
  type        = string
  description = "Environment name to create."
  default =  "dev"
}

