resource "aws_launch_configuration" "sistema" {  
  name            = "sistema-lab"
  image_id        = var.image_id
  instance_type   = var.instance_type
  associate_public_ip_address = false
  security_groups = ["${var.sg_instance_sistema}"]
  key_name        = var.key_name
  iam_instance_profile = var.role_name
}

resource "aws_autoscaling_group" "sistema" {
  depends_on                = [aws_launch_configuration.sistema]
  name                      = "autoscaling-sistema-lab"
  vpc_zone_identifier       = [var.ec2_subnets]
  launch_configuration      = aws_launch_configuration.sistema.name
  min_size                  = 2
  desired_capacity          = 2
  max_size                  = 12
  health_check_grace_period = 30
  health_check_type         = "EC2"
  force_delete              = true
  termination_policies      = ["OldestInstance"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "sistema-lab"
    propagate_at_launch = true
  }
  tag {
    key                 = "CC"
    value               = "devops"
    propagate_at_launch = true
  }
  tag {
    key                 = "Environment"
    value               = "lab"
    propagate_at_launch = true
  }
  tag {
    key                 = "Project"
    value               = "sistema"
    propagate_at_launch = true
  }
}

# Creating the autoscaling policy of the autoscaling group
resource "aws_autoscaling_policy" "levelup_cpu_policy" {
  name                   = "scale_up_policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.sistema.name
}

resource "aws_autoscaling_policy" "leveldown_cpu_policy" {
  name                   = "scale_down_policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.sistema.name
}

resource "aws_autoscaling_schedule" "segunda_1" {
  scheduled_action_name  = "segunda_1-15"
  desired_capacity       = 2
  min_size               = 2
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "15 1 * * 1"
}

resource "aws_autoscaling_schedule" "segunda_2" {
  scheduled_action_name  = "segunda_8-30"
  desired_capacity       = 6
  min_size               = 6
  max_size               = 12  
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "30 8 * * 1"
}

resource "aws_autoscaling_schedule" "segunda_3" {
  scheduled_action_name  = "segunda_19-30"
  desired_capacity       = 7
  min_size               = 7
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "30 19 * * 1"
}

resource "aws_autoscaling_schedule" "segunda_4" {
  scheduled_action_name  = "segunda_20-30"
  desired_capacity       = 10
  min_size               = 10
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "30 20 * * 1"
}

resource "aws_autoscaling_schedule" "segunda_5" {
  scheduled_action_name  = "segunda_22-15"
  desired_capacity       = 7
  min_size               = 7
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "15 22 * * 1"
}

resource "aws_autoscaling_schedule" "segunda_6" {
  scheduled_action_name  = "segunda_23-15"
  desired_capacity       = 6
  min_size               = 6
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "15 23 * * 1"
}

resource "aws_autoscaling_schedule" "terca_1" {
  scheduled_action_name  = "terca_00-15"
  desired_capacity       = 5
  min_size               = 5
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "15 0 * * 2"
}

resource "aws_autoscaling_schedule" "terca_2" {
  scheduled_action_name  = "terca_3-15"
  desired_capacity       = 2
  min_size               = 2
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "15 3 * * 2"
}

resource "aws_autoscaling_schedule" "terca_3" {
  scheduled_action_name  = "terca_8-30"
  desired_capacity       = 6
  min_size               = 6
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "30 8 * * 2"
}

resource "aws_autoscaling_schedule" "terca_4" {
  scheduled_action_name  = "terca_20-30"
  desired_capacity       = 8
  min_size               = 8
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "30 20 * * 2"
}

resource "aws_autoscaling_schedule" "terca_5" {
  scheduled_action_name  = "terca_22-45"
  desired_capacity       = 6
  min_size               = 6
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "45 22 * * 2"
}

resource "aws_autoscaling_schedule" "terca_6" {
  scheduled_action_name  = "terca_23-45"
  desired_capacity       = 3
  min_size               = 3
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "45 23 * * 2"
}

