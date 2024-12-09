resource "aws_lb" "nlb" {
  name               = "sec-nlb-pub"
  internal           = false
  load_balancer_type = "network"

  subnets = [
    aws_subnet.subnets["sec-sbn-comm-pub-a"].id, 
    aws_subnet.subnets["sec-sbn-comm-pub-c"].id
  ]
}

resource "aws_lb_target_group" "git" {
  name     = "sec-tg-git"
  port     = 80
  protocol = "TCP"
  target_type = "ip"
  vpc_id   = aws_vpc.vpc.id
}

resource "aws_lb_target_group_attachment" "git" {
  target_group_arn = aws_lb_target_group.git.arn
  target_id        = "10.10.143.147"
  port             = 80
  availability_zone = "ap-northeast-2a"
}

resource "aws_lb_listener" "git" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.git.arn
  }
}