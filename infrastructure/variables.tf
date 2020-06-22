#------provider-------
variable "aws_region" {
  type = string
}
variable "aws_profile" {
  type = string
}

#--------VPC--------
data "aws_availability_zones" "available" {}
variable "vpc_cidr" {}
variable "cidrs" {
  type = map
}
variable "cidr_blocks" {}
variable "cidr_blocks_k8" {}
variable "zone_id" {}

#--------DNS-------------
variable "dnsprefix" {
  type = string
}

variable "dnszone" {
  type = string
}

#------Instance---------
variable "instance_type_j" {
  type = string
}
variable "instance_type_a" {
  type = string
}
variable "key" {
  type = string
}
variable "ami" {
  type = string
}

#-------S3 Bucket--------
variable "s3_bucket" {
  type = string
}

##------firewall rules for secgrp------##
variable "port_mysql" {
  type    = string
  default = "3306"
}

variable "port_ssh" {
  type    = string
  default = "22"
}

#---------------Tags-------------
variable "tags_jenkins-secgrp" {
  type = map(string)
  default = {
    Name        = "JenkinsSecurityGroup"
    Description = "Jenkins Security Group used by DDTeam"
    Project     = "ALAcademy2020"
    StartDate   = "20200601"
    EndDate     = "20200731"
    Team        = "Daemon Demons"
  }
}

variable "tags_k8cluster-secgrp" {
  type = map(string)
  default = {
    Name        = "K8ClusterSecurityGroup"
    Description = "K8 Cluster Security Group used by DDTeam"
    Project     = "ALAcademy2020"
    StartDate   = "20200601"
    EndDate     = "20200731"
    Team        = "Daemon Demons"
  }
}

variable "tags_rds-secgrp" {
  type = map(string)
  default = {
    Name        = "RDSSecurityGroup"
    Description = "RDS Security Group used by DDTeam"
    Project     = "ALAcademy2020"
    StartDate   = "20200601"
    EndDate     = "20200731"
    Team        = "Daemon Demons"
  }
}

variable "tags_vpc" {
  type = map(string)
  default = {
    Name        = "DD-VPC"
    Description = "VPC used by DDTeam"
    Project     = "ALAcademy2020"
    StartDate   = "20200601"
    EndDate     = "20200731"
    Team        = "Daemon Demons"
  }
}

variable "tags_intgw" {
  type = map(string)
  default = {
    Name        = "DDInternetGateway"
    Description = "Internet Gateway used by DDTeam"
    Project     = "ALAcademy2020"
    StartDate   = "20200601"
    EndDate     = "20200731"
    Team        = "Daemon Demons"
  }
}

variable "tags_public-rt" {
  type = map(string)
  default = {
    Name        = "DD-PublicRouteTable"
    Description = "Public Route Table of the DD-VPC"
    Project     = "ALAcademy2020"
    StartDate   = "20200601"
    EndDate     = "20200731"
    Team        = "Daemon Demons"
  }
}

variable "tags_private-rt" {
  type = map(string)
  default = {
    Name        = "DD-PrivateRouteTable"
    Description = "Private Route Table of the DD-VPC"
    Project     = "ALAcademy2020"
    StartDate   = "20200601"
    EndDate     = "20200731"
    Team        = "Daemon Demons"
  }
}

variable "tags_public-subnet1" {
  type = map(string)
  default = {
    Name        = "DD-Public-Subnet1"
    Description = "Public Subnet 1 for the DD-VPC"
    Project     = "ALAcademy2020"
    StartDate   = "20200601"
    EndDate     = "20200731"
    Team        = "Daemon Demons"
  }
}

variable "tags_public-subnet2" {
  type = map(string)
  default = {
    Name        = "DD-Public-Subnet2"
    Description = "Public Subnet 2 for the DD-VPC"
    Project     = "ALAcademy2020"
    StartDate   = "20200601"
    EndDate     = "20200731"
    Team        = "Daemon Demons"
  }
}

#--------------RDS---------------

variable "cidrs-priv" {
  description = "Private subnets cidr addresses"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "zones" {
  type    = list(string)
  default = ["a", "b"]
}

variable "snapshotid" {
  description = "snapshot id to restore"
  type        = string
  default     = null
}

variable "dbuser" {
  type    = string
  default = "DD"
}

variable "dbpassword" {
  type    = string
  default = "securedbpass123"
}

variable "dbsize" {
  type    = string
  default = "db.t2.micro"
}

variable "engine" {
  type    = string
  default = "mariadb"
}

variable "engine_version" {
  type    = string
  default = "10.2.21"
}

variable "storage" {
  type    = number
  default = 5
}

variable "dbname" {
  type    = string
  default = "daemondemons"
}

variable "monrole" {
  type    = string
  default = "ddmonitoringrole"
}

variable "monint" {
  type    = string
  default = 30
}

variable "monitoring_role_arn" {
  type    = string
  default = null
}

variable "monitor_role" {
  type    = bool
  default = true
}

variable "user_tags" {
  default = {
    Name        = "daemondemons"
    Owner       = "dd"
    Project     = "ALAcademy"
    Environment = "dev"
  }
}

variable "maj_eng_ver" {
  type    = string
  default = 10.2
}

variable "multi_az" {
  type    = bool
  default = true
}

variable "protect" {
  type    = bool
  default = false
}
