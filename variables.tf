variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "ap-southeast-2"
}

variable "aws_profile" {
  description = "The AWS profile to use for authentication."
  type        = string
  default     = "testing-session"
}

variable "environment" {
  description = "The environment for the deployment"
  type        = string
  default     = "testing"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "testing-k8s-cluster"
}

variable "node_instance_type" {
  description = "The instance type for the EKS worker nodes."
  type        = list(string)
  default     = ["t3.medium"]
}