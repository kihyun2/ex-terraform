resource "aws_instance" "be" {
  ami                    = "ami-02c838ad6ff1c37cd"
  instance_type          = "t3.micro"
  subnet_id              = var.be_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.be_sg_id]

  associate_public_ip_address = false

  tags = {
    Name = "be-instance"
  }
}

output "be_private_ip" {
  value = aws_instance.be.private_ip
}
