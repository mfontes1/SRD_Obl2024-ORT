# Application Load Balancer
resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_lb_sg.id]
  subnets            = [aws_subnet.public.id, aws_subnet.private.id]

  enable_deletion_protection = false
}

# Target Group for HTTP
resource "aws_lb_target_group" "http_target_group" {
  name        = "http-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc_obligatorio.id 
  target_type = "instance"
}

# Target Group for HTTPS
resource "aws_lb_target_group" "https_target_group" {
  name        = "https-target-group"
  port        = 443
  protocol    = "HTTPS"
  vpc_id      = aws_vpc.vpc_obligatorio.id 
  target_type = "instance"
}

# HTTP Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80 
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http_target_group.arn
  }
}

# HTTPS Listener
#resource "aws_lb_listener" "https" {
#  load_balancer_arn = aws_lb.alb.arn
#  port              = 443 
#  protocol          = "HTTPS"
  
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.https_target_group.arn
#  }
#}

# Target Group Attachments for HTTP
resource "aws_lb_target_group_attachment" "http_web_attachment" {
  target_group_arn = aws_lb_target_group.http_target_group.arn
  target_id        = aws_instance.web1.id
  port             = 80
}

# Target Group Attachments for HTTPS
resource "aws_lb_target_group_attachment" "https_web_attachment" {
  target_group_arn = aws_lb_target_group.https_target_group.arn
  target_id        = aws_instance.web1.id
  port             = 443
}
