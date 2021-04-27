variable "region" {
  type        = string
  description = "default aws region"
  default     = "eu-central-1"
}

variable "environment" {
  type        = string
  description = "Environment name to create."
  default     = "dev"
}

variable "account_id" {
  description = "AWS Account ID that is allowed to assume this role."
  type        = string
  default     = "12345678"
}

variable "external_id" {
  type        = string
  description = "External ID provided by third party."
  default     = "12345"
}
