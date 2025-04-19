resource "aws_s3_bucket" "logs_bucket" {
  bucket = var.logs_bucket_name
}

locals {
  # eu-west-2, for other regions, check: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/enable-access-logging.html#attach-bucket-policy
  elb_account_id = "652711504416"
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "log_delivery_policy" {
  bucket = aws_s3_bucket.logs_bucket.bucket
  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "AWS": "arn:aws:iam::${local.elb_account_id}:root",
            "Service": "logdelivery.elasticloadbalancing.amazonaws.com"
        },
        "Action": "s3:PutObject",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.logs_bucket.bucket}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
      }
    ]
  }
  EOF
}