output "role_name" {
  value       = aws_iam_instance_profile.profile-ec2.name
}

output "security_group_instance_sistema" {
  value       =  aws_security_group.sg_instance_sistema.id
}

output "target_group_sistema_443" {
  value       =  aws_alb_target_group.tg_sistema_443.name
}

output "target_group_sistema_443_arn" {
  value       =  aws_alb_target_group.tg_sistema_443.arn
}