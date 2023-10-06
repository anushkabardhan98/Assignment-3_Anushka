# Public security group
resource "aws_security_group" "public_sg" {
  name        = "public_sg"
  description = "Public Security Group"
  vpc_id      = aws_vpc.main.id

  ingress {
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
}

# Private security group
resource "aws_security_group" "private_sg" {
  name        = "private_sg"
  description = "Private Security Group"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# For private key for three ec2 machines 
resource "aws_key_pair" "key" {
  key_name   = "my_key" 
  public_key = file("~/.ssh/id_rsa.pub") 
}

# Bastion Machine
module "bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "bastion"
  associate_public_ip_address = "true"

  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key.key_name
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  subnet_id              = aws_subnet.public1.id

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# Jenkins machine
module "jenkins" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins"
  associate_public_ip_address = "true"

  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key.key_name
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  subnet_id              = aws_subnet.private1.id

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# App Machine
module "app" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "app"
  associate_public_ip_address = "true"

  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key.key_name
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  subnet_id              = aws_subnet.private2.id

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}