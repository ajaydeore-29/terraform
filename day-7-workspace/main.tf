resource "random_id" "random_id" {
    byte_length = 8
}

resource "aws_s3_bucket" "s3" {
    bucket = "demo-bucket-${terraform.workspace}-${random-id.random-id.hex}"
    tags = {
        Name = "demo_bucket-${terraform.workspace}"

    }
}