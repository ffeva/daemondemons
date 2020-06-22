resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.dd_vpc.id
  cidr_block        = element(var.cidrs-priv, count.index)
  availability_zone = join("", [var.aws_region, element(var.zones, count.index)])

  tags = var.user_tags

}
