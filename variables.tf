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

variable "trusted_user_arn" {
  description = "AWS Account arn that is allowed to assume this role."
  type        = string
}

variable "external_id" {
  type        = string
  description = "External ID provided by third party."
  default     = "12345"
}
