resource "aws_vpc" "mtc_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }

}

resource "aws_subnet" "mtc_public_subnet" {
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2a"

  tags = {
    "Name" = "dev_public_subnet"
  }


}

resource "aws_subnet" "mtc_private_subnet" {
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = "10.0.101.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false

  tags = {
    "Name" = "dev_private_subnet"
  }

}

resource "aws_internet_gateway" "aws_internet_gateway" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    "Name" = "dev_igw"
  }
}

resource "aws_route_table" "mtc_public_rt" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    "Name" = "dev_public_rt"
  }

}

resource "aws_route_table" "mtc_private_rt" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    "Name" = "dev_private_rt"
  }

}

resource "aws_route" "mtc_public_r" {
  route_table_id         = aws_route_table.mtc_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aws_internet_gateway.id


  depends_on = [
    aws_route_table.mtc_public_rt
  ]

}

# resource "aws_route" "mtc_private_r" {
#     route_table_id = aws_route_table.mtc_private_rt.id

# }

resource "aws_route_table_association" "mtc_route_table_association" {
  subnet_id      = aws_subnet.mtc_public_subnet.id
  route_table_id = aws_route_table.mtc_public_rt.id

}

resource "aws_security_group" "mtc_sg" {
  name        = "Allow remote connections"
  description = "Allow both SSH and RDP connections."
  vpc_id      = aws_vpc.mtc_vpc.id

  tags = {
    "Name" = "Allow remote connection"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }


}

resource "aws_key_pair" "mtckey_auth" {
  key_name   = "mtckey"
  public_key = file("/mnt/c/Users/Username/.ssh/mtckey.pub")
}

resource "aws_instance" "dev_node" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.server-ami.id
  key_name               = aws_key_pair.mtckey_auth.id
  vpc_security_group_ids = [aws_security_group.mtc_sg.id]
  subnet_id              = aws_subnet.mtc_public_subnet.id
  user_data = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }


  tags = {
    "Name" = "dev-node"
  }


  provisioner "local-exec" {
    command = templatefile("linux-ssh-config.tpl", {
        hostname = self.public_ip,
        user = "ubuntu",
        identityfile = "/.ssh/mtckey"
    }
    )

    interpreter = [
        "bash", "-c"
    ]
  
  }  


}

terraform {
  backend "s3" {
    bucket = "tf-backend-dev-2023"
    key = "backend/dev.tf"
    region = "us-east-2"
  }

}