resource "aws_lb" "alb" {
load_balancer_type = "application"
subnets = aws_subnet.public[*].id
security_groups = [aws_security_group.alb_sg.id]
}
# Target Group for ECS
resource "aws_lb_target_group" "ecs_tg" {
  name        = "ecs-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"   # EC2 launch type → instance

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "http" {
load_balancer_arn = aws_lb.alb.arn
port = 80
protocol = "HTTP"


default_action {
type = "forward"
target_group_arn = aws_lb_target_group.ecs_tg.arn
}
}