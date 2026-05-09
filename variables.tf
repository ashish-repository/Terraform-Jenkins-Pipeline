variable "aws_region" {
  description = "AWS Region"
  type = string
  default = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type = string
  default = "t2.micro"
}

variable "name_tag" {
  description = "EC2 Name Tag"
  type = string
  default = "Terraform-Instance"
}

variable "key_name" {
  description = "AWS EC2 Key Pair Name"
  type = string
  default = "mumbai"
}
