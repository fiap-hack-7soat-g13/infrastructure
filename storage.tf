resource "aws_s3_bucket" "video" {
  bucket        = "video-fc4f90cd"
  force_destroy = true
}
resource "aws_s3_bucket" "thumbnail" {
  bucket        = "thumbnail-cd3e1d98"
  force_destroy = true
}
