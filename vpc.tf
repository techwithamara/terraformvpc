#create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc-cidr

  tags = {
   Name = "${var.project}-vpc" 
 }
}

 #create public subnet
 resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/20"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.project}-public-subnet-1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.16.0/20"
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.project}-public-subnet-2"
  }
}

resource "aws_subnet" "public-subnet-3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.32.0/20"
  availability_zone = "us-east-1c"

  tags = {
    Name = "${var.project}-public-subnet-3"
  }
}

# create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-igw"
  }
}

# create public route table
resource "aws_route_table" "terraform-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  
  tags = {
    Name = "${var.project}-public-rt"
  }
}

# create public table association for public subnet 1
resource "aws_route_table_association" "public_subnet_1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.terraform-rt.id
}

# create public table association for public subnet 2
resource "aws_route_table_association" "public_subnet_2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.terraform-rt.id
}

# create public table association for public subnet 3
resource "aws_route_table_association" "public_subnet_3" {
  subnet_id      = aws_subnet.public-subnet-3.id
  route_table_id = aws_route_table.terraform-rt.id
}

#create private subnets
 resource "aws_subnet" "private-subnet-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.128.0/20"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.project}-private-subnet-1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.144.0/20"
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.project}-private-subnet-2"
  }
}

resource "aws_subnet" "private-subnet-3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.160.0/20"
  availability_zone = "us-east-1c"

  tags = {
    Name = "${var.project}-private-subnet-3"
  }
}

#create Elastic IP for Nat
resource "aws_eip" "nat" {
 vpc = true

  tags = {
    Name = "${var.project}-nat-eip"
  }
}

# create nat gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags = {
    Name = "${var.project}-nat-gateway"

  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

# create private route table
resource "aws_route_table" "private-subnet-1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main.id
  }
  
  tags = {
    Name = "${var.project}-private-subnet-1"
  }
}

resource "aws_route_table" "private-subnet-2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main.id
  }
  
  tags = {
    Name = "${var.project}-private-subnet-2"
  }
}

resource "aws_route_table" "private-subnet-3" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main.id
  }
  
  tags = {
    Name = "${var.project}-private-subnet-3"
  }
}

# create private table association for private subnet 1
resource "aws_route_table_association" "private_subnet_1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private-subnet-1.id
}
# create private table association for private subnet 2
resource "aws_route_table_association" "private_subnet_2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private-subnet-2.id
}

# create private table association for private subnet 3
resource "aws_route_table_association" "private_subnet_3" {
  subnet_id      = aws_subnet.private-subnet-3.id
  route_table_id = aws_route_table.private-subnet-3.id
}
