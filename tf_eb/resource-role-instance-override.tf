
resource "aws_iam_role_policy" "instance_s3_rw_datalift_mgmt_development" {
  role = "${aws_iam_role.instance.id}"
  policy = "${data.aws_iam_policy_document.instance_s3_rw_datalift_mgmt_development.json}"
}

data "aws_iam_policy_document" "instance_s3_rw_datalift_mgmt_development" {
  statement {
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::datalift-mgmt-development/*"
    ]
  }
}