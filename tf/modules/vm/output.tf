output "instance_ids" {
  value = { for k, v in aws_instance.vm : k => v.id }
}