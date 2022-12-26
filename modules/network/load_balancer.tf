data "aws_acm_certificate" "issued" {
  domain   = "*.${var.domain_name}"
  statuses = ["ISSUED"]
}
resource "aws_alb" "alb_sistema" {
  name            = "sistema-lab"
  subnets         = var.alb_subnets
  security_groups = [aws_security_group.sg_dmz_sistema.id]
  internal        = false
  idle_timeout    = 3600

  tags = {
    Name = "sistema-lab"
    CC = "devops"
    Environment = "lab"
    Project = "sistema"
  }
}
### TARGET GROUP PORTA 80 ###
resource "aws_alb_target_group" "tg_sistema_80" {
  name             = "sistema"
  port             = "80"
  target_type      = "instance"
  protocol         = "HTTP"
  vpc_id           = var.vpc_id
  deregistration_delay = 60

  tags = {
    Name = "sistema"
    CC = "devops"
    Environment = "lab"
    Project = "sistema"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 15
    path                = "/"
    port                = "80"
    matcher             = "302"
  }
}

resource "aws_alb_listener" "alb_listener_sistema_80" {
  load_balancer_arn = "${aws_alb.alb_sistema.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Unauthorized"
      status_code  = "401"
    }
  }
}

resource "aws_lb_listener_rule" "redirect_host_tecnofit" {
  listener_arn = aws_alb_listener.alb_listener_sistema_80.arn
  priority     = 50

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {      
      values = ["*.tecnofit.com.br"]
    }    
  }
}

resource "aws_lb_listener_rule" "drop_ng" {
  listener_arn = aws_alb_listener.alb_listener_sistema_80.arn
  priority     = 51

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }

  condition {
    path_pattern {
      values = ["/ng/*","/ng"]
    }
  }
}

resource "aws_lb_listener_rule" "host_based_weighted_routing" {
  listener_arn = aws_alb_listener.alb_listener_sistema_80.arn
  priority     = 52

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.tg_sistema_443.arn
  }

  condition {
    http_header {
      http_header_name = "x-origin-token"
      values           = ["a15fhIPkgJ2qguZC3vhUdGZfDWoHv69a8FlLz"]
    }
  }
}

### TARGET GROUP PORTA 443 ###

resource "aws_alb_target_group" "tg_sistema_443" {
  name             = "sistema-ssl"
  port             = "443"
  target_type      = "instance"
  protocol         = "HTTPS"
  vpc_id           = var.vpc_id
  deregistration_delay = 60

  tags = {
    Name = "sistema-ssl"
    CC = "devops"
    Environment = "lab"
    Project = "sistema"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 10
    interval            = 15
    path                = "/"
    port                = "443"
    matcher             = "302"
  }
}

resource "aws_alb_listener" "alb_listener_sistema_443" {
  load_balancer_arn = "${aws_alb.alb_sistema.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${data.aws_acm_certificate.issued.arn}"
  depends_on        = [aws_alb_target_group.tg_sistema_443]

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Unauthorized"
      status_code  = "401"
    }
  }
}

resource "aws_lb_listener_rule" "redirect_host_tecnofit_443" {
  listener_arn = aws_alb_listener.alb_listener_sistema_443.arn
  priority     = 50

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.tg_sistema_443.arn
  }

  condition {
    host_header {      
      values = ["*.tecnofit.com.br","pay.academiaevolve.com.br"]
    }    
  }
}