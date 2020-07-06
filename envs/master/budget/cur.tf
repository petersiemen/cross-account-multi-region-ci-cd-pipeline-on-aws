
resource "aws_s3_bucket" "daily-report" {
  provider = aws.us-east-1
  bucket = "homepage-master-cost-and-usage-report"
  force_destroy = true
  versioning {
    enabled = true
  }
   policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
              "Service": "billingreports.amazonaws.com"
            },
            "Action": ["s3:GetBucketAcl", "s3:GetBucketPolicy"],
            "Resource": "arn:aws:s3:::homepage-master-cost-and-usage-report"
        },
        {
            "Effect": "Allow",
            "Principal": {
              "Service": "billingreports.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::homepage-master-cost-and-usage-report/*"
        }
    ]
}
EOF
}


resource "aws_cur_report_definition" "daily-report" {
  provider = aws.us-east-1
  report_name = "daily-report"
  time_unit = "HOURLY"
  format = "textORcsv"
  compression = "GZIP"
  additional_schema_elements = [
    "RESOURCES"]
  s3_bucket = aws_s3_bucket.daily-report.bucket
  s3_region = "us-east-1"
  additional_artifacts = [
    "REDSHIFT",
    "QUICKSIGHT"]
}
