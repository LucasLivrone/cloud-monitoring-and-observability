variable "aws_region" {
  description = "AWS region where the resources are going the be provisioned."
  type        = string
  default     = "us-east-1"
}

variable "monitored_ami_name" {
  description = "Name of the Golden AMI with monitoring setup created by Packer."
  type        = string
  default     = "monitored-ami"
}

variable "ami_owner" {
  description = "Filter for the AMI owner"
  type        = string
  default     = "self"
}

variable "grafana_endpoint" {
  description = "The GRAFANA_ENDPOINT value"
  type        = string
}

variable "grafana_user" {
  description = "The GRAFANA_USER value"
  type        = string
}

variable "grafana_password" {
  description = "The GRAFANA_PASSWORD value"
  type        = string
}