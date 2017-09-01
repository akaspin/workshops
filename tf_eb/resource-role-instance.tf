resource "aws_iam_instance_profile" "instance" {
  name = "elasticbeanstalk-${var.environment_name}-instance"
  role = "${aws_iam_role.instance.id}"
}

resource "aws_iam_role" "instance" {
  name = "elasticbeanstalk-${var.environment_name}-instance"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "instance_ecs" {
  role = "${aws_iam_role.instance.id}"
  policy = "${data.aws_iam_policy_document.instance_ecs.json}"
}

data "aws_iam_policy_document" "instance_ecs" {
  statement {
    effect = "Allow"
    actions = [
        "ecs:StartTask",
        "ecs:StopTask",
        "ecs:RegisterContainerInstance",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Submit*",
        "ecs:Poll",
        "ecs:DescribeContainerInstances",
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy" "instance_s3_logs" {
  role = "${aws_iam_role.instance.id}"
  policy = "${data.aws_iam_policy_document.instance_s3_logs.json}"
}

data "aws_iam_policy_document" "instance_s3_logs" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
    ]
    resources = [
      "arn:aws:s3:::elasticbeanstalk-*/resources/environments/logs/*"
    ]
  }
}

resource "aws_iam_role_policy" "instance_s3_ro_applift_deploys" {
  role = "${aws_iam_role.instance.id}"
  policy = "${data.aws_iam_policy_document.instance_s3_ro_applift_deploys.json}"
}

data "aws_iam_policy_document" "instance_s3_ro_applift_deploys" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    resources = [
      "arn:aws:s3:::applift-deploys",
      "arn:aws:s3:::applift-deploys/*"
    ]
  }
}