terraform {
  required_version = "~> 1.3"
  backend "s3" {
    bucket         = "terraform-states"
    key            = "main.tfstate"
    region         = "us-east-1"
  }
  
}