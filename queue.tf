resource "aws_mq_broker" "default" {
  broker_name                = "default"
  engine_type                = "RabbitMQ"
  engine_version             = "3.13"
  host_instance_type         = "mq.t3.micro"
  auto_minor_version_upgrade = true
  publicly_accessible        = true
  user {
    username = var.mq_username
    password = var.mq_password
  }
}
provider "rabbitmq" {
  endpoint = aws_mq_broker.default.instances.0.console_url
  username = var.mq_username
  password = var.mq_password
}
resource "rabbitmq_queue" "video_received" {
  name = "video_received"
  settings {
    durable = true
  }
}
resource "rabbitmq_queue" "video_status_changed" {
  name = "video_status_changed"
  settings {
    durable = true
  }
}
