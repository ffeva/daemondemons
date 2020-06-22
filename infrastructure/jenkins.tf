#---------Create and Provision Jenkins Instance--------

# Create Jenkins Instance
resource "aws_instance" "jenkins" {
  depends_on    = [aws_s3_bucket_object.key, aws_iam_instance_profile.jenkins_access_profile, aws_security_group.jenkins-sg, aws_vpc.dd_vpc]
  instance_type = var.instance_type_j
  ami           = var.ami

  # Provision Jenkins instance with ansible playbook
  user_data = file("userdata.sh")

  tags = {
    Name = "DD-Jenkins"
  }

  key_name               = var.key
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]
  iam_instance_profile   = aws_iam_instance_profile.jenkins_access_profile.id
  subnet_id              = aws_subnet.public_subnet_1.id

}


resource "aws_eip" "jenkins_eip" {
  vpc = true
}

# Associate EIP to Jenkins instance
resource "aws_eip_association" "jenkins_eip_assoc" {
  depends_on    = [aws_internet_gateway.dd_internet_gateway]
  instance_id   = aws_instance.jenkins.id
  allocation_id = aws_eip.jenkins_eip.id
}
