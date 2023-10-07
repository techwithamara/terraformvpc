#variable for VPC cidr range
variable "vpc-cidr" {
 type =  string
 default = "10.0.0.0/16"

 
}

# give project a name
variable "project" {
  type = string
  default = "techwithamara"
}
