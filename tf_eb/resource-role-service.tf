resource "aws_iam_instance_profile" "service" {
  name = "elasticbeanstalk-${var.environment_name}-service"
  role = "${aws_iam_role.service.id}"
}

resource "aws_iam_role" "service" {
  name = "elasticbeanstalk-${var.environment_name}-service"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "elasticbeanstalk.amazonaws.com"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "elasticbeanstalk"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "service_health" {
  role = "${aws_iam_role.service.id}"
  policy = "${data.aws_iam_policy_document.service_health.json}"
}

data "aws_iam_policy_document" "service_health" {
  statement {
    effect = "Allow"
    actions = [
      "elasticloadbalancing:DescribeInstanceHealth",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeTargetHealth",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:GetConsoleOutput",
      "ec2:AssociateAddress",
      "ec2:DescribeAddresses",
      "ec2:DescribeSecurityGroups",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DescribeNotificationConfigurations",
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy" "service_cloudformation" {
  role = "${aws_iam_role.service.id}"
  policy = "${data.aws_iam_policy_document.service_cloudformation.json}"
}

data "aws_iam_policy_document" "service_cloudformation" {
  statement {
    sid = "AllowCloudformationOperationsOnElasticBeanstalkStacks"
    effect = "Allow"
    actions = [
      "cloudformation:*"
    ]
    resources = [
      "arn:aws:cloudformation:*:*:stack/awseb-*",
      "arn:aws:cloudformation:*:*:stack/eb-*"
    ]
  }
}

resource "aws_iam_role_policy" "service_log_groups" {
  role = "${aws_iam_role.service.id}"
  policy = "${data.aws_iam_policy_document.service_log_groups.json}"
}

data "aws_iam_policy_document" "service_log_groups" {
  statement {
    sid = "AllowDeleteCloudwatchLogGroups"
    effect = "Allow"
    actions = [
      "logs:DeleteLogGroup",
    ]
    resources = [
      "arn:aws:logs:*:*:log-group:/aws/elasticbeanstalk*",
    ]
  }
}

resource "aws_iam_role_policy" "service_elasticbeanstalk_s3_rw" {
  role = "${aws_iam_role.service.id}"
  policy = "${data.aws_iam_policy_document.service_elasticbeanstalk_s3_rw.json}"
}

data "aws_iam_policy_document" "service_elasticbeanstalk_s3_rw" {
  statement {
    sid = "AllowS3OperationsOnElasticBeanstalkBuckets"
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::elasticbeanstalk-*",
      "arn:aws:s3:::elasticbeanstalk-*/*",
    ]
  }
}

resource "aws_iam_role_policy" "service_operations" {
  role = "${aws_iam_role.service.id}"
  policy = "${data.aws_iam_policy_document.service_operations.json}"
}

data "aws_iam_policy_document" "service_operations" {
  statement {
    sid = "AllowOperations"
    effect = "Allow"
    actions = [
      "autoscaling:AttachInstances",
      "autoscaling:CreateAutoScalingGroup",
      "autoscaling:CreateLaunchConfiguration",
      "autoscaling:DeleteLaunchConfiguration",
      "autoscaling:DeleteAutoScalingGroup",
      "autoscaling:DeleteScheduledAction",
      "autoscaling:DescribeAccountLimits",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeLoadBalancers",
      "autoscaling:DescribeNotificationConfigurations",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DescribeScheduledActions",
      "autoscaling:DetachInstances",
      "autoscaling:PutScheduledUpdateGroupAction",
      "autoscaling:ResumeProcesses",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:SuspendProcesses",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
      "cloudwatch:PutMetricAlarm",
      "ec2:AssociateAddress",
      "ec2:AllocateAddress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSnapshots",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
      "ec2:DisassociateAddress",
      "ec2:ReleaseAddress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:TerminateInstances",
      "ecs:CreateCluster",
      "ecs:DeleteCluster",
      "ecs:DescribeClusters",
      "ecs:RegisterTaskDefinition",
      "elasticbeanstalk:*",
      "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
      "elasticloadbalancing:ConfigureHealthCheck",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DescribeInstanceHealth",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:DeregisterTargets",
      "iam:ListRoles",
      "iam:PassRole",
      "logs:CreateLogGroup",
      "logs:PutRetentionPolicy",
      "rds:DescribeDBEngineVersions",
      "rds:DescribeDBInstances",
      "rds:DescribeOrderableDBInstanceOptions",
      "s3:CopyObject",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectMetadata",
      "s3:ListBucket",
      "s3:listBuckets",
      "s3:ListObjects",
      "sns:CreateTopic",
      "sns:GetTopicAttributes",
      "sns:ListSubscriptionsByTopic",
      "sns:Subscribe",
      "sns:SetTopicAttributes",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "codebuild:CreateProject",
      "codebuild:DeleteProject",
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]
    resources = [
      "*"
    ]
  }
}
