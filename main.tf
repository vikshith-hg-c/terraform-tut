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
 
}

resource "aws_iam_access_key" "access_key" {
  for_each = var.ec2_users
  user = each.value
}

resource "aws_iam_user_policy" "instanceManageUser_assume_role" {
  for_each = var.ec2_users
  name = "InstanceManagePolicy-${each.key}"
  user = each.value
      policy = templatefile("${path.module}/user-policy.tftpl", {
      ec2_policies = [
      "ec2:RunInstances",
      "ec2:StopInstances",
      "ec2:StartInstances",
      "ec2:TerminateInstances",
      "ec2:TerminateInstances",
      "ec2:Describe*",
      "ec2:CreateTags",
      "ec2:RequestSpotInstances"
    ]})
  } 
  
resource "aws_instance" "new_instance" {
  ami = "ami-02b49a24cfb95941c"
  instance_type = "t2.large"
  tags = {
    "Name" = "new_instance"
  }
}

resource "aws_s3_bucket" "test-bucket-vikshith" {
  bucket = "test-bucket-vikshith"

  tags = {
    Name        = "test-bucket-vikshith"
  }
}
resource "aws_s3_bucket_ownership_controls" "test-bucket-vikshith" {
  bucket = aws_s3_bucket.test-bucket-vikshith.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [aws_s3_bucket_ownership_controls.test-bucket-vikshith]

  bucket = aws_s3_bucket.test-bucket-vikshith.id
  acl    = "private"
}

locals {
  inbound_rules = [
    {
      port = 80,
      description = "http"
    },
     {
      port = 443,
      description = "https"
    },
     {
      port = 9090,
      description = "prom"
    },
     {
      port = 3000,
      description = "grafana"
    }]
  outbound_rules = [
    {
      port = 80,
      description = "web"
    },
    {
      port = 443,
      description = "http"
    },
    {
      port = 1433,
      description = "DB"
    }
  ]
}

resource "aws_security_group" "allow" {
  name        = "allow web server"
  description = "Allow ssh inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "webserver"
  }
  dynamic "ingress" {
    for_each = local.inbound_rules
    content {
      from_port = ingress.value.port
      to_port = ingress.value.port
      description = ingress.value.description
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
    }
  }
  dynamic "egress" {
    for_each = local.outbound_rules
    content {
      from_port = egress.value.port
      to_port = egress.value.port
      description = egress.value.description
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
  
    }
  }
}

resource "null_resource" "null_resource" {
  triggers = {
    id = timestamp()
  }
  provisioner "local-exec" {
    command = "echo hi"
  }
}

data "aws_security_group" "firewall_rules" {
  filter {
    name = "tag:Name"
    values = [ "webserver" ]
  }
  depends_on = [ "aws_security_group.allow" ]
}

output "firewall_rules_import" {
  value = data.aws_security_group.firewall_rules
}



