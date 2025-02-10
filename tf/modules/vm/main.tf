resource "aws_instance" "vm" {
  for_each      = var.instances
  ami           = each.value.ami
  instance_type = each.value.instance_type
  subnet_id     = each.value.id
  key_name      = each.value.key_id

  tags = {
    Name = each.key
  }
}