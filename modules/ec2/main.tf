locals {
  staging_env = "staging"
}

resource "aws_instance" "apEc2" {
  ami           = "ami-022ce6f32988af5fa"
  instance_type = var.instance_type
  subnet_id = aws_subnet.subnet1.id
  associate_public_ip_address = true
  key_name = "mumbai"

  user_data = <<-EOF
      #!/bin/sh
      sudo apt-get update
      sudo apt install -y apache2
      sudo systemctl status apache2
      sudo systemctl start apache2
      sudo chown -R $USER:$USER /var/www/html
      sudo echo "<html><body><h1>Hello this is module-1 at instance id `curl http://169.254.169.254/latest/meta-data/instance-id` </h1></body></html>" > /var/www/html/index.html
      EOF
  vpc_security_group_ids = {
    for_each = var.sg-groups
    name = each.value
  }

}