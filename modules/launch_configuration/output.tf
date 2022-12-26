output "auto_scaling_group_id" {
  value       =  aws_autoscaling_group.sistema.id
}

output "auto_scaling_group_name" {
  value       =  aws_autoscaling_group.sistema.name
}

output "auto_scaling_up_cpu_policy_name" {
  value       =  aws_autoscaling_policy.levelup_cpu_policy.name
}

output "auto_scaling_down_cpu_policy_name" {
  value       =  aws_autoscaling_policy.leveldown_cpu_policy.name
}

output "auto_scaling_up_cpu_policy_arn" {
  value       =  aws_autoscaling_policy.levelup_cpu_policy.arn
}

output "auto_scaling_down_cpu_policy_arn" {
  value       =  aws_autoscaling_policy.leveldown_cpu_policy.arn
}

