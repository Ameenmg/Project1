variable "region" {
  type = string
  description = "AWS region"
}

variable "bucket" {
  type = string
  description = "S3 bucket for terraform state"
}

variable "private_key" {
  type = string
  description = "Private SSH key"
}

variable "public_key" {
  type = string
  description = "Public SSH key"
}

variable "key_name" {
  type = string
  description = "AWS key pair name"
}