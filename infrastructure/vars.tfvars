#-----provider-----
aws_profile = "academy2"
aws_region  = "eu-west-2"

#-------VPC--------
vpc_cidr = "10.0.0.0/16"
cidrs = {
  public1 = "10.0.1.0/24"
  public2 = "10.0.2.0/24"
}

cidr_blocks    = ["82.24.141.235/32", "86.156.53.223/32", "86.124.200.162/32", "82.24.122.149/32"]
cidr_blocks_k8 = ["82.24.141.235/32", "86.156.53.223/32", "86.124.200.162/32", "82.24.122.149/32", "172.31.0.0/16"]

zone_id = "Z07626429N74Z31VDFLI"

#--------DNS-------------
dnsprefix = "dd"
dnszone   = "academy.grads.al-labs.co.uk"

#--------Instance Default-------------
instance_type_j = "t3.large"
instance_type_a = "t2.micro"
ami             = "ami-032598fcc7e9d1c7a"
key             = "ddKey"

#-------S3 Bucket--------
s3_bucket = "daemondemons"
