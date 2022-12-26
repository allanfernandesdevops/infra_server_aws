resource "aws_security_group" "sg_dmz_sistema" {
  name        = "sg_dmz_sistema"
  description = "SG que ira cuidar no DMZ do sistema"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sistema-lab-alb"
    CC = "devops"
    Environment = "lab"
    Project = "sistema"
  }
}

resource "aws_security_group" "sg_instance_sistema" {
  depends_on = [aws_security_group.sg_dmz_sistema]
  name        = "sg_instance_sistema"
  description = "SG que ira cuidar das instancias do sistema"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.sg_dmz_sistema.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_instance_sistema"
    CC = "devops"
    Environment = "lab"
    Project = "sistema"
  }
}