# --- ec2ecrrole/outputs.tf ---

output "profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}