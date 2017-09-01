resource "aws_security_group" "env" {
  name = "elasticbeanstalk-${var.environment_name}-env"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port = 23
    protocol = "tcp"
    to_port = 23
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  tags {
    Name = "elasticbeanstalk-${var.environment_name}-env"
  }
}