# Armazenando o tfstate na nuvem
terraform {
  backend "s3" {
    bucket = "aramis-aws-terraform-remote-state-dev"
    key    = "ec2/ec2provider.tfstate"
    region = "us-east-2"
  }
}




provider "aws" {
  region = "${var.region}"
}


# Buscando uma AMI na AWS
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Adicionando um security group somente acesso ao WEB
resource "aws_security_group" "SG_WEB" {
  name        = "SG_ALB"
  description = "Permitit somente acesso a WEB para o ALB"
  vpc_id      = aws_vpc.vpc_LAB.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
   ingress {
    from_port   = 80
    to_port     = 80
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



  resource "aws_instance" "EC2_LAB02"{
    ami = data.aws_ami.latest_amazon_linux.id
    instance_type = "t2.micro"
    count = "1"
    associate_public_ip_address = true
    key_name = var.instance_key_name
    subnet_id = aws_subnet.Subnet_LAB[count.index].id
    vpc_security_group_ids = [aws_security_group.SG_WEB.id]
    tags = {
    Name = var.tag
  }
}



 resource "aws_instance" "EC2_LAB02_semtag"{
    ami = data.aws_ami.latest_amazon_linux.id
    instance_type = "t2.micro"
    count = "1"
    associate_public_ip_address = true
    key_name = var.instance_key_name
    subnet_id = aws_subnet.Subnet_LAB[count.index].id
    vpc_security_group_ids = [aws_security_group.SG_WEB.id]
}


resource "aws_vpc" "vpc_LAB" {
    cidr_block =  var.network_cidr
    enable_dns_hostnames = true
}
# Criando duas subredes em zonas de disponibilidade diferentes
resource "aws_subnet" "Subnet_LAB" {
  count           = var.subnet_count
  vpc_id          = aws_vpc.vpc_LAB.id
  cidr_block      = cidrsubnet(var.network_cidr, 8, count.index)
  availability_zone = element(["us-east-2a", "us-east-2b"], count.index % 2)
}