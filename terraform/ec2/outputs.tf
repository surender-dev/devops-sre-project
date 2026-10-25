
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "Public IPv4 address, if assigned"
  value       = aws_instance.web.public_ip
}
