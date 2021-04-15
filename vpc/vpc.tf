# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

# AWS VPC
resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    "Name" = "${var.name}-vpc"
  }

}

# AWS Subnets
resource "aws_subnet" "publicsubnets" {
  count = var.subnets
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block,8,count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    "Name" = "${var.name}-public-${count.index}"
  }
}

resource "aws_subnet" "privatesubnets" {
  count = var.subnets
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block,8,count.index+10)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    "Name" = "${var.name}-private-${count.index}"
  }
}

resource "aws_subnet" "dbsubnets" {
  count = var.subnets
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block,8,count.index+20)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    "Name" = "${var.name}-db-${count.index}"
  }
}

resource "aws_internet_gateway" "gw" {
  depends_on = [aws_vpc.main]
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_eip" "eip" {
  vpc = true
  tags = {
    Name = "${var.name}-eip"
  }
}

resource "aws_nat_gateway" "natgw" {
  depends_on = [aws_eip.eip]
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.publicsubnets[0].id
  tags = {
    Name = "${var.name}-natgw"
  }
}

resource "aws_route_table" "publicRouteTable" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "${var.name}-publicRouteTable"
  }
}

resource "aws_route_table_association" "publicRouteTableAssociation" {
  count = 3
  route_table_id = aws_route_table.publicRouteTable.id
  subnet_id = aws_subnet.publicsubnets[count.index].id
}

resource "aws_route_table" "privateRouteTable" {
  depends_on = [aws_nat_gateway.natgw]
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
  tags = {
    Name = "${var.name}-privateRouteTable"
  }
}

resource "aws_route_table_association" "privateRouteTableAssociation" {
  count = 3
  route_table_id = aws_route_table.privateRouteTable.id
  subnet_id = aws_subnet.privatesubnets[count.index].id
}

resource "aws_route_table" "dbRouteTable" {
  depends_on = [aws_nat_gateway.natgw]
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
  tags = {
    Name = "${var.name}-dbRouteTable"
  }
}

resource "aws_route_table_association" "dbRouteTableAssociation" {
  count = 3
  route_table_id = aws_route_table.dbRouteTable.id
  subnet_id = aws_subnet.dbsubnets[count.index].id
}