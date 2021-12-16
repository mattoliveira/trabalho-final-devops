terraform {
  backend "s3" {
    bucket = "base-config-341559"
    key    = "trabalho-final"
    region = "us-east-1"
  }
}