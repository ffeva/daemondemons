#------------IAM ROLES----------------

# Create Jenkins access role profile

resource "aws_iam_instance_profile" "jenkins_access_profile" {
  name = "DDJenkinsAccessProfile"
  role = aws_iam_role.jenkins_access_role.name
}

# Create Jenkins role policy

resource "aws_iam_role_policy" "jenkins_access_policy" {
  name = "DDJenkinsAccessPolicy"
  role = aws_iam_role.jenkins_access_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
  {
    "Effect": "Allow",
    "Action":[
        "s3:*",
        "ec2:*",
        "iam:*",
        "rds:*",
        "elasticloadbalancing:*",
        "autoscaling:*"
            ],
    "Resource": "*"
        }
    ]
}
EOF
}

# Create Jenkins access role

resource "aws_iam_role" "jenkins_access_role" {
  name = "DDJenkinsAccessRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
  {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
  },
      "Effect": "Allow",
      "Sid": ""
      }
    ]
}
EOF
}


# Create instance S3 access role profile

resource "aws_iam_instance_profile" "s3_access_profile" {
  name = "DDS3AccessProfile"
  role = aws_iam_role.s3_access_role.name
}

# Create instance role policy

resource "aws_iam_role_policy" "s3_access_policy" {
  name = "DDS3AccessPolicy"
  role = aws_iam_role.s3_access_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action":[
          "s3:*",
          "ec2:*"
          ],
      "Resource": "*"
    }
  ]
}
EOF
}

# Create instance S3 access role attached to instance

resource "aws_iam_role" "s3_access_role" {
  name = "DDS3AccessRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
  {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
  },
      "Effect": "Allow",
      "Sid": ""
      }
    ]
}
EOF
}

# Create K8 Cluster access role profile

resource "aws_iam_instance_profile" "k8cluster_access_profile" {
  name = "DDK8ClusterAccessProfile"
  role = aws_iam_role.k8cluster_access_role.name
}

# Create K8 Cluster role policy

resource "aws_iam_role_policy" "k8cluster_access_policy" {
  name = "DDK8ClusterAccessPolicy"
  role = aws_iam_role.k8cluster_access_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
  {
    "Effect": "Allow",
    "Action":[
        "s3:*",
        "ec2:*",
        "iam:*",
        "rds:*",
        "elasticloadbalancing:*",
        "autoscaling:*"
            ],
    "Resource": "*"
        }
    ]
}
EOF
}

# Create K8 Cluster access role attached to instance

resource "aws_iam_role" "k8cluster_access_role" {
  name = "DDK8ClusterAccessRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
  {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
  },
      "Effect": "Allow",
      "Sid": ""
      }
    ]
}
EOF
}
