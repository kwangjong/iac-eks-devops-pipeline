output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "tgw_id" {
  value = aws_ec2_transit_gateway.tgw.id
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "bastion_instance_id" {
  value = aws_instance.bastion.id
}