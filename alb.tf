resource "aws_security_group" "alb_security_group" {
  name   = "alb-security-group"
  vpc_id = module.vpc.vpc_attributes.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb" "sample" {
  name               = "sample-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group.id]
  subnets            = values(module.vpc.public_subnet_attributes_by_az)[*].id
  drop_invalid_header_fields = true
  access_logs {
    bucket  = aws_s3_bucket.logs_bucket.bucket
    enabled = false
  }
}

resource "aws_alb_listener" "listener" {
  load_balancer_arn = aws_alb.sample.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/html"
      message_body = "<html><body><h3>Fixed response!</h3></body></html>"
      status_code  = "200"
    }
  }
}

output "alb_dns_name" {
  value = aws_alb.sample.dns_name
}
