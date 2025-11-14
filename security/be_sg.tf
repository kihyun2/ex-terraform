resource "aws_security_group" "be_sg" {
  name   = "be-sg"
  vpc_id = var.vpc_id

  # FE → BE (8080)
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [aws_security_group.fe_sg.id]
  }
   # ALB -> BE
   ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "be_sg_id" {
  value = aws_security_group.be_sg.id
}
