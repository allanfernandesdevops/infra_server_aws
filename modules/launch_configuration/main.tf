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
  min_size                  = 1
  desired_capacity          = 1
  max_size                  = 2
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

resource "aws_autoscaling_schedule" "dia" {
  scheduled_action_name  = "dia"
  desired_capacity       = 1
  min_size               = 1
  max_size               = 2
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "0 6 * * 1-5"
}

resource "aws_autoscaling_schedule" "noite" {
  scheduled_action_name  = "noite"
  desired_capacity       = 0
  min_size               = 0
  max_size               = 0  
  autoscaling_group_name = aws_autoscaling_group.sistema.name
  recurrence = "0 19 * * 1-5"
}