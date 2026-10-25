resource "aws_instance" "kafka" {
  count                  = var.kafka_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.medium"
  key_name               = aws_key_pair.elasticsearch-key.key_name
  vpc_security_group_ids = [aws_security_group.kafka-sg.id]
  availability_zone      = var.zone

  root_block_device {
    volume_size = 20 # Go, les logs Kafka prennent de la place
    volume_type = "gp3"
  }

  tags = {
    Name    = "kafka-${count.index + 1}"
    Project = "lab-elk"
  }

  lifecycle {
    ignore_changes = [ami]
  }
}