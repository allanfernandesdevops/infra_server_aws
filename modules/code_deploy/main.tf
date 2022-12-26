resource "aws_codedeploy_app" "sistema" {
  name             = "sistema"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_config" "sistema" {
  deployment_config_name = "CodeDeployTec.90Porcent"

  minimum_healthy_hosts {
    type  = "FLEET_PERCENT"
    value = 90
  }
}

resource "aws_iam_role" "code_deploy" {
  name = "tec_codedeploy_service_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "code_deploy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.code_deploy.name
}

resource "aws_codedeploy_deployment_group" "sistema" {
  app_name              = "sistema"
  deployment_group_name = var.ambiente
  service_role_arn      = aws_iam_role.code_deploy.arn

//  trigger_configuration {
//    trigger_events = ["DeploymentFailure", "DeploymentSuccess", "DeploymentFailure", "DeploymentStop", "InstanceStart", "InstanceSuccess", "InstanceFailure"]
//    trigger_name       = "event-trigger"
//    trigger_target_arn = aws_sns_topic.demo_sns_topic.arn
//  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

//  alarm_configuration {
//    alarms  = ["my-alarm-name"]
//    enabled = false
//  }

  load_balancer_info {
    target_group_info {
      name = var.target_group
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  autoscaling_groups = [var.auto_scaling_sistema]
}