resource "aws_key_pair" "ssh_key" {
  key_name   = "my-ssh-key"  
  public_key = file(var.public_key_path)
}
