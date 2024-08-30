resource "aws_vpc" "main" {
  cidr_block = "172.16.0.0/16"
  tags = {
    Name = "tf-test"
  }
}

resource "aws_subnet" "subnet1" {
  
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "public_subnet"
  }
}

resource "aws_iam_user" "ec2_users" {
  for_each = var.ec2_users
  name = each.value
  tags = {
    tag-key = each.value
  }
}



