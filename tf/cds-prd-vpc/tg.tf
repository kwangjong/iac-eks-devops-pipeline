resource "aws_lb_target_group" "istio" {
  name     = "cds-prd-tg-istio"
  port     = 80
  protocol = "TCP"
  target_type = "ip"
  vpc_id   = local.sec_vpc_id
}

resource "aws_lb_target_group_attachment" "istio" {
  target_group_arn = aws_lb_target_group.istio.arn
  target_id        = "10.10.129.45"
  port             = 80
  availability_zone = "ap-northeast-2a"
}

resource "aws_lb_listener" "istio" {
  load_balancer_arn = local.sec_vpc_nlb_arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.istio.arn
  }
}