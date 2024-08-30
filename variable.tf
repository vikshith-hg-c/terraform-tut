variable "ec2_users"{
  description = "all users of ec2"
  type = set(string)
  default = ["abc", "ehg", "hij"]
}

