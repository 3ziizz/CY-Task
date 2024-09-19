#Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "70.0.0.0/16"

  tags = {
    Name = "CY-VPC"
  }
}

# create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "CY-InternetGateway"
  }
}

# Create Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "70.0.1.0/24"
  availability_zone = "us-east-1a" 

  tags = {
    Name = "CY-PublicSubnet"
  }
}

# Create Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "70.0.2.0/24"
  availability_zone = "us-east-1a" 

  tags = {
    Name = "CY-PrivateSubnet"
  }
}

# Create a Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "CY-PublicRouteTable"
  }
}

#  Associate Public Route Table with Public Subnet
resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create a Route for Public Subnet to access the Internet
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Create Private Route Table (no internet access)
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "CY-PrivateRouteTable"
  }
}

# Associate Private Route Table with Private Subnet
resource "aws_route_table_association" "private_subnet_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_eip" "nat_eip" {
  vpc = true  # No need for network_interface, just ensure it's for VPC
}

# Create a NAT Gateway in the Public Subnet
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "CY-NATGateway"
  }
}

# Add a route to the Private Route Table to access the Internet via NAT Gateway
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}