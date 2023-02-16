# Create a vpc 
resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dev-vpc"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "dev-gw" {
  vpc_id = aws_vpc.dev-vpc.id

  tags = {
    Name = "gw"
  }
}

# Create route table
resource "aws_route_table" "dev-rt" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.dev-gw.id
  }

  tags = {
    Name = "dev-rt"
  }
}

# Create a subnet 
resource "aws_subnet" "dev-subnet" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-1b"
  tags = {
    Name = "dev_sub"
  }
}
# Associate Subnet with Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.dev-subnet.id
  route_table_id = aws_route_table.dev-rt.id
}

# Create Security group
resource "aws_security_group" "allow-web" {
  name        = "Allow-web-traffic"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.dev-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "network-security"
  }
}

# # Create a network interface with an ip in the subnet
# resource "aws_network_interface" "web-server-nic" {
#   subnet_id       = aws_subnet.dev-subnet.id
#   private_ip      = "10.0.0.50"
#   security_groups = [aws_security_group.allow-web.id]
# }

# # Create an elastic Ip
# resource "aws_eip" "one" {
#   vpc                       = true
#   instance                  = aws_instance.terraform-server.id
#   network_interface         = aws_network_interface.web-server-nic.id
#   associate_with_private_ip = "10.0.0.50"
#   depends_on                = [aws_internet_gateway.dev-gw]
# }

# resource "aws_eip_association" "eip_assoc" {
#   instance_id   = aws_instance.terraform-server.id
#   allocation_id = aws_eip.one.id
# }