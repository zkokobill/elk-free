resource "aws_instance" "elasticsearch_1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.large"
  key_name               = aws_key_pair.elasticsearch-key.key_name
  vpc_security_group_ids = [aws_security_group.elasticsearch-sg.id]
  availability_zone      = var.zone

  tags = {
    Name    = "elasticsearch-1"
    Project = "lab-elk"
  }

  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_ec2_instance_state" "elasticsearch-state" {
  instance_id = aws_instance.elasticsearch_1.id
  state       = "stopped"
}