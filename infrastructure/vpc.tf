#----------------------Create VPC---------------------#

resource "aws_vpc" "dd_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_classiclink   = false
  tags                 = var.tags_vpc
}

#-------------------Create Internet Gateway-------------#

resource "aws_internet_gateway" "dd_internet_gateway" {
  vpc_id = aws_vpc.dd_vpc.id
  tags   = var.tags_intgw
}

#------------------Create Route Tables----------------#

# Public Route Table
resource "aws_route_table" "dd_public_rt" {
  vpc_id = aws_vpc.dd_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dd_internet_gateway.id
  }
  tags = var.tags_public-rt
}

# Private Route Table
resource "aws_default_route_table" "dd_private_rt" {
  default_route_table_id = aws_vpc.dd_vpc.default_route_table_id
  tags                   = var.tags_private-rt
}

#-------------------Create Subnets--------------------#

# Public Subnet 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.dd_vpc.id
  cidr_block              = var.cidrs["public1"]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags                    = var.tags_public-subnet1
}

# Public Subnet 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.dd_vpc.id
  cidr_block              = var.cidrs["public2"]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags                    = var.tags_public-subnet2
}

#----------------Create Subnet Associations---------------#

# Public Subnet 1 Association with Public Route Table
resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.dd_public_rt.id
}

# Public Subnet 2 Association with Public Route Table
resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.dd_public_rt.id
}
