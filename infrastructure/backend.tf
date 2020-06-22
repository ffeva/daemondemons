# Add state to bucket
terraform {
  backend "s3" {
    bucket = "daemondemons"
    key    = "infrastructure/vars.tfstate"
    region = "eu-west-2"
  }
}
