variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "sg-groups" {
    type = list(string)
}

variable "subnet_id" {
    description = "subnet_id" 
}

