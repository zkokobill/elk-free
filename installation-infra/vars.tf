variable "region" {
  default = "us-east-1"
}

variable "zone" {
  default = "us-east-1a"
}

variable "amiID" {
  type = map(any)
  default = {
    us-east-2 = "ami-03657b56516ab7912"
    us-east-1 = "ami-0947d2ba12ee1ff75"
  }
}

variable "my_ip" {
  default = "81.65.146.4/32"
}

variable "kafka_count" {
  default = 1 # passe à 3 plus tard
}