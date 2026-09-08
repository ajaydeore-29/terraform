provider "aws" {
    region = "ap-south-1"
    profile = "dev"
}

 terraform {
  backend "s3" {
    bucket =  "my_bkt_aj_1234"
    region = "ap-south-1"
    profile = "dev"
    use_lockfile = true 
    key = "terraform.tfstate"
    shared_credentials_files = ["/root/.aws/credentials"]
  }
}

