# Target group
 resource "aws_lb_target_group" "target-group" {
  name        = "${var.albname}-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    enabled             = true
    interval            = 10
    path                = "/"
    port                = 8080
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Creating ALB
resource "aws_lb" "application-lb" {
  count              = length(aws_subnet.public_subnets)
  name               = var.albname
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public_subnets.*.id
  security_groups    = [aws_security_group.alb-sg.id]
  ip_address_type    = "ipv4"

  tags = {
    name = "${var.albname}-alb"
  }
}

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.application-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}

resource "aws_lb_target_group_attachment" "ec2_attach" {
  count            = length(aws_instance.web-server)
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = aws_instance.web-server[count.index].id
}
