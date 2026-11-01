

output "instance_public_ips" {
  value = {
    for name, instance in aws_instance.server :
    name => instance.public_ip
  }
}

output "elastic_ips" {
  value = {
    for name, eip in aws_eip.server :
    name => eip.public_ip
  }
}