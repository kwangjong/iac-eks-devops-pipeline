# resource "aws_lb_target_group" "git" {
#   name     = "cds-devops-tg-git"
#   port     = 80
#   protocol = "TCP"
#   target_type = "ip"
#   vpc_id   = local.sec_vpc_id
# }

# resource "aws_lb_target_group_attachment" "git" {
#   target_group_arn = aws_lb_target_group.git.arn
#   target_id        = "10.10.143.147"
#   port             = 80
#   availability_zone = "ap-northeast-2a"
# }

# resource "aws_lb_listener" "git" {
#   load_balancer_arn = local.sec_vpc_nlb_arn
#   port              = 80
#   protocol          = "TCP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.git.arn
#   }
# }