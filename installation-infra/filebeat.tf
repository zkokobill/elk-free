resource "aws_instance" "filebeat_1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.elasticsearch-key.key_name
  vpc_security_group_ids = [aws_security_group.filebeat-sg.id]
  availability_zone      = var.zone

  tags = {
    Name    = "filebeat-1"
    Project = "lab-elk"
  }

  lifecycle {
    ignore_changes = [ami]
  }
}