#-----Create VPC Endpoint for S3 bucket------

resource "aws_vpc_endpoint" "private_s3_endpoint" {
  vpc_id       = aws_vpc.dd_vpc.id
  service_name = "com.amazonaws.${var.aws_region}.s3"

  route_table_ids = [aws_vpc.dd_vpc.main_route_table_id,
    aws_route_table.dd_public_rt.id,
  ]

  policy = <<POLICY
{
    "Statement": [
        {
            "Action": "*",
            "Effect": "Allow",
            "Resource": "*",
            "Principal": "*"
        }
    ]
}
POLICY
}

data "external" "pwd" {
  program = ["bash", "./getpwd"]
}

# Add key pair key to bucket
resource "aws_s3_bucket_object" "key" {
  bucket = var.s3_bucket
  key    = "${var.key}.pem"
  source = "${data.external.pwd.result.dir}/../sshKey/secret/ddKey.pem"

  etag = filemd5("${data.external.pwd.result.dir}/../sshKey/secret/ddKey.pem")
}
