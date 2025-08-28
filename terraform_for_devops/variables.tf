#we can directly change the input here without distubing the main.tf

variable "ec2_instance_type" {
    default = "t2.micro"
    type = string 
}

variable "ec2_root_storage_size" {
          default = 10
          type = number
}

variable "ec2_ami_id" {
    default = "ami-0cfde0ea8edd312d4"
    type = string
}

# Remove this "hardcoded" env variable
# variable "env" {
#   default = "prd"
#   type = string
# }

# Instead use locals
locals {
  env = terraform.workspace
}


#variables has values which can be reused