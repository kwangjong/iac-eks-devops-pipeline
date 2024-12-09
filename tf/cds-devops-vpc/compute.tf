# gitlab
resource "aws_security_group" "gitlab" {
  name   = "cds-devops-sg-git"
  vpc_id = aws_vpc.vpc.id
  
  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "gitlab" {
  ami           = "ami-0dc44556af6f78a7b"
  instance_type = "c5.xlarge"

  key_name = "test-server"

  vpc_security_group_ids = [ aws_security_group.gitlab.id ]

  subnet_id = aws_subnet.subnets["cds-devops-sbn-ap-pri-a"].id

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "cds-devops-ec2-git",
    Schedule = "off-at-18"
  }
}

# gitlab runner
resource "aws_security_group" "gitlab_runner" {
  name   = "cds-devops-sg-gitr"
  vpc_id = aws_vpc.vpc.id
  
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

resource "aws_instance" "gitlab_runner" {
  ami           = "ami-0dc44556af6f78a7b"
  instance_type = "t2.small"

  key_name = "test-server"

  vpc_security_group_ids = [ aws_security_group.gitlab_runner.id ]

  subnet_id = aws_subnet.subnets["cds-devops-sbn-ap-pri-a"].id

  tags = {
    Name = "cds-devops-ec2-gitr",
    Schedule = "off-at-18"
  }
}	