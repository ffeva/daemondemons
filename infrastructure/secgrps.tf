##-------------------Jenkins Firewall------------------##

# Create security group Jenkins
resource "aws_security_group" "jenkins-sg" {
  name   = "dd-Jenkins-SecGrp"
  vpc_id = aws_vpc.dd_vpc.id
  tags   = var.tags_jenkins-secgrp
}

# Create firewall rules Jenkins
resource "aws_security_group_rule" "jenkins-sg-rule-8080" {
  from_port         = 8080
  protocol          = "tcp"
  security_group_id = aws_security_group.jenkins-sg.id
  to_port           = 8080
  type              = "ingress"
  cidr_blocks       = var.cidr_blocks_k8
}

resource "aws_security_group_rule" "jenkins-sg-rule-ssh" {
  from_port         = var.port_ssh
  protocol          = "tcp"
  security_group_id = aws_security_group.jenkins-sg.id
  to_port           = var.port_ssh
  type              = "ingress"
  cidr_blocks       = var.cidr_blocks_k8
}

resource "aws_security_group_rule" "jenkins-outbound-rule" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.jenkins-sg.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

##--------------K8 Cluster Firewall--------------##

# Create security group K8 Cluster
resource "aws_security_group" "k8cluster-sg" {
  name   = "dd-k8Cluster-SecGrp"
  vpc_id = aws_vpc.dd_vpc.id
  tags   = var.tags_k8cluster-secgrp
}

# Create firewall rules K8 Cluster
resource "aws_security_group_rule" "k8cluster-sg-rule-ssh" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.k8cluster-sg.id
  to_port           = 0
  type              = "ingress"
  cidr_blocks       = var.cidr_blocks_k8
}

resource "aws_security_group_rule" "k8cluster-outbound-rule" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.k8cluster-sg.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "k8cluster-sg-rule-mysql" {
  from_port         = var.port_mysql
  protocol          = "tcp"
  security_group_id = aws_security_group.k8cluster-sg.id
  to_port           = var.port_mysql
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

##------------------------RDS Firewall----------------------##

# Create security group RDS
resource "aws_security_group" "rds-sg" {
  name   = "dd-RDB-SecGrp"
  vpc_id = aws_vpc.dd_vpc.id
  tags   = var.tags_rds-secgrp
}

# Create firewall rules RDS
resource "aws_security_group_rule" "rds-sg-rule-mysql" {
  from_port         = var.port_mysql
  protocol          = "tcp"
  security_group_id = aws_security_group.rds-sg.id
  to_port           = var.port_mysql
  type              = "ingress"
  cidr_blocks       = var.cidr_blocks
}

resource "aws_security_group_rule" "rds-sg-rule-ssh" {
  from_port         = var.port_ssh
  protocol          = "tcp"
  security_group_id = aws_security_group.rds-sg.id
  to_port           = var.port_ssh
  type              = "ingress"
  cidr_blocks       = var.cidr_blocks
}

resource "aws_security_group_rule" "rds-outbound-rule" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.rds-sg.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}
