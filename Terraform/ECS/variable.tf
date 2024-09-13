variable "multiple_tags" {
  description = "A map of common tags to specific resource"
  type        = map(string)
  default = {
    "Key_pair"    = "ssh-keygen"
    "Enivronment" = "Dev"
    "ASG-tag"     = "prov-tf-ASG"
  }
}
variable "availability_zone" {
  description = "Defining availability_zone"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
}