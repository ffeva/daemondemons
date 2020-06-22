#------provider-------
variable "aws_region" {
  type    = string
  default = "eu-west-2"
}
variable "aws_profile" {
  type    = string
  default = "academy2"
}

# Variables used to generate SSH key
variable "key" {
  type    = string
  default = "ddKey"
}

variable "ssh_public_key_path" {
  type        = string
  default     = "secret"
  description = "Path to SSH public key directory"
}

variable "PATH_TO_PUBLIC_KEY" {
  type    = string
  default = "secret/ddKey.pub"
}

variable "PATH_TO_PRIVATE_KEY" {
  type    = string
  default = "secret/ddKey.pem"
}

variable "generate_ssh_key" {
  type    = bool
  default = true #if set to true, new SSH key is generated
}

variable "ssh_key_algorithm" {
  type        = string
  default     = "RSA"
  description = "SSH key algorithm"
}

# Define file extensions for storing key details
variable "private_key_extension" {
  type        = string
  default     = ".pem"
  description = "Private key extension"
}

variable "public_key_extension" {
  type        = string
  default     = ".pub"
  description = "Public key extension"
}

variable "tags_key" {
  type = map(string)
  default = {
    Name        = "ddKey"
    Description = "Key used by DDTeam"
    Project     = "ALAcademy2020"
    StartDate   = "20200601"
    EndDate     = "20200731"
    Team        = "Daemon Demons"
  }
}
