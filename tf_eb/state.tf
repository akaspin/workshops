terraform {
  required_version = "> 0.9.0"

  backend "s3" {

    //
    // KEY MUST DIFFERS FOR EACH ENVIRONMENT!!!
    //
    key    = "elasticbeanstalk/workshop/workshop.json"
    bucket = "applift-terraform-state"
    region = "us-east-1"
  }
}
