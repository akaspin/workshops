aws_region = "us-east-1"

application_name = "workshop"
environment_name = "workshop"

key_pair = "datalift-management-web-staging"
vpc_id = "vpc-137cfc76"
subnet_id = [
  "subnet-63b85b48"
]

elb_internet_facing = true
route53_zone = "applift.team"
route53_names = [
  "workshop"
]
elb_secure = true
elb_certificate_arn = "arn:aws:acm:us-east-1:138181548999:certificate/7d343a42-b56d-4974-a18f-fa4dbe28aa43"