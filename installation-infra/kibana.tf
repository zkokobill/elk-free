resource "aws_instance" "kibana_1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.small"
  vpc_security_group_ids = [aws_security_group.kibana-sg.id]
  availability_zone      = var.zone
  iam_instance_profile   = aws_iam_instance_profile.ssm.name

  tags = {
    Name    = "kibana-1"
    Project = "lab-elk"
  }

  lifecycle {
    ignore_changes = [ami]
  }
}