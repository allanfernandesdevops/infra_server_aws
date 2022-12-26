# Creating the AWS CLoudwatch Alarm that will autoscale the AWS EC2 instance based on CPU utilization.
resource "aws_cloudwatch_metric_alarm" "sistema_cpu_alarm_up" {
#  depends_on = [aws_autoscaling_policy.mypolicy]
  alarm_name = "[Sistema] CPU utilization high"
  metric_name = "CPUUtilization"
  statistic = "Average"
  namespace = "AWS/EC2"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold = "75"
  evaluation_periods = "1"
  period = "60"
  alarm_actions = [var.scale_up_arn]
  dimensions = {
    AutoScalingGroupName = var.scale_up_name
  }
}

resource "aws_cloudwatch_metric_alarm" "sistema_cpu_alarm_down" {
#  depends_on = [aws_autoscaling_policy.mypolicy]
  alarm_name = "[SISTEMA] CPU utilization low"
  metric_name = "CPUUtilization"
  statistic = "Average"
  namespace = "AWS/EC2"
  comparison_operator = "LessThanThreshold"
  threshold = "20"
  evaluation_periods = "1"
  period = "60"
  alarm_actions = [var.scale_down_arn]
  dimensions = {
    AutoScalingGroupName = var.scale_up_name
  }
}

#Autoscaling Attachment
resource "aws_autoscaling_attachment" "autoscaling_attachment" {
  lb_target_group_arn   = var.lb_tg_arn
  autoscaling_group_name = var.auto_scaling_sistema
}

### DEVOPS-314
resource "aws_cloudwatch_metric_alarm" "sistema_500" {
  alarm_name                = "[Sistema] Error rate 5XX exceeded the limit"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "HTTPCode_Target_5XX_Count"
  namespace                 = "AWS/ApplicationELB"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "5"
  alarm_description         = "Ultrapassamos os 5 erros 5XX por minuto"
  alarm_actions             = [aws_sns_topic.opsgenie_alerts.arn]
  dimensions = {
    LoadBalancer = var.lb_tg_arn
  }
}

resource "aws_cloudwatch_metric_alarm" "sis_instances_not_health" {
  alarm_name                = "[SISTEMA] Instances not healthy"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "HealthyHostCount"
  namespace                 = "AWS/ApplicationELB"
  period                    = "60"
  extended_statistic        = "p99"
  threshold                 = "1"
  alarm_description         = "Estamos com 0 instancias saudáveis em produção"
  alarm_actions             = [aws_sns_topic.opsgenie_alerts.arn]
  dimensions = {
    LoadBalancer = var.lb_tg_arn
    TargetGroup  = var.tg_name
  }
}

resource "aws_cloudwatch_metric_alarm" "sis_memory_utilization_high" {
  alarm_name                = "[SISTEMA] Memory utilization high"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "mem_used_percent"
  namespace                 = "tecnofit"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "70"
  alarm_description         = "[SISTEMA] Consumo de memória superior a 70%"
  alarm_actions             = [var.scale_up_arn, aws_sns_topic.opsgenie_alerts_p5.arn]
  dimensions = {
    #AutoScalingGroupName = var.asgName
  }
}

resource "aws_cloudwatch_metric_alarm" "sis_limit_request_per_instance_exceeded" {
  alarm_name                = "[SISTEMA] Limit request per instance exceeded"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "RequestCountPerTarget"
  namespace                 = "AWS/ApplicationELB"
  period                    = "60"
  statistic                 = "Sum"
  threshold                 = "5000"
  alarm_description         = "[SISTEMA] Limite de requests por instancias foi excedido > 5000 (Adicionando 1 nova instância)"
  alarm_actions             = [var.scale_up_arn, aws_sns_topic.opsgenie_alerts_p5.arn]
  dimensions = {
        LoadBalancer = var.lb_tg_arn
        TargetGroup  = var.tg_name
      }
}