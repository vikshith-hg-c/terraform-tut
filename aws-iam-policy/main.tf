
resource "aws_iam_user" "test_user" {
  name = "Test-Terraform-User"
}
resource "aws_iam_access_key" "access_key" {
  user = aws_iam_user.test_user.name
}


resource "aws_iam_user_policy" "instanceManageUser_assume_role" {
  name = "InstanceManagePolicy"
  user = "${aws_iam_user.test_user.name}"
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
    ]
  })
}

output "secret_key" {
  value = aws_iam_access_key.access_key.secret
  sensitive = true
}

output "access_key" {
  value = aws_iam_access_key.access_key.id
}