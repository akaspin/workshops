variable "route53_zone" {
  description = "Base Route53 zone without trailing dot"
  default = ""
}

variable "route53_names" {
  description = "Names to register in Route53"
  type = "list"
  default = []
}

variable "eb_hosted_zone" {
  type = "map"
  default = {
    "us-east-1" = "Z117KPS5GTRQ2G"
  }
}