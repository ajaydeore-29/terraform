resource "random_id" "random_id" {
    byte_lentgh = 8
}

resource "aws_s3_bucket" "s3" {
    bucket = "demo_bucket-${terraform.workspace}-${rendom_id.random_id.hex}"
    tags = {
        Name = "demo_bucket-${terraform.workspace}"
        
    }
}