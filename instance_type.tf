resource "aws_instance" "grafana" {
  ami           = var.ami
  instance_type = var.instance_type
  security_groups = [aws_security_group.grafana-sg.name]
  key_name        = aws_key_pair.ssh_key.key_name
  tags = {
    Name = "HelloWorld"
  }
  user_data = filebase64("./provisioning.sh")
}