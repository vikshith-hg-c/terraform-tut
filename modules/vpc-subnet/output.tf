output "print_names" {
  value = [for name in var.ec2_users : name]
}