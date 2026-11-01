variable "instances" {
  description = "Names of EC2 instances to create"
  type        = set(string)
}
variable "ami_id" {
  description = "Valid AMI ID for your chosen AWS region"
  type        = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "instance_name" {
  default = "Terraform-SSM-Instance"
}
