resource "aws_eip" "static_ip" {
  instance = aws_instance.grafana.id
}

# Terraform output your elastic IP
output "instance_ip" {
    value = aws_eip.static_ip.public_ip
}