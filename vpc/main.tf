resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "create-vpc-${var.env}"  #region-company-serve-env-name
  }
}

#public subnets
resource "aws_subnet" "public_subnets" {
  for_each = var.public_subnets
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value["cidr_block"]
  availability_zone = each.value["availability_zone"]

  tags = {
    Name = "create-${each.value["name"]}-${var.env}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "create-igw-${var.env}"
  }
}

# Create an Elastic IP (EIP) for the NAT Gateway
resource "aws_eip" "nat_gateway_eip" {
  for_each = var.public_subnets
  #depends_on = ["aws_internet_gateway.ocreate_igw-${var.ENV}"]
  tags = {
    Name = "create-${each.value["name"]}-${var.env}"
  }

} 


resource "aws_nat_gateway" "nat_gateway" {
  for_each = var.public_subnets
  allocation_id  = aws_eip.nat_gateway_eip[each.value["name"]].id
  subnet_id      = aws_subnet.public_subnets[each.value["name"]].id
  tags = {
    Name = "create-ngw-${each.value["name"]}-${var.env}"
  }
}


#Public routetable
resource "aws_route_table" "public-route-table" {
  for_each = var.public_subnets
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "create-${each.value["name"]}-${var.env}"
  }
}

resource "aws_route_table_association" "public-association" {
  for_each = var.public_subnets
  subnet_id      = aws_subnet.public_subnets[each.value["name"]].id
  route_table_id = aws_route_table.public-route-table[each.value["name"]].id
}

resource "aws_subnet" "private_subnets" {
  for_each = var.private_subnets
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value["cidr_block"]
  availability_zone = each.value["availability_zone"]

  tags = {
    Name = "create-${each.value["name"]}-${var.env}"
  }
}

# locals {
#   az = split("-", "foo,bar,baz")
# }

#Private route table

#Public routetable
resource "aws_route_table" "private-route-table" {
  for_each = var.private_subnets
  vpc_id = aws_vpc.main.id  
  
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway["public-${split("-", each.value["name"])[1]}"].id
  }

  tags = {
    Name = "create-${each.value["name"]}-${var.env}"
  }
}


resource "aws_route_table_association" "private-association" {
  for_each = var.private_subnets
  subnet_id      = aws_subnet.private_subnets[each.value["name"]].id
  route_table_id = aws_route_table.private-route-table[each.value["name"]].id
}


# Create a security group
resource "aws_security_group" "ocreate_sg" {
  name        = "create-sg-${var.env}"
  vpc_id      = aws_vpc.main.id

  ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["103.183.203.82/32", "49.249.11.166/32", "49.249.13.16/29"]
  }

  ingress {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["103.183.203.82/32", "49.249.11.166/32", "49.249.13.16/29"]
  }
  
  ingress {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  tags = {
    Name = "create-sg-${var.env}"
  }

}