resource "aws_autoscaling_schedule" "quarta_1" {
  scheduled_action_name  = "quarta_3-15"
  desired_capacity       = 2
  min_size               = 2
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "15 3 * * 3"
}

resource "aws_autoscaling_schedule" "quarta_2" {
  scheduled_action_name  = "quarta_8-30"
  desired_capacity       = 6
  min_size               = 6
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "30 8 * * 3"
}

resource "aws_autoscaling_schedule" "quarta_3" {
  scheduled_action_name  = "quarta_20-30"
  desired_capacity       = 7
  min_size               = 7
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "30 20 * * 3"
}

resource "aws_autoscaling_schedule" "quarta_4" {
  scheduled_action_name  = "quarta_22-15"
  desired_capacity       = 5
  min_size               = 5
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "15 22 * * 3"
}

resource "aws_autoscaling_schedule" "quarta_5" {
  scheduled_action_name  = "quarta_23-15"
  desired_capacity       = 4
  min_size               = 4
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "15 23 * * 3"
}

resource "aws_autoscaling_schedule" "quinta_1" {
  scheduled_action_name  = "quinta_1-30"
  desired_capacity       = 2
  min_size               = 2
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "30 1 * * 4"
}

resource "aws_autoscaling_schedule" "quinta_2" {
  scheduled_action_name  = "quinta_8-30"
  desired_capacity       = 6
  min_size               = 6
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "30 8 * * 4"
}

resource "aws_autoscaling_schedule" "quinta_3" {
  scheduled_action_name  = "quinta_20-30"
  desired_capacity       = 8
  min_size               = 8
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "30 20 * * 4"
}

resource "aws_autoscaling_schedule" "quinta_4" {
  scheduled_action_name  = "quinta_22-15"
  desired_capacity       = 5
  min_size               = 5
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "15 22 * * 4"
}

resource "aws_autoscaling_schedule" "quinta_5" {
  scheduled_action_name  = "quinta_23-15"
  desired_capacity       = 4
  min_size               = 4
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "15 23 * * 4"
}

resource "aws_autoscaling_schedule" "sexta_1" {
  scheduled_action_name  = "sexta_1-10"
  desired_capacity       = 2
  min_size               = 2
  max_size               = 12  
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "10 1 * * 5"
}

resource "aws_autoscaling_schedule" "sexta_2" {
  scheduled_action_name  = "sexta_8-30"
  desired_capacity       = 5
  min_size               = 5
  max_size               = 12  
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "30 8 * * 5"
}

resource "aws_autoscaling_schedule" "sexta_3" {
  scheduled_action_name  = "sexta_19-30"
  desired_capacity       = 6
  min_size               = 6
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "30 19 * * 5"
}

resource "aws_autoscaling_schedule" "sexta_4" {
  scheduled_action_name  = "sexta_22-15"
  desired_capacity       = 4
  min_size               = 4
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "15 22 * * 5"
}

resource "aws_autoscaling_schedule" "sabado_1" {
  scheduled_action_name  = "sabado_1-15"
  desired_capacity       = 2
  min_size               = 2
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "15 1 * * 6"
}

resource "aws_autoscaling_schedule" "sabado_2" {
  scheduled_action_name  = "sabado_9-30"
  desired_capacity       = 5
  min_size               = 5
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "30 9 * * 6"
}

resource "aws_autoscaling_schedule" "domingo_1" {
  scheduled_action_name  = "domingo_1-15"
  desired_capacity       = 3
  min_size               = 3
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "15 1 * * 0"
}

resource "aws_autoscaling_schedule" "domingo_2" {
  scheduled_action_name  = "domingo_9-30"
  desired_capacity       = 4
  min_size               = 4
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "30 9 * * 0"
}

resource "aws_autoscaling_schedule" "domingo_3" {
  scheduled_action_name  = "domingo_19-30"
  desired_capacity       = 8
  min_size               = 8
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "30 19 * * 0"
}

resource "aws_autoscaling_schedule" "domingo_4" {
  scheduled_action_name  = "domingo_22-15"
  desired_capacity       = 4
  min_size               = 4
  max_size               = 12
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "15 22 * * 0"
}
