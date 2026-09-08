provider "aws" {
    region = "ap-south-1"
    profile = "dev"
}

 terraform {
  backend "s3" {
    bucket =  "aws-bkt-adhyay-23"
    region = "ap-south-1"
    profile = "dev"
    use_lockfile = true 
    key = "terraform.tfstate"
    shared_credentials_files = ["/root/.aws/credentials"]
  }
}

