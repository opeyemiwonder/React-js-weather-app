provider "aws" {
  # version = "~> 4.0"
  region  = "us-west-1"
    access_key = "AKIAV"
    secret_key = "8v+2CqIJ"
}

resource "aws_instance" "terraform-server" { 
  ami           = "ami-0036b4598ccd42565" 
  instance_type = "t2.micro" 
  availability_zone = "us-west-1b"
  key_name = "Hng_key"
  
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install nginx
              sudo systemctl start nginx.service
              EOF
  tags = { 
    Name = "dev-server" 
  } 
}