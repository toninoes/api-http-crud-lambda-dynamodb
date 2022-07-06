variable "environment" {
  type        = string
  description = "Environment Name"
}

variable "project" {
  type        = string
  description = "Project Name"
}

variable "profile" {
  type        = string
  description = "Profile name configured in .aws"
}

variable "account" {
  type        = string
  description = "Your AWS Account number"
}

variable "region" {
  type        = string
  description = "AWS region to deploy this templates"
}