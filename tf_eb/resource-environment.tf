resource "aws_elastic_beanstalk_environment" "app" {
  depends_on = [
    "aws_iam_instance_profile.service",
    "aws_iam_instance_profile.instance",
  ]

  application         = "${aws_elastic_beanstalk_application.app.name}"
  name                = "${var.environment_name}"
  solution_stack_name = "${var.solution_stack}"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "${aws_iam_instance_profile.instance.name}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = "${aws_iam_instance_profile.service.name}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "${var.instance_type}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "RootVolumeType"
    value     = "gp2"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "RootVolumeSize"
    value     = "${var.root_volume_size}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = "${join(",", flatten(concat(list(aws_security_group.env.id), var.security_group_id)))}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SSHSourceRestriction"
    value     = "${var.ssh_source_restriction}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "${var.key_pair}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${var.vpc_id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "true"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${join(",", var.subnet_id)}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "${join(",", var.subnet_id)}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "${var.elb_internet_facing == 0 ? "internal" : "public"}"
  }

  setting {
    namespace = "aws:cloudformation:template:parameter"
    name      = "EnvironmentVariables"
    value     = "${join(",",
        concat(formatlist(
          "%s=%s",
          keys(var.environment_variables), values(var.environment_variables)
        ),
        list("FORCE_HTTPS=${var.elb_secure == 0 ? "false" : "true"}"))
      )}"
  }

  // secure ELB lstener

  setting {
    name = "ListenerEnabled"
    resource = "AWSEBLoadBalancer"
    namespace = "aws:elb:listener:443"
    value = "${var.elb_secure == 0 ? "false" : "true"}"
  }

  setting {
    name = "LoadBalancerHTTPSPort"
    namespace = "aws:elb:loadbalancer"
    value = "${var.elb_secure == 0 ? "OFF" : "443"}"
  }

  setting {
    name = "SSLCertificateId"
    namespace = "aws:elb:loadbalancer"
    value = "${var.elb_certificate_arn}"
  }

  setting {
    name = "InstancePort"
    resource = "AWSEBLoadBalancer"
    namespace = "aws:elb:listener:443"
    value = "${var.elb_secure_instance_port}"
  }

  setting {
    name = "InstanceProtocol"
    resource = "AWSEBLoadBalancer"
    namespace = "aws:elb:listener:443"
    value = "HTTP"
  }

  setting {
    name = "ListenerProtocol"
    resource = "AWSEBLoadBalancer"
    namespace = "aws:elb:listener:443"
    value = "HTTPS"
  }

  setting {
    name = "SSLCertificateId"
    namespace = "aws:elb:listener:443"
    value = "${var.elb_certificate_arn}"
  }
}


output "cname" {
  value = "${aws_elastic_beanstalk_environment.app.cname}"
}
