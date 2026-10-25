resource "aws_instance" "logstash_1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.medium"
  key_name               = aws_key_pair.elasticsearch-key.key_name
  vpc_security_group_ids = [aws_security_group.logstash-sg.id]
  availability_zone      = var.zone

  tags = {
    Name    = "logstash-1"
    Project = "lab-elk"
  }

  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_ec2_instance_state" "logstash_1-state" {
  instance_id = aws_instance.logstash_1.id
  state       = "stopped"
}