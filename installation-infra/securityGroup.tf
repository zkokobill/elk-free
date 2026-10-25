##### SECURITY GROUP ELASTICSEARCH

resource "aws_security_group" "elasticsearch-sg" {
  name = "elasticsearch-sg"
  tags = {
    name = "elasticsearch-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "sshfrommyip" {
  security_group_id = aws_security_group.elasticsearch-sg.id

  cidr_ipv4   = "81.65.146.4/32"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
}

# resource "aws_vpc_security_group_ingress_rule" "allow_http" {
#   security_group_id = aws_security_group.elasticsearch-sg.id

#   cidr_ipv4   = "0.0.0.0/0"
#   from_port   = 80
#   to_port     = 80
#   ip_protocol = "tcp"
# }

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_ipv4" {
  security_group_id = aws_security_group.elasticsearch-sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_ipv6" {
  security_group_id = aws_security_group.elasticsearch-sg.id

  cidr_ipv6   = "::/0"
  ip_protocol = "-1" ### ALL the protocol ports
}
# Elasticsearch accepte le port 9200 depuis Logstash
resource "aws_vpc_security_group_ingress_rule" "es_from_logstash" {
  security_group_id            = aws_security_group.elasticsearch-sg.id
  referenced_security_group_id = aws_security_group.logstash-sg.id
  from_port                    = 9200
  to_port                      = 9200
  ip_protocol                  = "tcp"
}
# Elasticsearch accepte le port 9200 depuis Kibana
resource "aws_vpc_security_group_ingress_rule" "es_from_kibana" {
  security_group_id            = aws_security_group.elasticsearch-sg.id
  referenced_security_group_id = aws_security_group.kibana-sg.id
  from_port                    = 9200
  to_port                      = 9200
  ip_protocol                  = "tcp"
}


###### SECURITY GROUP LOGSTASH

resource "aws_security_group" "logstash-sg" {
  name = "logstash-sg"
  tags = {
    Name = "logstash-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "logstash_ssh_from_my_ip" {
  security_group_id = aws_security_group.logstash-sg.id
  cidr_ipv4         = "81.65.146.4/32"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "logstash_all_outbound_ipv4" {
  security_group_id = aws_security_group.logstash-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}




##### SECURITY GROUP KAFKA

resource "aws_security_group" "kafka-sg" {
  name = "kafka-sg"
  tags = { Name = "kafka-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "kafka_ssh_from_my_ip" {
  security_group_id = aws_security_group.kafka-sg.id
  cidr_ipv4         = var.my_ip
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "kafka_from_filebeat" {
  security_group_id            = aws_security_group.kafka-sg.id
  referenced_security_group_id = aws_security_group.filebeat-sg.id
  from_port                    = 9092
  to_port                      = 9092
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "kafka_from_logstash" {
  security_group_id            = aws_security_group.kafka-sg.id
  referenced_security_group_id = aws_security_group.logstash-sg.id
  from_port                    = 9092
  to_port                      = 9092
  ip_protocol                  = "tcp"
}

# Entre brokers Kafka (utile quand tu passeras à 3) : 9092 broker, 9093 contrôleur KRaft
resource "aws_vpc_security_group_ingress_rule" "kafka_between_brokers" {
  security_group_id            = aws_security_group.kafka-sg.id
  referenced_security_group_id = aws_security_group.kafka-sg.id
  from_port                    = 9092
  to_port                      = 9093
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "kafka_all_outbound_ipv4" {
  security_group_id = aws_security_group.kafka-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}




##### SECURITY GROUP FILEBEAT

resource "aws_security_group" "filebeat-sg" {
  name = "filebeat-sg"
  tags = { Name = "filebeat-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "filebeat_ssh_from_my_ip" {
  security_group_id = aws_security_group.filebeat-sg.id
  cidr_ipv4         = var.my_ip
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "filebeat_all_outbound_ipv4" {
  security_group_id = aws_security_group.filebeat-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


##### SECURITY GROUP KIBANA (aucune entrée : accès par SSM uniquement)

resource "aws_security_group" "kibana-sg" {
  name = "kibana-sg"
  tags = { Name = "kibana-sg" }
}

resource "aws_vpc_security_group_egress_rule" "kibana_all_outbound_ipv4" {
  security_group_id = aws_security_group.kibana-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}