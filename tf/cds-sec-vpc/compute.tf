resource "aws_security_group" "bastion" {
  name   = "sec-sg-bst"
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

resource "aws_instance" "bastion" {
  ami           = "ami-0dc44556af6f78a7b"
  instance_type = "t3.micro"

  key_name = "test-server"

  vpc_security_group_ids = [ aws_security_group.bastion.id ]

  subnet_id = aws_subnet.subnets["sec-sbn-comm-pub-a"].id
  associate_public_ip_address = true

  tags = {
    Name = "sec-ec2-bst",
    Schedule = "off-at-18"
  }
}
