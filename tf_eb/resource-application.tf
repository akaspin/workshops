resource "aws_elastic_beanstalk_application" "app" {
  name = "${var.application_name}"
}

// maintenance version in "applift-deploys" S3 bucket

resource "aws_s3_bucket_object" "maintenance" {
  bucket = "applift-deploys"
  key = "elasticbeanstalk/${aws_elastic_beanstalk_application.app.name}/${aws_elastic_beanstalk_environment.app.name}/maintenance-Dockerrun.json"
  content = "${file("${path.root}/maintenance-v2.json")}"
}

resource "aws_elastic_beanstalk_application_version" "maintenance" {
  application = "${aws_elastic_beanstalk_application.app.name}"
  bucket = "${aws_s3_bucket_object.maintenance.bucket}"
  key = "${aws_s3_bucket_object.maintenance.key}"
  name = "maintenance-${aws_elastic_beanstalk_environment.app.name}"
}