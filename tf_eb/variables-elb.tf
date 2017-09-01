variable "elb_internet_facing" {
  description = "Expose ELB"
  default = 0
}

variable "elb_secure" {
  description = "Use secure ELB scheme"
  default = 0
}

variable "elb_certificate_arn" {
  description = "SSL Certificate ARN"
  default = ""
}

variable "elb_secure_instance_port" {
  description = "Instance port for HTTPS"
  default = 8443
}