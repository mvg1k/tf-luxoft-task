variable "access_key" {
  description = "access key"
  type        = string
  default     = "AKIAQYP2UC7IUALQFHMS"
}

variable "secret_key" {
  description = "secret key"
  type        = string
  default     = "ZVik3TXilz69IoNuHF+sG5UBqoXa4yGSAxf1i3jF"
}

variable "instance_type" {
  description = "The type of EC2 instance"
  type        = string
  default     = "t2.micro"  # type of your instance
}

variable "ami" {
  type        = string
  default     = "ami-0889a44b331db0194"
}

variable "public_key_path" {
  description = "The path to the public SSH key"
  default     = "./id_rsa.pub"  # Замініть на шлях до вашого публічного ключа SSH
}