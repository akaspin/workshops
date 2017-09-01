variable "aws_region" {
  description = "AWS region"
}

variable "application_name" {
  description = "ElasticBeanstalk application name"
}

variable "environment_name" {
  description = "ElasticBeanstalk environment name"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "key_pair" {
  description = "Key pair name"
}

variable "subnet_id" {
  description = "List of VPC subnet IDs"
  type = "list"
}

variable "security_group_id" {
  description = "Security group IDs"
  type    = "list"
  default = []
}

variable "environment_variables" {
  type    = "map"
  default = {}
}


// System

variable "ssh_source_restriction" {
  description = "Default SSH restrictions"
  default = "tcp,22,22,0.0.0.0/0"
}


variable "solution_stack" {
  description = "ElasticBeanstalk solution stack"
  default = "64bit Amazon Linux 2017.03 v2.6.0 running Multi-container Docker 1.12.6 (Generic)"
}

variable "instance_type" {
  description = "AWS instance type"
  default = "t2.small"
}

variable "root_volume_size" {
  description = "Root volume size for instances"
  default = 8
}
