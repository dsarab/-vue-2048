variable "ami" {
  description = "Value of the name for the Docker container"
  type        = string
  default     = "ami-0d71ea30463e0ff8d"
}

variable "instance_type" {
  description = "Value of the name for the Docker container"
  type        = string
  default     = "t2.micro"
}

variable "vpc_security_group_ids" {
  description = "Value of the name for the Docker container"
  type        = set(string)
  default     = ["sg-047a7f5afac407cb0"]
}

variable "key_name" {
  description = "Value of the name for the Docker container"
  type        = string
  default     = "Sinensia_ok"

}
variable "subnet_id" {
  description = "Value of the name for the Docker container"
  type        = string
  default     = "subnet-0b7cf7c1dfd0a6dbd"
}

variable "name" {
  description = "Value of the name for the Docker container"
  type        = string
  default     = "terraformInstance"
}

