data "aws_route53_zone" "app" {
  count = "${signum(length(var.route53_names))}"
  name = "${var.route53_zone}."
  private_zone = "${var.elb_internet_facing == 0 ? 1 : 0}"
}

resource "aws_route53_record" "app" {
  count = "${length(var.route53_names)}"
  name = "${element(var.route53_names, count.index)}.${var.route53_zone}"
  zone_id = "${data.aws_route53_zone.app.id}"
  type = "A"
  alias {
    evaluate_target_health = true
    name = "${aws_elastic_beanstalk_environment.app.cname}"
    zone_id = "${lookup(var.eb_hosted_zone, var.aws_region)}"
  }
}
