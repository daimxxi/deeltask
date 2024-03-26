variable "instance_type" {
  description = "The type of EC2 instance"
  default     = "t2.micro"
}

variable "ami" {
  description = "ami to use"
  default     = "ami-080e1f13689e07408"
}

variable "vault_url" {
  description = "Vault URL"
  type        = string
  default = ""
}