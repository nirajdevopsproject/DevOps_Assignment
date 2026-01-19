resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}
#public Subnets
resource "aws_subnet" "public" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet("10.0.0.0/16",8,count.index)
  availability_zone = element(["ap-south-1a","ap-south-1b"],count.index)
  map_public_ip_on_launch = true
}
# Private Subnets
resource "aws_subnet" "private" {
count = 2
vpc_id = aws_vpc.main.id
cidr_block = cidrsubnet("10.0.0.0/16", 8, count.index + 10)
availability_zone = element(["ap-south-1a", "ap-south-1b"], count.index)
}


# NAT Gateway for private subnet internet access
resource "aws_nat_gateway" "nat" {
allocation_id = aws_eip.nat.id
subnet_id = aws_subnet.public[0].id
}


resource "aws_eip" "nat" {
domain = "vpc"
}