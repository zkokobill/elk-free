resource "aws_key_pair" "elasticsearch-key" {
  key_name   = "elasticsearch-key"
  public_key = file(pathexpand("~/.ssh/lab-elk.pub"))
}