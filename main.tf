resource "aws_s3_bucket" "Ashish_Bucket" {
  bucket = "radha.bkt"
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.Ashish_Bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.Ashish_Bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.Ashish_Bucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.Ashish_Bucket.id   
  key    = "index.html"
  source = "index.html"
  acl = "bucket-owner-full-control"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.Ashish_Bucket.id   
  key    = "error.html"
  source = "error.html"
  acl = "bucket-owner-full-control"
  content_type = "text/html"
}

resource "aws_s3_object" "profile" {
  bucket = aws_s3_bucket.Ashish_Bucket.id   
  key    = "profile.jpg"
  source = "profile.jpg"
  acl = "bucket-owner-full-control"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.Ashish_Bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket_acl.example ]
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.Ashish_Bucket.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.Ashish_Bucket.bucket}/*"
    }
  ]
}
EOF
}