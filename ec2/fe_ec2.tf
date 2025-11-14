resource "aws_instance" "fe" {
  ami                    = "ami-0edaecbfa94ea8996"
  instance_type          = "t3.micro"
  subnet_id              = var.fe_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.fe_sg_id]

  tags = {
    Name = "fe-instance"
  }
}

output "fe_public_ip" {
  value = aws_instance.fe.public_ip
}
