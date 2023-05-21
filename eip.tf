resource "aws_eip" "static_ip" {
  instance = aws_instance.grafana.id
}

# Вихідні дані Terraform для повернення значень
output "instance_ip" {
    value = aws_eip.static_ip.public_ip
}